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


class PlayState extends FlxState
{
	private var player:PlayerBrawl;
	private var platform:FlxSprite;
	private var enemy:Enemy;
	private var loader:FlxOgmoLoader;
	private var foregroundLevel:FlxTilemap;
	private var backgroundLevel:FlxTilemap;
	
	override public function create():Void
	{
		super.create();
		
		loader = new FlxOgmoLoader("assets/data/cz.oel");
		
		backgroundLevel = loader.loadTilemap("assets/images/mininicular.png", 16, 16, "bTiles");
		
		foregroundLevel = loader.loadTilemap("assets/images/mininicular.png", 16, 16, "fTiles");
		foregroundLevel.setTileProperties(50, FlxObject.NONE);
		foregroundLevel.setTileProperties(51, FlxObject.NONE);
		
		player = new PlayerBrawl(300, 300);
		enemy = new Enemy(500, 350);
		
		platform = new FlxSprite(0, 400);
		platform.makeGraphic(640, 20);
		platform.immovable = true;
		
		FlxG.camera.follow(player);
		
		add(backgroundLevel);
		add(foregroundLevel);
		//add(enemy);
		add(player);
		add(player.get_weapon());
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function update():Void
	{
		if (FlxG.pixelPerfectOverlap(enemy, player.get_weapon()) &&
			player.get_weapon().get_enemyHitList().members.indexOf(enemy) == -1
		)
		{
			player.get_weapon().get_enemyHitList().add(enemy);
			trace("HIT");
		}
		
		super.update();
		
		FlxG.collide(foregroundLevel, player);
	}	
}