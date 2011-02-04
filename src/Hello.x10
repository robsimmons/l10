/**
 * The canonical "Hello, World" demo class expressed in X10
 */
public class Hello {

    /**
     * The main method for the Hello class
     */
    public static def main(Array[String]) {
    	ateach (p in Dist.makeUnique()) {
    		var x : int = 0;
    		var i : int = 0;
    		Console.OUT.println("Hello 1 from place "+here.id);
    		for(i = 0; i < 1000000; i++) { x += 1; }
    		Console.OUT.println("Hello 2 from place "+here.id);
    		for(i = 0; i < 1000000000; i++) { x += 1; }
    		Console.OUT.println("Hello 3 from place "+here.id);
    		Console.OUT.print("Symbol corresponding to world: ");
    		Console.OUT.println();
    	}
    }

}