package l10.term;
import l10.util.*;

public class Var extends Term {
	val name : Symbol;
	var ndx : Int;
	
	public def this(name : String) {
		super(false);
		this.name = Symbol(name);
		this.ndx = 0;
	}
	
	public def print(parens : Boolean) {
		Console.OUT.print("?" + this.name);
	}
	
	public def equals(that : Any) {
		return false;
	}
	
	def match(t: Ground, s: Subst): Boolean {
		val t2: Term = s.get(name);
		if (t2 == null) {
			s.put(name, t);
			return true;
		} else {
			return t2.match(t, s);
		}
	}

}