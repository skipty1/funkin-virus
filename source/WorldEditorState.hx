package;

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

class WorldEditorState extends MusicBeatState {
	var camWorld:FlxCamera;
    var camHUD:FlxCamera;

    var tilemap:FlxTilemap;
	var walls:FlxTilemap; // invis walls
    public var player:BasePlayer;
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
		player = new BasePlayer();
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
		player.destroy();
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

class BasePlayer extends FlxSprite {
    public var speed:Int = 300; // speed of player
    
    var up:Bool = false;
    var down:Bool = false;
    var left:Bool = false;
    var right:Bool = false;

	public var onMove:FlxSignal;
    
    public function new(?x, ?y, ?sg) {
        super(x, y, sg);
        makeGraphic(20, 20, FlxColor.BLUE);
        drag.x = drag.y = 1600;

		onMove = new FlxSignal();
    }

    override public function update(elapsed:Float) {
        updateMovement();
        
        super.update(elapsed);
    }

    function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		#end

		// #if mobile
		// var virtualPad = PlayState.virtualPad;
		// up = up || virtualPad.buttonUp.pressed;
		// down = down || virtualPad.buttonDown.pressed;
		// left = left || virtualPad.buttonLeft.pressed;
		// right = right || virtualPad.buttonRight.pressed;
		// #end

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			onMove.dispatch();

			var newAngle:Float = 0;
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = FlxObject.UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = FlxObject.DOWN;
			}
			else if (left)
			{
				newAngle = 180;
				facing = FlxObject.LEFT;
			}
			else if (right)
			{
				newAngle = 0;
				facing = FlxObject.RIGHT;
			}

			// determine our velocity based on angle and speed
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);

			// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
			// if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
			// {
			// 	stepSound.play();

			// 	switch (facing)
			// 	{
			// 		case LEFT, RIGHT:
			// 			animation.play("lr");
			// 		case UP:
			// 			animation.play("u");
			// 		case DOWN:
			// 			animation.play("d");
			// 		case _:
			// 	}
			// }
		}
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