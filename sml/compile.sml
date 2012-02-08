(* Intermediate form for compiled terms *)
(* Robert J. Simmons *)

structure Compile:> sig

   type eqconstraint = Type.t * Path.t * Path.t

   datatype rule =  
      Normal of 
         {common: common,
          index: Atom.t, (* Atom.moded_t - which index do we need to call? *) 
          input: Symbol.symbol Path.Dict.dict, (* Index takes symbols... *)
          output: Symbol.symbol Path.Dict.dict, (* ...returns others... *)
          eqs: eqconstraint list} (* ...that must pass cstrs. *)
    | Negated of 
         {common: common,
          index: Atom.t, (* Atom.moded_t - which index do we need to call? *) 
          input: Symbol.symbol Path.Dict.dict, (* Index takes symbols... *)
          output: Symbol.symbol Path.Dict.dict, (* ...returns others... *)
          eqs: eqconstraint list} (* ...that must fail cstrs. *)
    | Binrel of 
         {common: common,
          binrel: Binrel.t, 
          term1: Term.t,
          term2: Term.t,
          t: Type.t}
    | Conclusion of {incoming: SetX.set, facts: (Pos.t * Atom.t) list}

   withtype common = 
      {label: string, (* Debugging information only *)
       incoming: SetX.set, (* This call's args! *)
       outgoing: (Symbol.symbol * Path.t option) list, (* Next call's args! *)
       cont: rule}

   (*[ val compile: Tab.rule -> Pos.t * Atom.world_t * rule ]*)
   val compile: Pos.t * Rule.t * Type.env option -> Pos.t * Atom.t * rule

   (*[ val indices: (Pos.t * Atom.world_t * rule) list -> Atom.moded_t list ]*)
   val indices: (Pos.t * Atom.t * rule) list -> Atom.t list

end = 
struct

type eqconstraint = Type.t * Path.t * Path.t

datatype rule =  
   Normal of 
      {common: common,
       index: Atom.t, (* Atom.moded_t - which index do we need to call? *) 
       input: Symbol.symbol Path.Dict.dict, (* Index takes symbols... *)
       output: Symbol.symbol Path.Dict.dict, (* ...Returns others... *)
       eqs: eqconstraint list} (* ...that must pass cstrs. *)
 | Negated of 
      {common: common,
       index: Atom.t, (* Atom.moded_t - which index do we need to call? *) 
       input: Symbol.symbol Path.Dict.dict, (* Index takes symbols... *)
       output: Symbol.symbol Path.Dict.dict, (* ...returns others... *)
       eqs: eqconstraint list} (* ...that must fail cstrs. *)
 | Binrel of 
      {common: common,
       binrel: Binrel.t, 
       term1: Term.t,
       term2: Term.t,
       t: Type.t}
 | Conclusion of {incoming: SetX.set, facts: (Pos.t * Atom.t) list}

withtype common = 
   {label: string, (* Debugging information only *)
    incoming: SetX.set, (* This call's args! *)
    outgoing: (Symbol.symbol * Path.t option) list, (* Next call's args! *)
    cont: rule}

(*[ type stuff =
       (eqconstraint list 
       * Path.t conslist DictX.dict 
       * Symbol.symbol Path.Dict.dict
       * Symbol.symbol Path.Dict.dict) ]*)

(*[ val indexTerm: 
       SetX.set 
       -> Path.t 
       -> Term.term_t list -> stuff 
       -> (Term.moded_t * stuff) ]*)

(*[ val indexTerms: 
       SetX.set 
       -> Path.t
       -> int 
       -> Term.term_t list -> stuff 
       -> (Term.moded_t list * stuff) ]*)

fun indexTerm known path term (stuff as (eqs, lookup, input, output)) = 
   case term of
      Term.SymConst c => (Term.SymConst c, stuff)
    | Term.NatConst i => (Term.NatConst i, stuff)
    | Term.StrConst s => (Term.StrConst s, stuff)
    | Term.Var (NONE, SOME t) => (Term.Mode (Mode.Ignore, SOME t), stuff)
    | Term.Var (SOME x, SOME t) => 
         if SetX.member known x
         then (Term.Mode (Mode.Input, SOME t),
               (eqs, 
                lookup, 
                Path.Dict.insert input path x,
                output))
         else (Term.Mode (Mode.Output, SOME t),
               case DictX.find lookup x of
                  NONE =>
                     (eqs,
                      DictX.insert lookup x [ path ],
                      input,
                      Path.Dict.insert output path x)
                | SOME paths => 
                     ((t, path, hd paths) :: eqs,
                      DictX.insert lookup x (path :: paths),
                      input,
                      Path.Dict.insert output path x))
    | Term.Root (a, terms) =>
      let val (terms', stuff') = indexTerms known path 0 terms stuff
      in (Term.Root (a, terms'), stuff') end

and indexTerms known path n terms (stuff as (eqs, lookup, input, output)) = 
   case terms of 
      [] => ([], stuff)
    | term :: terms => 
      let
         val (term', stuff') = indexTerm known (path @ [ n ]) term stuff
         val (terms', stuff'') = indexTerms known path (n+1) terms stuff'
      in
         (term' :: terms', stuff'')
      end

(*[ val indexPat: 
       SetX.set 
       -> Pat.pat_t
       -> {index = Atom.moded_t,
           eqs = eqnconstraint list,
           lookup = Path.t list DictX.dict,
           input = Symbol.symbol Path.Dict.dict,
           output = Symbol.symbol Path.Dict.dict} ]*)
fun indexPat known pat = 
   case pat of 
      Pat.Atom (a, tms) =>
      let
         val initial = ([], DictX.empty, Path.Dict.empty, Path.Dict.empty) 
         val (tms', (eqs, lookup, input, output)) = 
            indexTerms known [] 0 tms initial
      in
         {index=(a,tms'), eqs=eqs, lookup=lookup, input=input, output=output}
      end
    | Pat.Exists (x, SOME _, pat) =>
      let 
         val {index, eqs, lookup, input, output} =
            if SetX.member known x 
            then indexPat (SetX.remove known x) pat
            else indexPat known pat 
         val xpaths = DictX.lookup lookup x
         val removeAll = foldl (fn (xpath, d) => Path.Dict.remove d xpath)
         val input = removeAll input xpaths 
         val output = removeAll output xpaths
      in
         {index=index, eqs=eqs, lookup=lookup, input=input, output=output}
      end

(*[ val compile': 
       SetX.set * (Pos.t * Prem.prem_t) list * (Pos.t * Atom.prop_t) conslist 
       -> rule ]*)
fun compile' (known, prems, concs) = 
   case prems of 
      [] => Conclusion {facts = concs, incoming = known}
    | (pos, prem) :: prems => 
      let  
         (* Recompute the free variables; should be cheap enough. *)
         val fv_tail = SetX.intersection (SetX.union known (Prem.fv prem)) 
                          (Rule.fv (prems, concs))

         (* We can go ahead and compute most of the common parts *)
         val label = Prem.toString prem ^ " - " ^ Pos.toString pos 
         val incoming = known
         (* We'll need to modify this in the Prem.Normal case *)
         val outgoing = map (fn x => (x, NONE)) (SetX.toList fv_tail)
         (* By mode checking, we assume we will have all of the fv_tail. *)
         val cont = compile' (fv_tail, prems, concs)
      in
         case prem of 
            Prem.Normal pat => 
            let 
               val {index, eqs, lookup, input, output} = indexPat known pat
               val outgoing' = 
                  map (fn (x, _) => 
                         (case DictX.find lookup x of
                             NONE => (x, NONE)
                           | SOME paths => (x, SOME (hd paths))))
                     outgoing
            in
               Normal 
                  { common = { label = label
                             , incoming = incoming
                             , outgoing = outgoing'
                             , cont = cont}
                  , index = index 
                  , input = input
                  , output = output
                  , eqs = eqs}
            end
          | Prem.Negated pat => 
            let 
               val {index, eqs, lookup, input, output} = indexPat known pat
            in
               Negated 
                  { common = { label = label
                             , incoming = incoming
                             , outgoing = outgoing
                             , cont = cont}
                  , index = index 
                  , input = input
                  , output = output
                  , eqs = eqs}
            end
          | Prem.Binrel (binrel, t1, t2, SOME typ) => 
               Binrel 
                  { common = { label = label
                             , incoming = incoming
                             , outgoing = outgoing
                             , cont = cont}
                  , binrel = binrel
                  , term1 = t1
                  , term2 = t2
                  , t = typ} 
      end
 
fun compile (pos, rule as (prems, concs), SOME env) =
   let
      val (_, world) = Worlds.ofProp (hd concs)
   in
      (pos, world, compile' (Atom.fv world, prems, concs))
   end

val indices: (Pos.t * Atom.t * rule) list -> Atom.t list =
let
   (* PERF: O(n^2) in the total number of indices *)
   fun add indices index = 
      if List.exists (fn index' => Atom.eq (index, index')) indices
      then indices
      else index :: indices

   fun loop (rule, indices) = 
      case rule of 
         Normal {index, common, ...} => loop (#cont common, add indices index)
       | Negated {index, common, ...} => loop (#cont common, add indices index)
       | Binrel {common, ...} => loop (#cont common, indices)
       | Conclusion {...} => indices

   val initial = 
      Tab.fold (fn (_, (_, index), indices) => add indices index) [] Tab.queries
in
   List.foldr (fn ((_, _, rule), indices) => loop (rule, indices)) initial
end

end

