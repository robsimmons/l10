package l10.util;

public struct Symbol {
	public val x: Int;
	
	public def this(str: String) { this.x = Symbol.tabl.findInt(str); }
	
	public def toString () { return Symbol.tabl.findString(x); }
	
	public def hashCode () { return x; }
	
	public def equals(that : Any) {
		if (that instanceof Symbol) {
			return this.x.equals((that as Symbol).x);
		} else return false;
	}
	
	static private val tabl: SymbolMap{self != null} = new SymbolMap();
	
	static private class SymbolMap {
		static type SI = x10.util.HashMap[String{self!=null},Int];
		static type IS = x10.util.ArrayList[String{self!=null}];
		static type SIRef = GlobalRef[SI /* {self!=null} -- bug XTENLANG-2320 */ ]{self.home == Place.FIRST_PLACE};
		static type ISRef = GlobalRef[IS /* {self!=null} -- bug XTENLANG-2320 */ ]{self.home == Place.FIRST_PLACE};
		
		private val str2int : SIRef;
		private val int2str : ISRef;
		
		def this() {
			if (here == Place.FIRST_PLACE) {
				this.str2int = GlobalRef(new SI() as SI) as SIRef;
				this.int2str = GlobalRef(new IS() as IS) as ISRef;
			} else {
				this.str2int = at (Place.FIRST_PLACE) Symbol.tabl.str2int;
				this.int2str = at (Place.FIRST_PLACE) Symbol.tabl.int2str;
			}
		}
		
		def findInt(str : String{self!=null}) {
			val retval = GlobalRef(new Cell[Int](-1));
			at (Place.FIRST_PLACE) {
				if(str2int().containsKey(str)) {
					val int_symbol = str2int()(str)();
					at (retval.home) retval()(int_symbol);
				} else {
					val int_symbol = int2str().size();
					str2int().put(str, int_symbol);
					int2str().add(str);
					at (retval.home) retval()(int_symbol);
				}
			}
			return retval()();
		}
		
		def findString(x: Int) {
			return at (Place.FIRST_PLACE) int2str()(x);
		}
	}
}