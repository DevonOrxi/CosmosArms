package states;

import entities.Enemy;
import entities.Player;
import entities.Player;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.FlxCamera;


class PlayState extends FlxState
{
	private var player:Player;
	private var enemy:Enemy;
	private var loader:FlxOgmoLoader;
	private var foregroundLevel:FlxTilemap;
	private var backgroundLevel:FlxTilemap;
	
	private var space:FlxSprite;
	private var spaceFrame:FlxSprite;
	private var playerFrame:FlxSprite;
	private var transparent:FlxSprite;
	
	
	override public function create():Void
	{
		super.create();
		
		loader = new FlxOgmoLoader("assets/data/cz.oel");
		
		backgroundLevel = loader.loadTilemap("assets/images/mininicular.png", 16, 16, "bTiles");
		
		foregroundLevel = loader.loadTilemap("assets/images/mininicular.png", 16, 16, "fTiles");
		foregroundLevel.setTileProperties(50, FlxObject.NONE);
		foregroundLevel.setTileProperties(51, FlxObject.NONE);
		foregroundLevel.setTileProperties(1, FlxObject.ANY);
		foregroundLevel.setTileProperties(2, FlxObject.ANY);
		foregroundLevel.setTileProperties(3, FlxObject.ANY);
		
		player = new Player(300, 300);
		enemy = new Enemy(500, 350);
		
		space = new FlxSprite();
		space.loadGraphic("assets/images/space.png", true, 720, 480);
		space.animation.add("space", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 15, true);
		space.animation.play("space");
		space.scrollFactor.x = 0;
		space.scrollFactor.y = 0;
		
		playerFrame = new FlxSprite();
		spaceFrame = new FlxSprite();
		
		transparent = new FlxSprite();
		transparent.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
		transparent.scrollFactor.x = 0;
		transparent.scrollFactor.y = 0;
		
		
		FlxG.camera.setScrollBoundsRect(foregroundLevel.x,  foregroundLevel.y, foregroundLevel.width,  foregroundLevel.height, true);
		
		FlxG.camera.target = player;
		FlxG.camera.style = FlxCameraFollowStyle.PLATFORMER;
		
		add(space);
		add(player.get_weapon());
		add(backgroundLevel);
		add(foregroundLevel);
		add(enemy);
		add(player);
		add(transparent);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
		
		FlxG.collide(foregroundLevel, player);
		
		if (FlxG.pixelPerfectOverlap(enemy, player.get_weapon()) &&
			player.get_weapon().get_enemyHitList().members.indexOf(enemy) == -1
		)
		{
			player.get_weapon().get_enemyHitList().add(enemy);
			trace("HIT");
		}
		
		var screenXY:FlxPoint = player.get_weapon().getScreenPosition();
		FlxSpriteUtil.fill(transparent, 0x00000000);
		playerFrame.loadGraphic(player.get_weapon().updateFramePixels());
		spaceFrame.loadGraphic(space.updateFramePixels());
		transparent.stamp(
			playerFrame,
			Std.int(screenXY.x - player.get_weapon().offset.x),
			Std.int( screenXY.y - player.get_weapon().offset.y)
		);		
		FlxSpriteUtil.alphaMaskFlxSprite(spaceFrame, transparent, transparent);
	}	
}