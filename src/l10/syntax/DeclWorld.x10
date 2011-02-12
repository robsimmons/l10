package l10.lang;

public class DeclWorld extends Decl {
	val args: List[Arg];
	
	public def this(args: List[Arg]) {
		this.args = args;
	}
}