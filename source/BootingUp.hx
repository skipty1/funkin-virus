package;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
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

class BootingUp extends MusicBeatState {
	public var logoAnim:FlxSprite;
	
	override function create() {
		#if sys
		#if desktop
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
		#else 
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays")) // Main.path + 
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
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
		
		logoAnim = new FlxSprite();
		logoAnim.frames = fromJson(Paths.image("8bit/POWER_ROOM", "shared"), Paths.file("images/8bit/POWER_ROOM.json", "shared"));
		logoAnim.animation.addByNames("start", ["POWER ROOM 0.aseprite", "POWER ROOM 1.aseprite", "POWER ROOM 2.aseprite", "POWER ROOM 3.aseprite", "POWER ROOM 4.aseprite", "POWER ROOM 5.aseprite", "POWER ROOM 6.aseprite", "POWER ROOM 7.aseprite", "POWER ROOM 8.aseprite", "POWER ROOM 9.aseprite", "POWER ROOM 10.aseprite", "POWER ROOM 11.aseprite", "POWER ROOM 12.aseprite", "POWER ROOM 13.aseprite", "POWER ROOM 14.aseprite", "POWER ROOM 15.aseprite", "POWER ROOM 16.aseprite", "POWER ROOM 17.aseprite", "POWER ROOM 18.aseprite", "POWER ROOM 19.aseprite", "POWER ROOM 20.aseprite", "POWER ROOM 21.aseprite", "POWER ROOM 22.aseprite", "POWER ROOM 23.aseprite", "POWER ROOM 24.aseprite", "POWER ROOM 25.aseprite", "POWER ROOM 26.aseprite", "POWER ROOM 27.aseprite", "POWER ROOM 28.aseprite", "POWER ROOM 29.aseprite", "POWER ROOM 30.aseprite", "POWER ROOM 31.aseprite", 'POWER ROOM 32.aseprite', "POWER ROOM 33.aseprite", "POWER ROOM 34.aseprite", "POWER ROOM 35.aseprite", "POWER ROOM 36.aseprite", "POWER ROOM 37.aseprite", "POWER ROOM 38.aseprite", 'POWER ROOM 39.aseprite', "POWER ROOM 40.aseprite", "POWER ROOM 41.aseprite", "POWER ROOM 42.aseprite", "POWER ROOM 43.aseprite", "POWER ROOM 44.aseprite", "POWER ROOM 45.aseprite", "POWER ROOM 46.aseprite", "POWER ROOM 47.aseprite", "POWER ROOM 48.aseprite"], 12, false);
		logoAnim.scale.set(2,2);
		add(logoAnim);
		logoAnim.screenCenter();
		logoAnim.animation.play("start", false);
		
		super.create();
	}
	
	override public function update(h:Float) {
		
		super.update(h);
		
		if (logoAnim != null) {
			if (logoAnim.animation.name == "start" && logoAnim.animation.finished) {
				FlxG.switchState(new LogState());
			}
		}
	}
	public static function fromJson(Source:FlxGraphicAsset, Description:String):Null<Dynamic> {
		var graphic:FlxGraphic = FlxG.bitmap.add(Source);
		if (graphic == null)
			return null;

		// No need to parse data again
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		if (graphic == null || Description == null)
			return null;

		frames = new FlxAtlasFrames(graphic);

		if (Assets.exists(Description))
			Description = Assets.getText(Description);

		var json = Json.parse(Description);
		var framelist = Reflect.fields(json.frames);

		for (framename in framelist)
		{
			var frame = Reflect.field(json.frames, framename);
			// trace(frame);
			var rect = FlxRect.get(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h);
			// var duration:Int = frame.duration; // 100 = 10fps???

			frames.addAtlasFrame(rect, FlxPoint.get(rect.width, rect.height), FlxPoint.get(), framename);
		}

		return frames;
	}
}