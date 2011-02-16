package l10.term;

public abstract class Term(ground: Boolean) {

	public static type Ground = Term{self!=null, self.ground};
	
	def this(ground: Boolean) { property(ground); }
	
	abstract def print(parens : Boolean): void;

	abstract public def match(t: Ground, s: Subst): Boolean;

}