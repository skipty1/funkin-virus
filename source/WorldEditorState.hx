package;

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

class WorldEditorState extends MusicBeatState {
    var camWorld:FlxCamera;
    var camHUD:FlxCamera;
    var target:FlxObject;

    var tilemap:FlxTilemap;
    
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

        target = new FlxObject(0, 0);

        var testSprite = new FlxSprite().loadGraphic(Paths.image('stepmania-icon'));
        testSprite.cameras = [camWorld];
        add(testSprite);

        camWorld.follow(target, NO_DEAD_ZONE);

        createLevel();

        add(text = new FlxText());

        super.create();
    }
    var text:FlxText;

    function createLevel() {
        var path = 'assets/data/maps';

        var ogmo = new FlxOgmo3Loader('$path/project.ogmo', '$path/levels/main.json');

        tilemap = ogmo.loadTilemap(Assets.getBitmapData('$path/a.png'), 'main');
        tilemap.cameras = [camWorld];
        add(tilemap);
    }

    override public function update(elapsed:Float) {
        #if desktop
        if(FlxG.keys.pressed.UP)
            target.y -= 60 * elapsed;

        if(FlxG.keys.pressed.DOWN)
            target.y += 60 * elapsed;
        
        if(FlxG.keys.pressed.LEFT)
            target.x -= 60 * elapsed;
        
        if(FlxG.keys.pressed.RIGHT)
            target.x += 60 * elapsed;

        #end

        // target.x += 3;
        // trace((cast(Lib.current.getChildAt(0), Main)).getFPS());

        calcCameraMove();
        #if desktop
        calcZoom();
        #end
        
        super.update(elapsed);
    }

    function calcZoom() {
        #if desktop 
        camWorld.zoom += FlxG.mouse.wheel;
        #end

        if(camWorld.zoom < 1)
            camWorld.zoom = 1;

        if(camWorld.zoom > 10)
            camWorld.zoom = 10;
    }

    function calcdist(p1:Array<Float>, p2:Array<Float>) {
        return Math.sqrt(Math.pow(p2[0] - p1[0], 2) + Math.pow(p2[1] - p1[1], 2));
    }

    var firstPoint = new FlxPoint();
    function calcCameraMove() {
        #if desktop
        if(FlxG.mouse.justReleased)
            firstPoint.set();
        
        if(FlxG.mouse.pressed)
        {
            if(firstPoint.x + firstPoint.y == 0)
                firstPoint.set(FlxG.mouse.x, FlxG.mouse.y);

            target.x += firstPoint.x - FlxG.mouse.x;
            target.y += firstPoint.y - FlxG.mouse.y;
        }
        #else
        var touch = FlxG.touches.list[0];
        
        if(touch != null)
        {
            if(touch.justReleased)
                firstPoint.set();
            
            if(touch.pressed)
            {
                if(firstPoint.x + firstPoint.y == 0)
                    firstPoint.set(touch.x, touch.y);
    
                target.x += firstPoint.x - touch.x;
                target.y += firstPoint.y - touch.y;
            }
        }
        #end
    }
}

typedef FastFloat = #if cpp cpp.Float32 #else Float #end; // why not
typedef FastInt = #if cpp cpp.Char #else Int #end;