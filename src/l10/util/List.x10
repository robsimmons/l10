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
	public static def app[T](l: List[T], f: (x: T{self != null}) => void) {
		var list: List[T] = l;
		while (list != null) {
			f(list.head);
			list = list.tail;
		}
	}
	
	public static def map[T,S](l: List[T], f: (x: T{self != null}) => S{self != null}): List[S] {
		if (l == null) return null;
		val newlist_front: List[S] = new List[S](f(l.head), null);
		var newlist_back: List[S] = newlist_front;
		var oldlist_back: List[T] = l.tail;
		while(oldlist_back != null) {
			newlist_back.tail = new List[S](f(oldlist_back.head), null);
			newlist_back = newlist_back.tail;
			oldlist_back = oldlist_back.tail;
		}
		return newlist_front;
	}
	
	public static def zipWith[T,S,R](l1: List[T], l2: List[S], f: (x: T{self!=null}, y: S{self!=null}) => R{self!=null}): List[R] {
		if (l1 == null || l2 == null) return null;
		val newlist_front: List[R] = new List[R](f(l1.head, l2.head), null);
		var newlist_back: List[R] = newlist_front; 
		var list1: List[T] = l1.tail;
		var list2: List[S] = l2.tail;
		while(list1 != null && list2 != null) {
			newlist_back.tail = new List[R](f(list1.head, list2.head), null);
			newlist_back = newlist_back.tail;
			list1 = list1.tail;
			list2 = list2.tail;
		}
		return newlist_front;
	}
	
	public static def all[T](l: List[T], f: (x: T{self != null}) => Boolean): Boolean {
		var list: List[T] = l;
		while (list == null) {
			if (!f(list.head)) return false;
			list = list.tail;
		}
		return true;
	}
}
