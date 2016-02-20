package states;

import entities.Enemy;
import entities.Player;
import entities.PlayerBrawl;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.FlxCamera;
import flixel.ui.FlxBar;


class BossState extends FlxState
{
	private var player:PlayerBrawl;
	private var enemy:Enemy;
	private var loader:FlxOgmoLoader;
	private var foregroundLevel:FlxTilemap;
	
	private var space:FlxSprite;
	private var spaceFrame:FlxSprite;
	private var playerFrame:FlxSprite;
	private var transparent:FlxSprite;
	
	private var playerLifeBar:FlxBar;
	private var playerLifeBarBackground:FlxSprite;
	
	private var bossMusic:FlxSound;
	
	
	override public function create():Void
	{
		super.create();
		
		loader = new FlxOgmoLoader("assets/data/bossvania.oel");
		
		foregroundLevel = loader.loadTilemap("assets/images/scifitiles-sheet.png", 32, 32, "tiles");
		foregroundLevel.setTileProperties(18, FlxObject.ANY);
		foregroundLevel.setTileProperties(5, FlxObject.NONE);
		foregroundLevel.setTileProperties(6, FlxObject.NONE);
		foregroundLevel.setTileProperties(7, FlxObject.NONE);
		foregroundLevel.setTileProperties(19, FlxObject.NONE);
		foregroundLevel.setTileProperties(20, FlxObject.NONE);
		foregroundLevel.setTileProperties(21, FlxObject.NONE);
		foregroundLevel.setTileProperties(33, FlxObject.NONE);
		foregroundLevel.setTileProperties(34, FlxObject.NONE);
		foregroundLevel.setTileProperties(35, FlxObject.NONE);
		
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
		
		playerLifeBar = new FlxBar(12 + 5, 10 + 16, FlxBarFillDirection.BOTTOM_TO_TOP, 11, 128, player, "get_pegHealth()", 0, 16);
		playerLifeBar.createImageBar(null, AssetPaths.lifeBarContent__png, 0x00000000);
		playerLifeBar.scrollFactor.set();
		
		playerLifeBarBackground = new FlxSprite(12, 10, AssetPaths.lifeBarEmpty__png);
		playerLifeBarBackground.scrollFactor.set();
		
		bossMusic = new FlxSound();
		bossMusic.loadEmbedded(AssetPaths.bossMusic__ogg, true);
		
		FlxG.camera.setScrollBoundsRect(foregroundLevel.x,  foregroundLevel.y, foregroundLevel.width,  foregroundLevel.height, true);
		
		FlxG.camera.target = player;
		FlxG.camera.style = FlxCameraFollowStyle.PLATFORMER;
		
		add(space);
		add(player.get_weapon());
		add(foregroundLevel);
		add(enemy);
		add(player);
		add(playerLifeBarBackground);
		add(playerLifeBar);
		add(transparent);
		
		bossMusic.play();
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