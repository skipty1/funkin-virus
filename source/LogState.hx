package;

import openfl.utils.ByteArray;
import Achievements.MedalSaves;
import haxe.io.Bytes;
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
//@:file("myKey.privatekey") class MyKey extends openfl.utils.ByteArrayData { }

class LogState extends MusicBeatState{

	var chooseName:FlxText;
	//var bytearray:MyKey;
	var keystring:String;

	var name:FlxUIInputText;

	var flicktimer:FlxTimer;

	override public function create(){
		#if sys
		#if desktop
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
		#else 
		if (!sys.FileSystem.exists(Main.path + Sys.getCwd() + "/assets/replays"))
		#end
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end
		#if windows
		if (FlxG.save.data.discordPresence)
			DiscordClient.changePresence("08", null);
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		FlxG.save.bind('funkin', 'virus99');

		PlayerSettings.init();

		KadeEngineData.initSave();
		MedalSaves.initMedal();
		GameJoltPlayerData.loadInit();
		Highscore.load();
		

		//bytearray = new MyKey();
		var http = new haxe.Http("https://raw.githubusercontent.com/zacksgamerz/funkin-virus/master/myKey.privatekey");
		var returnedData:Array<String> = [];
		http.onData = function (data:String)
			{
				returnedData[0] = data.substring(0, data.indexOf(';'));
				returnedData[1] = data.substring(data.indexOf('-'), data.length);
				if (FlxG.save.data.privatekey != returnedData[0] || FlxG.save.data.privatekey == null)
					FlxG.save.data.privatekey == returnedData[0];
				else
					trace('awesomed');
			}

		http.onError = function (error) {
		  trace('error: $error');
		}
		http.request();
		//keystring = bytearray.readUTFBytes(bytearray.length);
		
		if (!FlxGameJolt._initialized && !FlxG.save.data.Banned && FlxG.save.data.user != null && FlxG.save.data.token != null){
			FlxGameJolt.init(643489, FlxG.save.data.privatekey, FlxG.save.data.user, FlxG.save.data.token);
			GameJoltPlayerData.loadInit(true);
			FlxGameJolt.openSession();
			trace("elfuck");
		}

		chooseName = new FlxText(FlxG.width * 0.7, 5, 0, "Type in your BetaTester code.", 32);
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
		add(name);

		doTheFlick();

		super.create();
	}
	override public function update(elapsed:Float){
		super.update(elapsed);
		
		name.hasFocus = true;
		
		if (FlxG.keys.justPressed.ENTER){
		flicktimer.cancel();
		chooseName.visible = true;
			switch(name.text.toLowerCase()){
				case "8bitryan" | "8-bitryan":
					chooseName.text = "Welcome, Ryan.";
					moveStates();
				case "eastenders":
					chooseName.text = "Welcome, Aqua from the MVA Team.";
					moveStates();
				case "rusron":
					chooseName.text = "Welcome, Director.";
					moveStates();
				case "john":
					chooseName.text = "Welcome, John from the MVA Team.";
					moveStates();
				case "lucky":
					chooseName.text = "Welcome, Luckydog from the MVA Team.";
					moveStates();
				case "zack":
					chooseName.text = "Welcome, Zack from the MVA Team.";
					moveStates();
				case "tqualizer":
					chooseName.text = "Welcome, Tea from the MVA Team.";
					moveStates();
				case "flippy":
					chooseName.text = "Welcome, Flippy.";
					moveStates();
				case "gegcoin":
					chooseName.text = "Welcome, Gegcoin.";
					moveStates();
				case "ginger":
					chooseName.text = "Welcome, Ginger from the MVA Team.";
					moveStates();
				case "cory":
					chooseName.text = "Welcome, Coach Cory.";
					moveStates();
				case "lpt":
					chooseName.text = "Welcome, La Pecera Tonta.";
					moveStates();
				case "pawchaw":
					chooseName.text = "Welcome, Paul.";
					moveStates();
				case "dani":
					chooseName.text = "Welcome, Dani.";
					moveStates();
				case "gus":
					chooseName.text = "Welcome, Tio Gus";
					moveStates();
				case "nery":
					chooseName.text = "Welcome, Nery.";
					moveStates();
				case "oraku":
					chooseName.text = "Welcome, Ilu from the TRASHKNIGHT Team.";
					moveStates();
				case "redsty":
					chooseName.text = "Welcome, Redsty from Team Darcayic.";
					moveStates();
				case 'klav':
					chooseName.text = 'you sneaky bumbass.';
					moveStates();
				case "08404":
					chooseName.text = "can i put my balls in yo jaws";
					moveStates();
				default:
					moveStates(true);
			}
		}
	}
	function moveStates(?lmaoNo:Bool = false){
		if (!lmaoNo){
			new FlxTimer().start(1.5, function(tmr:FlxTimer){
				FlxG.switchState(new TitleState());
			});
		}
		else{
			chooseName.text = "Invalid BetaTester pass.";
			new FlxTimer().start(1.5, function(tmr:FlxTimer){
				chooseName.text = "Type in your BetaTester code.";
			});
		}
		chooseName.screenCenter(X);
	}
	function doTheFlick(){
		flicktimer = new FlxTimer().start(0.8, function(tmr:FlxTimer){
				// chooseName.visible = !chooseName.visible;
				tmr.reset(0.8);
		});
	}
}