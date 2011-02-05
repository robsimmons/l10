package l10.lang;

public class Go {
	public static def main(Array[String]) {
		var x : List[Int] = null;
		var tm : BasicTerm = null;
		tm = new StringTerm("Hello There");
		ateach (p in Dist.makeUnique()) {
			val w = here.id;
			val sym1 = Symbol("x");
			val sym2 = Symbol("x" + w);
			Console.OUT.println("Hash for 'x' at " + w + " : " + sym1.x);		
			Console.OUT.println("Hash for 'x" + w + "' at " + w + " : " + sym2.x);		
			var x : int = 0;
			var i : int = 0;
			Console.OUT.println("Hello 1 from place " + w);
			for(i = 0; i < 1000000; i++) { x += 1; }
			Console.OUT.println("Hello 2 from place " + w);
			for(i = 0; i < 10000000; i++) { x += 1; }
			Console.OUT.println("Hello 3 from place " + w);
			
			// Test term printing
			var tmhere : BasicTerm = null;
			
			tmhere = new StringTerm("Hello World");
			Console.OUT.print("Here's one object at place " + w + ": ");
			tmhere.print(true);
			Console.OUT.println();
 
			var list : List[BasicTerm] = null;
			list = null;
			list = new List(tmhere, list);
			
			/* tmhere  = new StructuredTerm(sym1, null);
			Console.OUT.print("Here's another at place " + w + ": ");
			tmhere.print(true); */
			
			// Bring terms across worlds
		    //tmhere = tm;
		}
	}
}