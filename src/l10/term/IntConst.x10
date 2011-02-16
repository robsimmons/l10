package l10.term;

public class IntConst extends Term {
	public val i : Int;
	
	public def this(i : Int) { 
		super(true);
		this.i = i;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print(this.i);
	}

	public def hashCode() { return this.i; }
	
	public def equals(that: Any) {
		if (that != null && that instanceof IntConst) {
			return this.i.equals((that as IntConst).i);
		} else return false;
	}
	
	public def match(t: Ground, s: Subst): Boolean {
		return t instanceof IntConst && i.equals((t as IntConst).i);
	}
}
