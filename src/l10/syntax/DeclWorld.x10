package l10.syntax;
import l10.util.*;

public class DeclWorld extends Decl {
	val args: List[Arg];
	
	public def this(args: List[Arg]) {
		this.args = args;
	}
}