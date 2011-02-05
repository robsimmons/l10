package l10.lang;

public struct Symbol {
	val x : Int;
	public def this(str: String) {
		this.x = str.hashCode(); // Please replace me with an actual symtab
	}
}