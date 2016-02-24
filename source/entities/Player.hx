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
class Player extends FlxSprite
{
	@:isVar private var weapon(get, null):Attack;
	private var jumpTimer:Float = 0;
	
	@:isVar private var subHealth(get, null):Int = 100;
	public var pegHealth:Int = 16;
	//@:isVar private var pegHealth(get, null):Int = 16;

	public function new(X:Int, Y:Int) 
	{
		super();
		
		x = X;
		y = Y;
		
		loadGraphic("assets/images/character.png", true, 128, 128);
		
		animation.add("idle", [0], 12, false);
		animation.add("walk", [10, 11, 12, 13, 14, 15], 10, true);
		animation.add("hitFloor1", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 14, false);
		animation.add("hitFloor2", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 16, false);
		animation.add("prejump", [2,2], 30, false);
		animation.add("jumping", [2,2], 30, false);
		animation.add("landing", [0,0], 20, false);
		
		animation.play("idle");
		
		width = 24;
		height = 85;
		offset.x = 46;
		offset.y = 34;
		
		drag.x = Reg.movementSpeed * 4;
		acceleration.y = Reg.gravity;
		
		maxVelocity.set(Reg.maxPlayerVelocityX, Reg.maxPlayerVelocityY);
		
		weapon = new Attack();
	}
	
	override public function update(elapsed:Float):Void
	{
		playerInput();
		
		weapon.setPosition(x, y);	
		
		super.update(elapsed);
	}
	
	private function playerInput():Void
	{		
		acceleration.x = 0;
		
		switch(animation.name)
		{
			case "idle":
				moveLeftRight(true);
				
				if (FlxG.keys.anyJustPressed(["UP", "Z"]) && isTouching(FlxObject.DOWN))
				{
					animation.play("prejump");
					weapon.animation.play("prejump");
				}
				else if (FlxG.keys.anyJustPressed(["X"]))
				{
					animation.play("hitFloor1");
					weapon.animation.play("hitFloor1");
				}
				
			case "walk":
				moveLeftRight(true);
				
				if (FlxG.keys.anyJustPressed(["UP", "Z"]) && isTouching(FlxObject.DOWN))
				{
					animation.play("prejump");
					weapon.animation.play("prejump");
				}
				else if (FlxG.keys.anyJustPressed(["X"]))
				{
					animation.play("hitFloor1");
					weapon.animation.play("hitFloor1");
				}
				else if (acceleration.x == 0)
				{
					animation.play("idle");
					weapon.animation.play("idle");
				}
				
			case "prejump":
					velocity.y = -Reg.jumpForceSpeed;
					animation.play("jumping");
					weapon.animation.play("jumping");
					jumpTimer = 0;
				
			case "jumping":
				moveLeftRight(false);
				
				if (isTouching(FlxObject.DOWN))
					if (acceleration.x == 0)
					{
						animation.play("landing");
						weapon.animation.play("landing");
					}
					else
					{
						animation.play("walk");
						weapon.animation.play("walk");
						}
				else
				{
					if (jumpTimer < Reg.maxJumpTime)
					{
						jumpTimer += FlxG.elapsed;
						
						if (FlxG.keys.anyPressed(["UP", "Z"]))
							{velocity.y -= 18; acceleration.y = Reg.gravity / 2;}
						else
						{
							jumpTimer = Reg.maxJumpTime;
							acceleration.y = Reg.gravity;
						}
					}
					else
					{
						jumpTimer = Reg.maxJumpTime;
						acceleration.y = Reg.gravity;
					}
				}
				
				trace(acceleration.y);
				
			case "landing":
				
				if (animation.finished)
				{
					animation.play("idle");					
					weapon.animation.play("idle");
				}
				else if (FlxG.keys.anyJustPressed(["UP", "Z"]) && isTouching(FlxObject.DOWN))
				{
					animation.play("prejump");
					weapon.animation.play("prejump");
				}
				else
					moveLeftRight(true);
					
			case "hitFloor1":
				if (animation.finished)
				{
					animation.play("idle");
					weapon.animation.play("idle");
				}
				else if (FlxG.keys.anyJustPressed(["X"]))
				{
					animation.play("hitFloor2");					
					weapon.animation.play("hitFloor2");
				}
					
			case "hitFloor2":
				if (animation.finished)
				{
					animation.play("idle");
					weapon.animation.play("idle");
				}
		}
	}
	
	private function moveLeftRight(changeAnim:Bool = false):Void
	{
		if (!(FlxG.keys.anyPressed(["LEFT"]) && FlxG.keys.anyPressed(["RIGHT"])))
		{					
			if (FlxG.keys.anyPressed(["LEFT"]))
			{
				flipX = true;
				weapon.flipX = true;
				acceleration.x -= drag.x;
				if (changeAnim)
				{
					animation.play("walk");					
					weapon.animation.play("walk");					
				}
			}
			
			if (FlxG.keys.anyPressed(["RIGHT"]))
			{
				flipX = false;
				weapon.flipX = false;
				acceleration.x += drag.x;
				if (changeAnim)
				{
					animation.play("walk");
					weapon.animation.play("walk");
				}
			}
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