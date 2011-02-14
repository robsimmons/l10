package l10.term;
import l10.util.*;

public class Var extends Term {
	val name : Symbol;
	var ndx : Int;
	
	public def this(name : String) {
		this.name = Symbol(name);
		this.ndx = 0;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print("?" + this.name);
	}
}