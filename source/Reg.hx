package;
import entities.Boss;
import entities.Player;


class Reg
{
	public inline static var movementSpeed:Int = 1400;
	public inline static var jumpForceSpeed:Int = 350;
	public inline static var gravity:Int = 1700;
	public inline static var maxPlayerVelocityX:Int = 325;
	public inline static var maxPlayerVelocityY:Int = 5000;
	public inline static var maxJumpTime:Float = 0.15;
	
	
	public inline static var bossIdleTime:Float = 3;
	public inline static var bossChargeTime:Float = 1.75;
	public inline static var bossSlashTime:Float = 0.8;
	public inline static var bossDashTime:Float = 0.1;
	
	public static var playerRef:Player;
	public static var bossRef:Boss;
}