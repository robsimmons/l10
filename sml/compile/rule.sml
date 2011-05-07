(* Intermediate form for compiled terms *)
(* Robert J. Simmons *)

structure Rule:> sig

   datatype compiledPrem = 
      Normal of { (* This premise needs to call to this index *)
                  index: (Symbol.symbol * Ast.modedTerm list),

                  (* The call uses some symbols *)
                  inputPattern: (int list * Symbol.symbol) list,

                  (* And returns other symbols... *)
                  outputPattern: (int list) list,

                  (* ...which must be checked for some equational constraints *)
                  constraints: (Ast.typ * int list * int list) list,

                  (* Next call expects these arguments *)
                  knownAfterwards: (Symbol.symbol * int list option) list }

    | Negated of { (* The premise needs to call this index *)
                   index: (Symbol.symbol * Ast.modedTerm list),

                   (* The call uses some symbols *)
                   inputPattern: (int list * Symbol.symbol) list,

                   (* And returns other symbols *)
                   outputPattern: (int list) list,

                   (* The premise fails should any symbols meet the equational 
                    * constraints *)
                   constraints: (Ast.typ * int list * int list) list,
               
                   (* Next call expects these arguments *)
                   knownAfterwards: Symbol.symbol list }

    | Binrel of { (* Which binary relation? *)
                  binrel: Ast.binrel,

                  (* Terms being compared *)
                  term1: Ast.term,
                  term2: Ast.term,

                  (* Next call expects these arguments *)
                  knownAfterwards: Symbol.symbol list }

    | Conclusion of { facts: Ast.atomic list }

  val compile: Ast.world * Ast.rule
     -> (Symbol.symbol list * compiledPrem * string) list

end = 
struct

datatype compiledPrem = 
   Normal of { index: (Symbol.symbol * Ast.modedTerm list),
               inputPattern: (int list * Symbol.symbol) list,
               outputPattern: (int list) list,
               constraints: (Ast.typ * int list * int list) list,
               knownAfterwards: (Symbol.symbol * int list option) list }

 | Negated of { index: (Symbol.symbol * Ast.modedTerm list),
                inputPattern: (int list * Symbol.symbol) list,
                outputPattern: (int list) list,
                constraints: (Ast.typ * int list * int list) list,
                knownAfterwards: Symbol.symbol list }

 | Binrel of { binrel: Ast.binrel,
               term1: Ast.term,
               term2: Ast.term,
               knownAfterwards: Symbol.symbol list }
             
 | Conclusion of { facts: Ast.atomic list }

fun compile' (known, prems, concs) = 
   let 
      val args = MapX.listKeys known 

      fun union ms = MapX.unionWith #1 ms

      fun restrict (map, set) = 
         MapX.filteri (fn (x, _) => SetX.member (set, x)) map

      fun inputPattern paths = 
         MapP.listItemsi (MapP.mapPartial (fn x => x) paths)

      fun outputPattern paths =
         MapP.listKeys (MapP.filter (not o Option.isSome) paths)

      fun constraints' (typ, []) = []
        | constraints' (typ, [ _ ]) = []
        | constraints' (typ, a :: b :: c) = 
          (typ, a, b) :: constraints' (typ, b :: c)

      fun constraints outputs = 
          MapX.foldl (fn (x, y) => constraints' x @ y) [] outputs

      fun snd (x, y) = y

      fun knownAfterwards (needed, paths, outputs) = 
          MapX.listItemsi
             (MapX.mapi (fn (x, _) =>
                            (case MapX.find (outputs, x) of 
                               SOME paths => SOME (hd (snd paths))
                             | NONE => NONE)) needed)
   in
      case prems of 
         [] => [ (args, 
                  Conclusion {facts = concs},
                  String.concatWith ", " (map Ast.strAtomic concs)) ]

       | Ast.Normal pat :: prems => 
         let 
            val { index, outputs, paths } = Indexing.indexPat (known, pat)
            val needed = 
               restrict (union (known, FV.fvPat pat),
                         Ast.fvRule (prems, concs))
            val prem = 
               { index = index,
                 inputPattern = inputPattern paths,
                 outputPattern = outputPattern paths,
                 constraints = constraints outputs,
                 knownAfterwards = knownAfterwards (needed, paths, outputs) }
         in
            (args, Normal prem, Ast.strPattern pat)
            :: compile' (needed, prems, concs)
         end

       | Ast.Negated pat :: prems =>
         let
            val { index, outputs, paths } = Indexing.indexPat (known, pat)
            val needed = restrict (known, Ast.fvRule (prems, concs))
            val prem = 
               { index = index,
                 inputPattern = inputPattern paths,
                 outputPattern = outputPattern paths,
                 constraints = constraints outputs,
                 knownAfterwards = MapX.listKeys needed }
         in
            (args, Negated prem, "not " ^ Ast.strPattern pat) 
            :: compile' (needed, prems, concs)
         end

       | Ast.Count _ :: _ => 
         raise Fail "Unimplemented"
                                   
       | Ast.Binrel (Ast.Eq, term1, term2) :: prems => 
         raise Fail "Unimplemented"
      
       | Ast.Binrel (binrel, term1, term2) :: prems => 
         let
            val needed = restrict (known, Ast.fvRule (prems, concs))
            val prem = 
               { binrel = binrel,
                 term1 = term1,
                 term2 = term2,
                 knownAfterwards = MapX.listKeys needed }
         in
            (args, Binrel prem, 
             Ast.strTerm term1 
             ^ " " ^ Ast.strBinrel binrel
             ^ " " ^ Ast.strTerm term2) :: compile' (needed, prems, concs)
         end
   end

fun compile (world, (prems, concs)) =
   let
      val fvworld = FV.fvWorld world
   in
      compile' (fvworld, prems, concs)
   end

end

