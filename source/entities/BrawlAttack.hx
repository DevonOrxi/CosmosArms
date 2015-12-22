package entities;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

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
		
		loadGraphic("assets/images/weaponTest.png", true, 128, 128);
		
		animation.add("idle", [0], 12, false);
		animation.add("walk", [7, 8, 9], 8, true);
		animation.add("hitFloor1", [12, 13, 14, 15, 16,17], 1, false);
		animation.add("hitFloor2", [18, 19, 20, 21, 22, 23], 1, false);
		animation.add("prejump", [0,0], 30, false);
		animation.add("jumping", [1,1], 30, false);
		animation.add("landing", [0,0], 20, false);	
		
		width = 24;
		height = 85;
		offset.x = 46;
		offset.y = 34;
		
		prevAnim = "idle";
		
		enemyHitList = new FlxTypedGroup<Enemy>();
	}
	
	override public function update():Void
	{
		if (animation.name != prevAnim)
		{
			enemyHitList.clear();
			prevAnim = animation.name;
		}
			
		super.update();
	}
	
	public function get_enemyHitList():FlxTypedGroup<Enemy>
	{
		return enemyHitList;
	}
	
}