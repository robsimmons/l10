(* Unabashedly bogus; should be used only for refinement type checking *)

structure IntInf = Int

structure R = 
struct
   (*[ datasort 'a plist = op :: of 'a * 'a list ]*)

   (*[ val map: ('a -> 'b) -> 'a list -> 'b list
              & ('a -> 'b) -> 'a plist -> 'b plist ]*)
   fun map f [] = []
     | map f (x :: xs) = f x :: map f xs

   (*[ datasort 'a none = NONE ]*)
   (*[ datasort 'a some = SOME of 'a ]*)
end

open R

structure String = 
struct
   open String
   val isSubstring = fn _ => raise Match
end
