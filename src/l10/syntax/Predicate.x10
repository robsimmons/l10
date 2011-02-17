package l10.syntax;
import l10.util.*;
import l10.term.*;

public struct Predicate(ground: Boolean) {
	val a: Symbol;
	val ts: List[Term];
	val world: World;
	
	public def this(a: Symbol, ts: List[Term], world: World) {
		property(List.all(ts, (x: Term{self != null}) => x.ground));
		this.a = a;
		this.ts = ts;
		this.world = world;
	}
	
	public static type Ground = Predicate{self.ground};
}