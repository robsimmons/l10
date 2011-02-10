package l10.lang;

public class VarTerm extends BasicTerm {
	val name : String;
	var ndx : Int;
	
	public def this(name : String) {
		this.name = name;
		this.ndx = 0;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print("?" + this.name);
	}
}