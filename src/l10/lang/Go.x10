package l10.lang;

public class Go {
	public static def a_random_tm() = { 
        var x : BasicTerm = null;
        x = new StringTerm("test string");
        return x;
    }
	
	static val cell : Cell[Int] = new Cell[Int](5 as Int);
	
	public static def main(Array[String]) {
		val tmhome : GlobalRef[BasicTerm] = 
			GlobalRef(new StringTerm("test string") as BasicTerm);
		
		ateach (p in Dist.makeUnique()) {
			var i : Int = 0;
			var x : Int = 0;
			var w : Int = here.id;
			Go.cell.set(here.id); // Creating what may be a race condition on purpose

			// Indicate startup
			Console.OUT.println("Hello from place " + w);
			
			// Brief pause, then tests
			for(i = 0; i < 1000000; i++) { x += 1; }
			Console.OUT.println("Beginning tests at place " + w);

			// Test term creation, output, and relocation
			var tmhere : BasicTerm = null;
			
			tmhere = new StringTerm("Hello World");
			Console.OUT.print("Object created at place " + w + ": ");
			tmhere.print(true);
			Console.OUT.println();
 
			tmhere = new StructuredTerm("s", new List(new ConstantTerm("z") as BasicTerm, null));
			Console.OUT.print("Object created at place " + w + ": ");
			tmhere.print(true); 
			Console.OUT.println();
			
			tmhere = at (tmhome.home) tmhome();
			Console.OUT.print("Object dragged to place " + w + ": ");
			tmhere.print(true);
			Console.OUT.println();
			
			// Exit after a longer pause
			for(i = 0; i < 1000000000; i++) { x += 1; }
			Console.OUT.println("Goodbye from place " + w + " (" + i + " iterations)");
			Console.OUT.println("Static field was set to " + Go.cell());
		}
	}
}