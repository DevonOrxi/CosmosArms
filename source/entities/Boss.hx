package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Acid
 */
class Boss extends Enemy
{
	
	@:isVar private var weapon(get, null):Attack;
	
	private var waitTimer:Float = 0;
	private var warning:Bool = false;
	private var state:String = "idle";
	
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
		
		acceleration.y = Reg.gravity;
		
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
		
		switch(state)
		{
			case "idle":
				
				if (waitTimer >= Reg.bossIdleTime)
				{
					waitTimer = 0;
					animation.play("charge");
					state = "charge";
					FlxG.sound.play("assets/sounds/charge.wav");
					FlxTween.color(this, Reg.bossChargeTime, 0xFFFFFFFF, 0xFF0000FF);						
					checkPlayerPos();
				}
				
			case "charge":
				if (waitTimer >= Reg.bossChargeWarning && !warning)
				{
					FlxG.sound.play("assets/sounds/warning.wav");
					warning = true;
				}
				
				if (waitTimer >= Reg.bossChargeTime)
				{
					color = 0xFFFFFFFF;
					waitTimer = 0;
					warning = false;
					animation.play("dash1");
					state = "dash1";
					FlxG.sound.play("assets/sounds/sword.wav");
					
					if (Reg.playerRef.getMidpoint().x <= getMidpoint().x)
						velocity.x = -3000;
					else
						velocity.x = 3000;
					
					checkPlayerPos();
				}
				
			case "dash1":
				if (waitTimer >= Reg.bossDashTime)
					velocity.x = 0;
					
				if (waitTimer >= Reg.bossSlashTime)
				{
					color = 0xFFFFFFFF;
					waitTimer = 0;
					animation.play("dash2");
					state = "dash2";
					FlxG.sound.play("assets/sounds/sword.wav");
					
					if (Reg.playerRef.getMidpoint().x <= getMidpoint().x)
						velocity.x = -3000;
					else
						velocity.x = 3000;
					
					checkPlayerPos();
				}
				
			case "dash2":
				if (waitTimer >= Reg.bossDashTime)
					velocity.x = 0;
					
				if (waitTimer >= Reg.bossSlashTime)
				{
					waitTimer = 0;
					animation.play("idle");
					state = "idle";
					
					checkPlayerPos();
				}
				
			case "jumping":
				
				
			case "landing":
				
		}
	}
	
	private function checkPlayerPos():Void
	{
		if (velocity.x > 0)
			flipX = false;
		else if (velocity.x < 0)
			flipX = true;
		else if (Reg.playerRef.getMidpoint().x <= getMidpoint().x)
			flipX = true;
		else
			flipX = false;
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