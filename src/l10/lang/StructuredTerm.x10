package l10.lang;

public class StructuredTerm implements BasicTerm {
	val f : Symbol;
	val ts : List[Term];
	
	public def this(f : Symbol, ts : List[Term]) {
		this.f = f; 
		this.ts = ts;
	}
	
	public def hashCode() {
		return super.hashCode();
	}	
	
	public def this(f : StructuredTerm) {
		this.f = Symbol("Copied");
		this.ts = null;
	}
	
	public def print(parens : Boolean) {
		if (ts == null)
			Console.OUT.print("<term>");
		else {
			if(parens) Console.OUT.print("(");
			Console.OUT.print("<term with args>");
		  	if(parens) Console.OUT.print(")");
		}
	}
}

