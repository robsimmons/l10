package l10.term;

public class IntConst extends Term {
	public val i : Int;
	
	public def this(i : Int) { 
		this.i = i;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print(this.i);
	}

	public def hashCode() { return this.i; }
}
