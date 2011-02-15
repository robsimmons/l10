package l10.syntax;
import l10.util.*;
import l10.term.Term;

public class World {
	val name: Symbol;
	val kind: Kind;
	val term: Term;
	
	public def hashCode () { return name.hashCode(); }
	
	public def this(name: Symbol) {
		this.name = name;
		this.kind = CONSTANT_WORLD;
		this.term = null;
	}
	
	public def this(name: Symbol, kind: ComplexKind, term: Term{self != null}) {
		this.name = name;
		this.kind = kind;
		this.term = term;
	}

	static type Kind = Int{self >= 0 && self < 4};
	static type ComplexKind = Int{self >= 1 && self < 4};
	public static val CONSTANT_WORLD = 0;
	public static val HASHED_STRING_WORLD = 1;
	public static val HASHED_INT_WORLD = 2;
	public static val STRUCTURED_TERM_WORLD = 3;
}