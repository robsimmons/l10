structure Symbol = SymbolFun(structure Value = StringHashable)
structure SymbolOrdered = SymbolOrderedFun(structure Symbol = Symbol)
structure SymbolHashable = SymbolHashableFun(structure Symbol = Symbol)

structure DictS = SplayDict(structure Key = StringOrdered)
structure DictI = SplayDict(structure Key = IntOrdered)
(* structure DictII = SplayDict(structure Key = IntInfOrdered) *)
structure DictX = SplayDict(structure Key = SymbolOrdered)
structure DictPath = SplayDict(structure Key = ListOrdered(IntOrdered))

structure SetS = SplaySet(structure Elem = StringOrdered)
structure SetI = SplaySet(structure Elem = IntOrdered)
(* structure SetII = SplaySet(structure Elem = IntInfOrdered) *)
structure SetX = SplaySet(structure Elem = SymbolOrdered)
structure SetPath = SplaySet(structure Elem = ListOrdered(IntOrdered))

structure HTabS = HashTable (structure Key = StringHashable)
structure HTabI = HashTable (structure Key = IntHashable)
structure HTabX = HashTable (structure Key = SymbolHashable)
