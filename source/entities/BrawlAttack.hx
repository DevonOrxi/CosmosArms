package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Acid
 */
class BrawlAttack extends FlxSprite
{
	@:isVar private var enemyHitList(get, null):FlxTypedGroup<Enemy>;
	private var prevAnim:String;

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		loadGraphic("assets/images/characterWeapon.png", true, 128, 128);
		
		animation.add("idle", [0], 12, false);
		animation.add("walk", [10, 11, 12, 13, 14, 15], 10, true);
		animation.add("hitFloor1", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 14, false);
		animation.add("hitFloor2", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 16, false);
		animation.add("prejump", [2,2], 30, false);
		animation.add("jumping", [2,2], 30, false);
		animation.add("landing", [0,0], 20, false);
		
		width = 24;
		height = 85;
		offset.x = 46;
		offset.y = 34;
		
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