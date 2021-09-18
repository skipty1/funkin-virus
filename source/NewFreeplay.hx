package;
import openfl.utils.Future;
import openfl.media.Sound;
import flixel.tweens.FlxTween;
import flixel.system.FlxSound;
#if sys
import smTools.SMFile;
import sys.FileSystem;
import sys.io.File;
#end
import Song.SwagSong;
import flixel.input.gamepad.FlxGamepad;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class NewFreeplay extends MusicBeatState
{
	var curDiffInt:Int = 1;
	var curDiffString:String = "";
	var curSong:String = "disco";
	var curSelected:String = 0;
	
	var daBg:FlxSprite;
	var daFlicker:FlxSprite;
	var daBf:FlxSprite;
	var daBfFlicker:FlxSprite;
	var ThefuckingSongSpr:FlxSprite;
	
	override function create(){
		#if windows
		if (FlxG.save.data.discordPresence)
			DiscordClient.changePresence("In the Freeplay Menu", null);
		#end
		
		persistentUpdate = true;
		curSelected = 1;
		curDiffString = "";
		curSong = "disco";
		curDiffInt = 1;
		
		ThefuckingSongSpr = new FlxSprite(-50, 50);
		ThefuckingSongSpr.frames = Paths.getSparrowAtlas("8bit/songs", "shared");
		ThefuckingSongSpr.scale.set(2,2);
		//ThefuckingSongSpr.animation.addByPrefix("1","BOOTED UP0");
		ThefuckingSongSpr.animation.addByPrefix("1","DISCO0");
		ThefuckingSongSpr.animation.addByPrefix("2","INTOXIC80");
		//ThefuckingSongSpr.animation.addByPrefix("4","QUICKDRAW0");
		//ThefuckingSongSpr.animation.addByPrefix("5","EXERROR");
		//ThefuckingSongSpr.animation.addByPrefix("6","ALTERBYTE");
		ThefuckingSongSpr.animation.play("1");
		ThefuckingSongSpr.antialiasing = false;
		add(ThefuckingSongSpr);
		
		daBg = new FlxSprite(-100).loadGraphic(Paths.image("8bit/game_room", "shared"));
		daBg.scale.set(2,2);
		
		daBg.antialiasing = true;
		add(daBg);
		daFlicker = new FlxSprite(-100).loadGraphic(Paths.image("8bit/game_room_blu", "shared"));
		daFlicker.scale.set(2,2);
		daFlicker.antialiasing = true;
		add(daFlicker);
		daFlicker.visible = false;
	
		daBf = new FlxSprite(-100,100).loadGraphic(Paths.image("8bit/bf","shared"));
		daBf.scale.set(2,2);
		daBf.antialiasing = true;
		add(daBf);
		FlxTween.tween(daBf, {y: 0}, 0.6);
		
		daBfFlicker = new FlxSprite(-100).loadGraphic(Paths.image("8bit/bf","shared"));
		daBfFlicker.scale.set(2,2);
		daBfFlicker.antialiasing = true;
		add(daBfFlicker);
		daBfFlicker.visible = false;
		
		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 105, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);
		
	}
	
	override function update(elapsed:Float){
		if (FlxG.save.data.lessUpdate)
			super.update(elapsed/2);
		else
			super.update(elapsed);
		
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		if (FlxG.sound.music.volume > 0.8)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
		}
		
		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);
		if (controls.UP_P)
			changeSong(-1);
		if (controls.DOWN_P)
			changeSong(1);
		if (controls.ACCEPT)
			play();
	}
	function changeDiff(?crap:Int = 0){
		curDiffInt += crap
		if (curDiffInt == 3 || curDiffInt == -1)
			curDiffInt = 0;
		
		switch (curDiffInt){
			case 0:
				curDiffString = "-easy";
			case 1:
				curDiffString = "";
			case 2:
				curDiffString = "-hard";
		}
	}
	function changeSong(?crap:Int = 0){
		curSelected += crap;
		if (curSelected == 3 || curSelected == 0)
			curSelected = 1;
		
		switch (curSelected){
			case 1:
				curSong = "disco";
			case 2:
				curSong = "intoxicate";
		}
		FlxG.sound.playMusic(Paths.inst(curSong), 0);
	}
	function play(){
			PlayState.storyPlaylist = ["Disco","Intoxicate"];
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDiffInt;
			var poop:String = Highscore.formatSong(PlayState.storyPlaylist[curSelected - 1], curDiffInt);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[curSelected - 1]);
			PlayState.storyWeek = 1;
			PlayState.campaignScore = 0;
			LoadingState.loadAndSwitchState(new PlayState(), true);
	}
}