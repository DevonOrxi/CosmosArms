package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Acid
 */
class Attack extends FlxSprite
{
	@:isVar private var enemyHitList(get, null):FlxTypedGroup<Enemy>;
	private var prevAnim:String;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic("assets/images/sword.png", true, 90, 46);
		animation.add("hitFloor1", [16, 15, 14, 13, 12, 11, 10], 15, false);
		animation.add("hitFloor2", [9, 8, 7, 6, 5, 4, 3], 15, false);
		animation.add("idle", [0], 20, false);
		animation.play("idle");
		
		prevAnim = "idle";
		
		enemyHitList = new FlxTypedGroup<Enemy>();
	}
	
	override public function update(elapsed:Float):Void
	{
		if (animation.name != prevAnim)
		{
			enemyHitList.clear();
			prevAnim = animation.name;
		}
			
		super.update(elapsed);
	}
	
	public function get_enemyHitList():FlxTypedGroup<Enemy>
	{
		return enemyHitList;
	}
	
}