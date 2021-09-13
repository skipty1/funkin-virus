package;

import openfl.utils.ByteArray;
import Achievements.MedalSaves;
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

@:file("myKey.privatekey") class MyOtherKey extends ByteArrayData { }

class GamejoltState extends MusicBeatState{
	var chooseName:FlxText;
	var bytearray:MyOtherKey;
	var gameid:Int;
	var keystring:String;
	
	var usertoken:String;
	var username:String;

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
		
		var gamejolt = new FlxSprite(0, 18).loadGraphic(Paths.image("8bit/gamejolt","shared"));
		gamejolt.scale.set(2,2);
		gamejolt.antialiasing = false;
		gamejolt.screenCenter(X);
		add(gamejolt);
		
		chooseName = new FlxText(FlxG.width * 0.7, 5, 0, "Log in into Gamejolt to sync your data to the full version\n and get 50 coins (+ 100 in full version)!\nPress ESCAPE to leave this screen.\n", 32);
		chooseName.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
		chooseName.alignment = CENTER;
		chooseName.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		chooseName.screenCenter();
		chooseName.y = 38;
		chooseName.scrollFactor.set();
		add(chooseName);

		name = new FlxUIInputText(10, 10, FlxG.width, 'Insert username.', 8);
		name.setFormat(Paths.font("vcr.ttf"), 50, FlxColor.WHITE, CENTER);
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
		bytearray = new MyOtherKey();
		keystring = bytearray.readUTFBytes(bytearray.length);
		gameid = 643489;

		//doTheFlick();
		
		if (FlxGameJolt._initialized){
			name.visible = false;
			chooseName.text = "Logged in: " + FlxG.save.data.user + "\nToken: " + FlxG.save.data.usertoken;
		}

		super.create();
	}
	var mode:String = "user";

	override public function update(elapsed:Float){
		super.update(elapsed);
		if (FlxG.keys.justPressed.ENTER && name.text != ''){
			switch (mode){
				case "user":
					username = name.text;
					FlxG.save.data.user = username;
					name.text = "";
					chooseName.text = "Great! Now insert your user token.\n";
					mode = "token";
				case "token":
					usertoken = name.text;
					FlxG.save.data.token = usertoken;
					name.visible = false;
					chooseName.text = "Please wait...\n";
					FlxGameJolt.init(gameid, keystring, true, username, usertoken, (logged) -> {
						if (logged){
							chooseName.text = "Succesfully logged in!\n";
							GameJoltPlayerData.loadInit();
							FlxGameJolt.openSession();
						}else{
							chooseName.text = "Failed to log in.\n";
							new FlxTimer().start(1.5, function(tmr:FlxTimer){
								username = "";
								usertoken = "";
								if (!FlxGameJolt.lmfaoBanned){
									chooseName.text = "Log in into Gamejolt to sync your data to the full version and get 50 coins (+ 100 in full version)!\nPress ESCAPE to leave this screen.\n";
								}
								name.text = "Insert username.";
								mode = "user";
							});
						}
						if (FlxGameJolt.lmfaoBanned){
							chooseName.text = "ERROR: USER IS BANNED!\n";
						}
					});
			}
		}
		if (FlxG.keys.justPressed.ESCAPE){
			FlxG.switchState(new MainMenuState());
		}
	}
}