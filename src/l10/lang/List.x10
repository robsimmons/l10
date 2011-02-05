package l10.lang;

public class List[T] {
	val head: T{self != null};
	var tail: List[T];
	public def this(h: T{self != null}, t: List[T]) { head = h; tail = t; }
	def append(x: List[T]) {
		if (this.tail == null)
			this.tail = x;
		else
			this.tail.append(x);
	}
}
