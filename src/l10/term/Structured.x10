package l10.term;
import l10.util.Symbol;
import l10.util.List;

public class Structured extends Term {
	val f : Symbol;
	val ts : List[Term];
	
	public def this(f : String, ts : List[Term]{self!=null}) {
		this.f = Symbol(f);
		this.ts = ts;
	}
	
	public def this(f : Symbol, ts : List[Term]{self!=null}) {
		this.f = f; 
		this.ts = ts;
	}
	
	public def hashCode() {
		return super.hashCode();
	}	
			
	private static final def printOne(x : Term{self != null}) {
		Console.OUT.print(" ");
		x.print(true);
	}
	
	public def print(parens : Boolean) {
		if (ts == null)
			Console.OUT.print(f.toString());
		else {
			if(parens) Console.OUT.print("(");
			Console.OUT.print(f.toString());
			ts.app((x : Term{self != null}) => { 
				Console.OUT.print(" "); 
				x.print(true); 
			});
		  	if(parens) Console.OUT.print(")");
		}
	}
}

