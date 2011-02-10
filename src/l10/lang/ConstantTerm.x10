package l10.lang;

public class ConstantTerm extends BasicTerm {
	var c : Symbol;
	
	public def this(c : Symbol) {
		this.c = c;
	}
	
	public def this(c : String) {
		this.c = Symbol(c);
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print(c.toString());
	}
	
	public def hashCode() { return this.c.x; }
}