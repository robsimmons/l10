package l10.lang;


public class Driver {
	static type WL = List[World];
			
	public static def main(Array[String]) {
		var accessible : WL;
		
		accessible = null;
		val a1 : World = new World(Symbol("wA1"), accessible, World.HASHED_STRING_WORLD);

		accessible = new WL(a1, null);
		val a2 = new World(Symbol("wA2"), accessible, World.HASHED_STRING_WORLD);

		accessible = new WL(a2, null);
		val b1 = new World(Symbol("wB1"), accessible, World.CONSTANT_WORLD);
		val b2 = new World(Symbol("wB2"), accessible, World.CONSTANT_WORLD);
		val b3 = new World(Symbol("wB3"), accessible, World.CONSTANT_WORLD);
		val b4 = new World(Symbol("wB4"), accessible, World.CONSTANT_WORLD);
		val b5 = new World(Symbol("wB5"), accessible, World.CONSTANT_WORLD);
		
		accessible = new WL(b1, new WL(b2, new WL(b3, new WL(b4, new WL(b5, null)))));
		val c1 = new World(Symbol("wC"), accessible, World.CONSTANT_WORLD); 
	}
}