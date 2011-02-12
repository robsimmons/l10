package l10.lang;

public class StringTerm extends BasicTerm {
	val s : String;
	
	public def this(s : String) { 
		this.s = s;
	}
	
	public def this(f : StringTerm) {
		this.s = f.s;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print("\"" + this.s + "\"");
	}

	public def hashCode() { return this.s.hashCode(); }
}
