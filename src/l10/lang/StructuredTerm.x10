package l10.lang;

public class StructuredTerm extends BasicTerm {
	val f : Symbol;
	val ts : List[BasicTerm];
	
	public def this(f : String, ts : List[BasicTerm]{self!=null}) {
		this.f = Symbol(f);
		this.ts = ts;
	}
	
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
		
	private static final def printOne(x : BasicTerm{self != null}) {
		Console.OUT.print(" ");
		x.print(true);
	}
	
	public def print(parens : Boolean) {
		if (ts == null)
			Console.OUT.print(f.toString());
		else {
			if(parens) Console.OUT.print("(");
			Console.OUT.print(f.toString());
			ts.app((x : BasicTerm{self != null}) => { 
				Console.OUT.print(" "); 
				x.print(true); 
			});
		  	if(parens) Console.OUT.print(")");
		}
	}
}

