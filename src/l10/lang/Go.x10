package l10.lang;

public class Go {
	public static def a_random_tm() = { 
        var x : BasicTerm = null;
        x = new StringTerm("test string");
        return x;
    }
	
	public static def main(Array[String]) {
		val tmhome : GlobalRef[BasicTerm] = 
			GlobalRef(new StringTerm("test string") as BasicTerm);
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
			Console.OUT.print("Object created at place " + w + ": ");
			tmhere.print(true);
			Console.OUT.println();
 
			tmhere = new StructuredTerm("s", new List(new ConstantTerm("z") as BasicTerm, null));
			Console.OUT.print("Object created at place " + w + ": ");
			tmhere.print(true); 
			Console.OUT.println();
			
			tmhere = at (tmhome.home) tmhome.apply();
			Console.OUT.print("Object dragged to place " + w + ": ");
			tmhere.print(true);
			Console.OUT.println();
			
			// Bring terms across worlds
		    //tmhere = tm;
		}
	}

private def GlobalRef(
  ):
  void {
    
}
}