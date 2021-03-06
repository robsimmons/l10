(* Declarations are what make up L10 files and programs *)

structure Decl = struct
   (*[ sortdef db = Symbol.symbol * (Pos.t * Atom.ground_prop) list ]*)

   datatype t = 
      World of Pos.t * Symbol.symbol * Class.t
    | Const of Pos.t * Symbol.symbol * Class.t
    | Rel of Pos.t * Symbol.symbol * Class.t
    | Type of Pos.t * Symbol.symbol * Class.t
    | DB of Pos.t * (Symbol.symbol * (Pos.t * Atom.t) list)
    | Rule of Pos.t * Rule.t * Type.env option
    | Query of Pos.t * Symbol.symbol * Atom.t 
    | Representation of Pos.t * Symbol.symbol * Type.representation 
(*[
   datasort decl = 
      World of Pos.t * Symbol.symbol * Class.world
    | Const of Pos.t * Symbol.symbol * Class.typ
    | Rel of Pos.t * Symbol.symbol * Class.rel
    | Type of Pos.t * Symbol.symbol * Class.knd
    | DB of Pos.t * db
    | Rule of Pos.t * Rule.rule * Type.env none
    | Query of Pos.t * Symbol.symbol * Atom.moded
    | Representation of Pos.t * Symbol.symbol * Type.representation

   datasort decl_t = 
      World of Pos.t * Symbol.symbol * Class.world
    | Const of Pos.t * Symbol.symbol * Class.typ
    | Rel of Pos.t * Symbol.symbol * Class.rel_t
    | Type of Pos.t * Symbol.symbol * Class.knd
    | DB of Pos.t * db
    | Rule of Pos.t * Rule.rule_t * Type.env some
    | Query of Pos.t * Symbol.symbol * Atom.moded_t
    | Representation of Pos.t * Symbol.symbol * Type.representation

   datasort class = 
      World of Pos.t * Symbol.symbol * Class.world
    | Const of Pos.t * Symbol.symbol * Class.typ
    | Rel of Pos.t * Symbol.symbol * Class.rel
    | Type of Pos.t * Symbol.symbol * Class.knd
]*)

(*[ val print: decl_t -> unit ]*)
val print = 
 fn World (_, w, class) => 
       print (Symbol.toValue w ^ ": " ^ Class.toString class ^ ".\n")
  | Const (_, c, class) => 
       print (Symbol.toValue c ^ ": " ^ Class.toString class ^ ".\n")
  | Rel (_, a, class) => 
       print (Symbol.toValue a ^ ": " ^ Class.toString class ^ ".\n")
  | Type (_, t, class) => 
       print (Symbol.toValue t ^ ": " ^ Class.toString class ^ ".\n")
  | DB (_, (db, _)) => 
       print (Symbol.toValue db ^ " = (...).\n")
  | Rule (_, (prems, concs), _) =>
     ( print (String.concatWith ", " (map (Prem.toString o #2) prems))
     ; print " -> "
     ; print (String.concatWith ", " (map (Atom.toString o #2) concs))
     ; print ".\n")
  | Query (_, qry, mode) =>
     ( print ("#query " ^ Symbol.toValue qry ^ ": ")
     ; print (Atom.toString mode ^ ".\n"))
  | Representation (_, t, rep) => 
       print ("#type "^Symbol.toValue t^" "^Type.repToString rep^".\n")
end

