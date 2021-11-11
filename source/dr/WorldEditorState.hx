package dr;

import flixel.util.FlxSignal;
import flixel.util.FlxDestroyUtil;
import Achievements.MedalSaves;
import openfl.Lib;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import flixel.tile.FlxTilemap;
import openfl.utils.Assets;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import dr.*;

class WorldEditorState extends MusicBeatState {
	var camWorld:FlxCamera;
	var camHUD:FlxCamera;

	var tilemap:FlxTilemap;
	var walls:FlxTilemap; // invis walls
	//based lucky.
	// public var player:BasePlayer;
	public var player:BetterKris;
	var ogmo:FlxOgmo3Loader;
	
	override public function create() 
	{
		#if desktop
		FlxG.mouse.visible = true;
		#end

		// just test
		FlxG.save.bind('funkin', 'virus99');
		PlayerSettings.init();
		KadeEngineData.initSave();
		MedalSaves.initMedal();
		GameJoltPlayerData.loadInit();
		Highscore.load();

		camWorld = new FlxCamera();
		camWorld.bgColor = FlxColor.fromRGB(71, 74, 81);
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camHUD.zoom = 4;

		FlxG.cameras.reset(camWorld);
		FlxG.cameras.setDefaultDrawTarget(camWorld, true);

		var testSprite = new FlxSprite().loadGraphic(Paths.image('stepmania-icon'));
		testSprite.cameras = [camWorld];
		add(testSprite);

		createLevel();
		addEntities();

		super.create();
	}

	function addEntities() {
		//player = new BasePlayer();
		//player.cameras = [camWorld];
		//add(player);
		player = new BetterKris();
		player.cameras = [camWorld];
		add(player);

		ogmo.loadEntities(placeEntities, "entities"); // entities - layer

		camWorld.follow(player, NO_DEAD_ZONE);
	}

	function createLevel(level:String = "start") {
		var path = 'assets/data/maps';

		ogmo = new FlxOgmo3Loader('$path/project.ogmo', '$path/levels/$level.json');

		tilemap = ogmo.loadTilemap(Assets.getBitmapData('$path/tile1.png'), 'walls'); // image, layer (layer name in ogmo)
		tilemap.cameras = [camWorld];
		// tilemap.follow(camWorld);
		tilemap.setTileProperties(12, FlxObject.NONE); // cant go through this tile
		tilemap.setTileProperties(18, FlxObject.ANY); // can
		add(tilemap);

		createWalls(path);
	}

	function destroyLevel() {
		ogmo = null;
		tilemap.destroy();
		tilemap = null;
		// FlxDestroyUtil.destroyArray(entities);
		//player.destroy();
		player.destroy();
		//player = null;
		player = null;
	}

	function createWalls(path) {
		// walls = ogmo.loadTilemap(Assets.getBitmapData('$path/tile1.png'), 'collision');
		// tilemap.setTileProperties(12, FlxObject.NONE);
		// tilemap.setTileProperties(18, FlxObject.ANY);
		// walls.visible = false;
		// add(walls);
	}

	var entities:Array<Trigger> = [];

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			//player.setPosition(entity.x, entity.y);
			player.setPosition(entity.x, entity.y);
		}

		if (entity.name == "tp") 
		{
			var trigger = new Trigger(entity.x, entity.y, entity.width, entity.height);

			trigger.onPlayerOverlap = () ->
			{
				destroyLevel();
				createLevel(entity.values.tolevel);
				addEntities();
			}

			entities.push(trigger);
		}
	}

	override public function update(elapsed:Float) {
		#if desktop 
		camWorld.zoom += FlxG.mouse.wheel;
		#end

		if (FlxG.keys.justReleased.ALT)
			destroyLevel();

		for(e in entities)
		{
			if (player != null)
				e.checkPlayerCollision(player);
		}
		
		super.update(elapsed);

		FlxG.collide(player, tilemap);
	}
}

typedef FastFloat = #if cpp cpp.Float32 #else Float #end; // why not
typedef FastInt = #if cpp cpp.Char #else Int #end;

class Trigger extends FlxObject {
	public function new(?x, ?y, ?w, ?h) {
		super(x, y, w, h);
	}

	var lastol:Bool = false;

	public function checkPlayerCollision(player:BasePlayer) {
		var isOverlaps = overlaps(player);
		
		if(isOverlaps && isOverlaps != lastol)
		{
			lastol = true;
			onPlayerOverlap();
		}
		else if(isOverlaps != lastol)
		{
			lastol = false;
		}
	}

	// override public function update(elapsed:Float) {
	// 	super.update(elapsed);
	// }

	dynamic public function onPlayerOverlap() {
		
	}
}