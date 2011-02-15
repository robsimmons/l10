package l10.term;
import l10.util.*;

public class Const extends Term {
	public val c : Symbol;
	
	public def this(c : Symbol) {
		this.c = c;
	}
	
	public def this(c : String) {
		this.c = Symbol(c);
		Console.OUT.print("" + this.c.x);
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
}