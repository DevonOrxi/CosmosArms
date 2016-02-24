package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Acid
 */
class Boss extends Enemy
{
	
	@:isVar private var weapon(get, null):Attack;
	private var waitTimer:Float = 0;
	
	@:isVar private var subHealth(get, null):Int = 100;
	public var pegHealth:Int = 16;

	public function new(X:Int, Y:Int) 
	{
		super();
		
		x = X;
		y = Y;
		
		loadGraphic("assets/images/boss.png", true, 256, 256);
		
		animation.add("idle", [0], 16, false);
		animation.add("charge", [10, 11, 12, 13], 16, false);
		animation.add("dash1", [14, 15, 16, 17, 18, 19, 20], 16, false);
		animation.add("dash2", [21, 22, 23, 24, 25, 26, 27, 28, 29], 16, false);
		animation.add("jumping", [40, 41], 14, false);
		animation.add("landing", [42], 30, false);
		
		animation.play("idle");
		
		width = 34;
		height = 93;
		offset.x = 112;
		offset.y = 83;
		flipX = true;
		
		drag.x = Reg.movementSpeed * 4;
		acceleration.y = Reg.gravity;
		
		maxVelocity.set(Reg.maxPlayerVelocityX, Reg.maxPlayerVelocityY);
		
		weapon = new Attack();
	}
	
	override public function update(elapsed:Float):Void
	{
		bossPattern();
		
		weapon.setPosition(x, y);
		
		super.update(elapsed);
	}
	
	private function bossPattern():Void
	{		
		acceleration.x = 0;
		waitTimer += FlxG.elapsed;
		
		switch(animation.name)
		{
			case "idle":
				
				if (waitTimer >= Reg.bossIdleTime)
				{
					waitTimer = 0;
					animation.play("charge");
					FlxG.sound.play("assets/sounds/charge.wav");
				}
				
			case "charge":				
				if (waitTimer >= Reg.bossChargeTime)
				{
					waitTimer = 0;
					animation.play("dash1");
					FlxG.sound.play("assets/sounds/sword.wav");
				}
				
			case "dash1":
				if (waitTimer >= Reg.bossSlashTime)
				{
					waitTimer = 0;
					animation.play("dash2");
					FlxG.sound.play("assets/sounds/sword.wav");
				}
				
			case "dash2":
				if (animation.finished)
				{
					waitTimer = 0;
					animation.play("idle");
				}
				
			case "jumping":
				
				
			case "landing":
				
				
		}
	}
	
	public function get_weapon():Attack
	{
		return weapon;
	}
	public function get_subHealth():Int
	{
		return subHealth;
	}
	public function get_pegHealth():Int
	{
		return pegHealth;
	}
}