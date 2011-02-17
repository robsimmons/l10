package l10.syntax;
import x10.util.Pair;
import x10.util.HashMap;
import x10.util.Box;
import l10.util.*;
import l10.term.*;

public class PredicateSet {
	
	public static type Return = List[Cell[Subst]];
	static type Payload = List[Term.Ground];
	static type TermMap = HashMap[Symbol, List[Payload]];
	val set: TermMap;
	
	public def this() {
		this.set = new TermMap();
	}
	
	public def match(p: Predicate, s: Subst): Return {
		val matchBox: Box[List[Payload]] = set.get(p.a);
		val ts = p.ts;
				
		// No matches
		if (matchBox == null)
			return null;

		// 
		return List.mapPartial(matchBox.value,
			(tsG : Payload{self!=null}): Cell[Subst] => {
				var s2 : Subst = Subst.copy(s);
				return null;
			});
	}
	
}