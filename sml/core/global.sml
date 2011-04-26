structure SetS = 
RedBlackSetFn(struct type ord_key = string val compare = String.compare end)

structure MapS = 
RedBlackMapFn(struct type ord_key = string val compare = String.compare end)

structure SetI = 
RedBlackSetFn(struct type ord_key = int val compare = Int.compare end)

structure MapI = 
RedBlackMapFn(struct type ord_key = int val compare = Int.compare end)


structure SetII = 
RedBlackSetFn(struct type ord_key = IntInf.int val compare = IntInf.compare end)

structure MapII = 
RedBlackMapFn(struct type ord_key = IntInf.int val compare = IntInf.compare end)

structure Global = struct

  fun assert a = if a() then () else raise Fail "Invariant"

end
