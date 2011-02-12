package l10.syntax;

public class DeclDepends extends Decl {
	val world: World{self != null};
	val dependsOn: World{self != null};
	
	public def this(world: World{self != null}, dependsOn: World{self != null}) {
		this.world = world;
		this.dependsOn = dependsOn;
	}
}