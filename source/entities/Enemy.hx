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
	}
	
	override public function update(elapsed:Float):Void
	{
		
		super.update(elapsed);
	}	
	
}