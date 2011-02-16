package l10.term;
import l10.util.Symbol;
import l10.util.List;

public class Structured extends Term {
	val f : Symbol;
	val ts : List[Term];
	
	public def this(f : Symbol, ts : List[Term]{self!=null}) {
		super(List.all(ts, (x: Term{self != null}) => x.ground));
		this.f = f; 
		this.ts = ts;
	}
				
	public def this(f : String, ts : List[Term]{self!=null}) {
		this(Symbol(f), ts);
	}

	private static final def printOne(x : Term{self != null}) {
		Console.OUT.print(" ");
		x.print(true);
	}
	
	public def print(parens: Boolean) {
		if (ts == null)
			Console.OUT.print(f.toString());
		else {
			if (parens) Console.OUT.print("(");
			Console.OUT.print(f.toString());
			List.app(ts, (x : Term{self != null}) => { 
				Console.OUT.print(" "); 
				x.print(true); 
			});
		  	if(parens) Console.OUT.print(")");
		}
	}
	
	public def hashCode () {
		return super.hashCode ();
	}	

	public def equals (x: Any): Boolean {
		if (x != null && x instanceof StrConst) {
			val that = x as Structured{self!=null};
			if (f.x.equals(that.f.x)) 
				return List.all 
					(List.zipWith[Term, Term, Cell[Boolean]](this.ts, that.ts, 
						(x: Term{self!=null}, y: Term{self!=null}) =>
							new Cell(x.equals(y))), 
					(x: Cell[Boolean]) => x.value);
		} 
		return false;
	}
	
	public def match(t: Ground, s: Subst): Boolean {
		if (t instanceof Structured && f.x.equals((t as Structured).f.x)) {
			return List.all
				(List.zipWith[Term, Term, Cell[Boolean]](ts, (t as Structured).ts,
					(x: Term{self!=null}, y: Term{self!=null}) => 
						new Cell(x.match(y as Ground,s))),
				(x: Cell[Boolean]) => x.value);
		} else {
			return false;
		}
	}
}

