package entities;

import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Acid
 */
class Enemy extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y, SimpleGraphic);
		
		makeGraphic(50, 50, 0xFFFF0000);
		
		velocity.x = -200;
	}
	
	override public function update(elapsed:Float):Void
	{
		if (x < 0 || x > FlxG.width - width)
			velocity.x *= -1;
		
		super.update(elapsed);
	}	
	
}