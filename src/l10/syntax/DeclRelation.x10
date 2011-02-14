package l10.syntax;
import l10.util.*;
import l10.term.Term;

class NamedArg extends Arg {
	val name: Symbol;
	public def this(name: Symbol, ty: Symbol) {
		super(ty);
		this.name = name;
	}
}

public class DeclRelation extends Decl {
	static type Args = List[Arg]{self != null};
	val	name: Symbol;
	val args: Args;
	val world: World{self != null};
	val wsym: Symbol;
	
	public def this(name: Symbol, args: Args, world: World, wsym: Symbol) {
		this.name = name;
		this.args = args;
		this.world = world;
		this.wsym = wsym;
	}
}