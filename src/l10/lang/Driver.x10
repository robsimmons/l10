package l10.lang;
import l10.util.*;
import l10.term.*;
import l10.syntax.World;

public class Driver {
	static type WL = List[World];
			
	public static def main(Array[String]) {
		var accessible : WL;
		
		accessible = null;
		val a1 : World = new World(Symbol("wA1"), World.HASHED_STRING_WORLD, new Var("X"));

		accessible = new WL(a1, null);
		val a2 = new World(Symbol("wA2"), World.HASHED_STRING_WORLD, new Var("X"));

		accessible = new WL(a2, null);
		val b1 = new World(Symbol("wB1"));
		val b2 = new World(Symbol("wB2"));
		val b3 = new World(Symbol("wB3"));
		val b4 = new World(Symbol("wB4"));
		val b5 = new World(Symbol("wB5"));
		
		accessible = new WL(b1, new WL(b2, new WL(b3, new WL(b4, new WL(b5, null)))));
		val c1 = new World(Symbol("wC")); 
	}
}