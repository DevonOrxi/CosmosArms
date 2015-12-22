package states;

import entities.Enemy;
import entities.Player;
import entities.PlayerBrawl;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;


class PlayState extends FlxState
{
	private var player:PlayerBrawl;
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
		
		loader = new FlxOgmoLoader("assets/data/sandbox.oel");
		
		backgroundLevel = loader.loadTilemap("assets/images/mininicular.png", 16, 16, "bTiles");
		
		foregroundLevel = loader.loadTilemap("assets/images/mininicular.png", 16, 16, "fTiles");
		foregroundLevel.setTileProperties(50, FlxObject.NONE);
		foregroundLevel.setTileProperties(51, FlxObject.NONE);
		
		player = new PlayerBrawl(300, 300);
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
		
		
		FlxG.camera.follow(player);
		
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
	
	override public function update():Void
	{		
		super.update();
		
		FlxG.overlap(foregroundLevel, player, null, FlxObject.separate);
		
		if (FlxG.pixelPerfectOverlap(enemy, player.get_weapon()) &&
			player.get_weapon().get_enemyHitList().members.indexOf(enemy) == -1
		)
		{
			player.get_weapon().get_enemyHitList().add(enemy);
			trace("HIT");
		}
		
		var screenXY:FlxPoint = player.get_weapon().getScreenXY();
		FlxSpriteUtil.fill(transparent, 0x00000000);
		playerFrame.loadGraphic(player.get_weapon().getFlxFrameBitmapData());
		spaceFrame.loadGraphic(space.getFlxFrameBitmapData());
		transparent.stamp(
			playerFrame,
			Std.int(screenXY.x - player.get_weapon().offset.x),
			Std.int( screenXY.y - player.get_weapon().offset.y)
		);		
		FlxSpriteUtil.alphaMaskFlxSprite(spaceFrame, transparent, transparent);
	}	
}