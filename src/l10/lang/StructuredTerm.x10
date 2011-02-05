package l10.lang;

public class StructuredTerm implements BasicTerm {
	val f : Symbol;
	val ts : List[BasicTerm];
	
	public def this(f : Symbol, ts : List[BasicTerm]{self!=null}) {
		this.f = f; 
		this.ts = ts;
	}
	
	public def hashCode() {
		return super.hashCode();
	}	
	
	public def this(f : StructuredTerm) {
		this.f = Symbol("Copied");
		var t : BasicTerm = new StringTerm("Term");
		var ts : List[BasicTerm] = new List(t, null);
		//x = new StringTerm("There");
        //z = new List(new StringTerm("Term"), null);
        // local final z: l10.lang.List[l10.lang.BasicTerm{self==x, x!=null}]{self!=null}
        // local final y: l10.lang.List[l10.lang.BasicTerm{self!=null}]
		//val y : List[BasicTerm] = z;
		this.ts = ts;
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

