package;

import FlxGameJolt;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.ui.FlxUIInputText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if newgrounds
import io.newgrounds.NG;
#end
import lime.app.Application;
#if cpp
import sys.thread.Thread;
#end
#if windows
import Discord.DiscordClient;
#end

@:file("myKey.privatekey") class MyKey extends ByteArray { }

class GamejoltState extends MusicBeatState{
	var chooseName:FlxText;

	var name:FlxUIInputText;

	override public function create(){
		#if sys
		#if desktop
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
		#else 
		if (!sys.FileSystem.exists(Main.path + Sys.getCwd() + "/assets/replays"))
		#end
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		FlxG.save.bind('funkin', 'virus99');

		PlayerSettings.init();

		KadeEngineData.initSave();
		MedalSaves.initMedal();
		
		Highscore.load();
		
		var bg = new FlxSprite().loadGraphic(Paths.image("8bit/skoy","shared"));
		bg.scale.set(6,6);
		bg.antialiasing = false;
		bg.screenCenter();
		add(bg);
		
		var gamejolt = new FlxSprite(0, -50).loadGraphic(Paths.image("gamejolt","shared"));
		gamejolt.scale.set(2,2);
		gamejolt.antialiasing = false;
		gamejolt.screenCenter(X);
		add(gamejolt);
		
		chooseName = new FlxText(FlxG.width * 0.7, 5, 0, "Log in into Gamejolt to sync your data to the full version and get 50 coins (+ 100 in full version)!\nPress ESCAPE to leave this screen.", 32);
		chooseName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		chooseName.alignment = CENTER;
		chooseName.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		chooseName.screenCenter(X);
		chooseName.y = 38;
		chooseName.scrollFactor.set();
		add(chooseName);

		name = new FlxUIInputText(10, 10, FlxG.width, '', 8);
		name.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, RIGHT);
		name.alignment = CENTER;
		name.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		name.screenCenter();
		name.scrollFactor.set();
		add(name);
		name.backgroundColor = 0xFF000000;
		name.maxLength = 31;
		name.lines = 1;
		name.caretColor = 0xFFFFFFFF;

		// gamejolt shit.
		var bytearray = new MyKey();
		var keystring = bytearray.readUTFBytes(bytearray.length);
		var gameid = 643489;

		//doTheFlick();

		super.create();
	}
}