package l10.lang;

public class World {
	val name: Symbol;
	val kind: Kind;
	val term: BasicTerm;
	
	public def hashCode () { return name.hashCode(); }
	
	public def this(name: Symbol) {
		this.name = name;
		this.kind = CONSTANT_WORLD;
		this.term = null;
	}
	
	public def this(name: Symbol, kind: ComplexKind, term: BasicTerm{self != null}) {
		this.name = name;
		this.kind = kind;
		this.term = term;
	}

	static type Kind = Int{self >= 0 && self < 3};
	static type ComplexKind = Int{self >= 1 && self < 3};
	static val CONSTANT_WORLD = 0;
	static val HASHED_WORLD = 1;
	static val STRUCTURED_TERM_WORLD = 2;
}