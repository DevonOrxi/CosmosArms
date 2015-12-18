package entities;

import flixel.FlxSprite;
import flixel.util.loaders.TexturePackerData;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Acid
 */
class Player extends FlxSprite
{
	private var canJump:Bool = false;
	@:isVar private var weapon(get, null):Attack;

	public function new(X:Int, Y:Int) 
	{
		super();
		
		x = X;
		y = Y;
		
		loadGraphic("assets/images/galford.png", true, 90, 46);
		
		animation.add("idle", [24, 23, 22, 21, 20, 19, 18, 17], 12, true);
		//animation.add("walk", [28,27,26,25], 10, true);
		animation.add("walk", [32, 31, 30, 29], 12, true);
		animation.add("hitFloor1", [16, 15, 14, 13, 12, 11, 10], 15, false);
		animation.add("hitFloor2", [9, 8, 7, 6, 5, 4, 3], 15, false);
		animation.add("prejump", [2,2], 30, false);
		animation.add("jumping", [1,1], 30, false);
		animation.add("landing", [0,0], 20, false);		
		
		animation.play("idle");
		
		drag.x = Reg.movementSpeed*4;
		acceleration.y = Reg.jumpForce*2.5;
		maxVelocity = FlxPoint.weak(Reg.maxPlayerVelocityX, Reg.maxPlayerVelocityY);
		
		weapon = new Attack();
	}
	
	override public function update()
	{
		playerInput();
		
		super.update();
		
		weapon.setPosition(x, y);
	}
	
	private function playerInput()
	{		
		acceleration.x = 0;
		
		switch(animation.name)
		{
			case "idle":
				moveLeftRight(true);			
				
				if (FlxG.keys.anyJustPressed(["UP", "Z"]) && velocity.y == 0)
					animation.play("prejump");
				else if (FlxG.keys.anyJustPressed(["X"]))
				{
					animation.play("hitFloor1");
					weapon.animation.play("hitFloor1");
				}
				
			case "walk":
				moveLeftRight(true);
				
				if (FlxG.keys.anyJustPressed(["UP", "Z"]) && velocity.y == 0)
					animation.play("prejump");
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
					velocity.y = -Reg.jumpForce * 1.2;
					acceleration.y = Reg.jumpForce * 3;
					animation.play("jumping");
				
			case "jumping":
				moveLeftRight(false);			
				
				if (velocity.y == 0)
					if(acceleration.x == 0)
						animation.play("landing");
					else
						animation.play("walk");
					
			case "landing":
				
				if (animation.finished)
				{
					animation.play("idle");					
					weapon.animation.play("idle");
				}
				else 
					moveLeftRight(true);
					
			case "hitFloor1":
				if (animation.finished)
					animation.play("idle");
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
	
	private function moveLeftRight(changeAnim:Bool = false)
	{
		if (!(FlxG.keys.anyPressed(["LEFT"]) && FlxG.keys.anyPressed(["RIGHT"])))
		{					
			if (FlxG.keys.anyPressed(["LEFT"]))
			{
				flipX = true;
				weapon.flipX = true;
				acceleration.x -= drag.x;
				if (changeAnim) animation.play("walk");
			}
			
			if (FlxG.keys.anyPressed(["RIGHT"]))
			{
				flipX = false;
				weapon.flipX = false;
				acceleration.x += drag.x;
				if (changeAnim) animation.play("walk");
			}
		}
	}
	
	public function get_weapon():Attack
	{
		return weapon;
	}
}