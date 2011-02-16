package l10.term;
import l10.util.*;

public class Const extends Term {
	public val c: Symbol;
	
	public def this(c: Symbol) {
		super(true);
		this.c = c;
	}
	
	public def this(c : String) {
		this(Symbol(c));
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print(c.toString());
	}
	
	public def hashCode() { return this.c.x; }
	
	public def equals(that: Any) {
		if (that != null && that instanceof StrConst) {
			return this.c.equals((that as Const).c);
		} else return false;
	}

	public def match(t: Ground, s: Subst): Boolean {
		return t instanceof Const && c.equals((t as Const).c);
	}
}