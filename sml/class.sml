
structure Class = 
struct
   datatype t = 
      Base of Type.t 
    | Rel of Pos.t * Atom.t
    | World
    | Type
    | Builtin
    | Extensible
    | Arrow of Type.t * t
    | Pi of Symbol.symbol * Type.t option * t
(*[
   datasort world = 
      World
    | Arrow of Type.t * world

   datasort typ =
      Base of Type.t
    | Arrow of Type.t * typ

   datasort rel = 
      Rel of Pos.t * Atom.world
    | Arrow of Type.t * rel
    | Pi of Symbol.symbol * Type.t option * rel

   datasort rel_t = 
      Rel of Pos.t * Atom.world_t
    | Arrow of Type.t * rel_t
    | Pi of Symbol.symbol * Type.t some * rel_t

   datasort knd = 
      Type
    | Builtin
    | Extensible
]*)
   
   fun arrows class = 
      case class of 
         Arrow (_, class) => 1+arrows class
       | Pi (_, _, class) => 1+arrows class
       | _ => 0

   (*[ val argtyps: rel_t -> Type.t list ]*)
   fun argtyps class = 
      case class of
         Rel _ => []
       | Arrow (t, class) => t :: argtyps class
       | Pi (x, SOME t, class) => t :: argtyps class
 
   (*[ val relToTyp: rel_t -> typ ]*)
   fun relToTyp class = 
      case class of
         Rel _ => Base Type.rel
       | Arrow (t, class) => Arrow (t, relToTyp class)
       | Pi (x, SOME t, class) => Arrow (t, relToTyp class)

   (*[ val worldToTyp: world -> typ ]*)
   fun worldToTyp class = 
      case class of 
         World => Base Type.world
       | Arrow (t, class) => Arrow (t, worldToTyp class)

   (*[ val base: typ -> Type.t ]*)
   fun base class = 
      case class of 
          Arrow (_, class) => base class
        | Base t => t

   (*[ val rel: rel -> Atom.world & rel_t -> Atom.world_t]*)
   fun rel class = 
      case class of
         Arrow (_, class) => rel class
       | Pi (_, _, class) => rel class
       | Rel (_, world) => world

   fun toString typ = 
      case typ of 
         Base t => Symbol.toValue t
       | Rel (_, world) => "rel @ " ^ Atom.toString' false world
       | World => "world"
       | Type => "type"
       | Builtin => "builtin"
       | Extensible => "extensible"
       | Arrow (t, typ) => Symbol.toValue t ^ " -> " ^ toString typ
       | Pi (x, NONE, typ) => 
            "{" ^ Symbol.toValue x ^ "} " ^ toString typ
       | Pi (x, SOME t, typ) => 
          ( "{" ^ Symbol.toValue x ^ ": " ^ Symbol.toValue t ^ "} " 
          ^ toString typ)

   fun fv class =
      case class of 
         Pi (x, t, class) => SetX.remove (fv class) x
       | Arrow (_, class) => fv class
       | Rel (_, world) => Atom.fv world
       | _ => SetX.empty
end
