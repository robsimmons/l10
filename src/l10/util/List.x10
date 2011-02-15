package l10.util;

public class List[T] {
	public val head: T{self != null};
	public var tail: List[T];
	public def this(h: T{self != null}, t: List[T]) { head = h; tail = t; }
	public final def append(x: List[T]) {
		if (this.tail == null)
			this.tail = x;
		else
			this.tail.append(x);
	}
	
	public final def app(f : (x : T{self != null}) => void) {
		f(head);
		if (tail != null) 
			tail.app(f);
	}
	
	public final def map[S](f : (x : T{self != null}) => S{self != null}) : List[S] {
		return tail == null 
			? new List[S](f(head), null) 
			: new List[S](f(head), tail.map[S](f));
	}
	
}
