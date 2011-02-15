package l10.term;

public class StrConst extends Term {
	val s : String;
	
	public def this(s : String) { 
		this.s = s;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print("\"" + this.s + "\"");
	}

	public def hashCode() { return this.s.hashCode(); }
	
	public def equals(that : Any) {
		if (that != null && that instanceof StrConst) {
			return this.s.equals((that as StrConst).s);
		} else return false;
	}
}
