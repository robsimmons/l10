package l10.term;
import x10.util.*;
import l10.util.*;

public struct Subst {
	private static type HashTerm = HashMap[Symbol,Term.Ground];
	private val map : HashTerm;
	
	public def this() {
		this.map = new HashTerm();
	}
	
	public def get(x: Symbol): Term {
		val t = map.get(x);
		if (t == null) return null;
		else return t.value;
	}
	
	public def put(x: Symbol, t: Term.Ground): void {
		map.put(x,t);
	}
	
	public static def copy(oldsubst: Subst): Subst {
		val newsubst = Subst();
		val vars = oldsubst.map.keySet().iterator();
		while (vars.hasNext()) {
			val nextvar = vars.next();
			newsubst.put(nextvar, oldsubst.get(nextvar));
		}
		return newsubst;
	}
}