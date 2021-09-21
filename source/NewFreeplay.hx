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
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.tweens.*;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class NewFreeplay extends MusicBeatState
{
	var curDiffInt:Int = 1;
	var curDiffString:String = "";
	var curSong:String = "disco";
	var curSelected:Int = 0;
	
	var daBg:FlxSprite;
	var daFlicker:FlxSprite;
	var daBf:FlxSprite;
	var daBfFlicker:FlxSprite;
	var ThefuckingSongSpr:FlxSprite;
	var diffic:FlxSprite;
	
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
		
		ThefuckingSongSpr = new FlxSprite();
		ThefuckingSongSpr.frames = Paths.getSparrowAtlas("8bit/songs", "shared");
		ThefuckingSongSpr.scale.set(2,2);
		//ThefuckingSongSpr.animation.addByPrefix("1","BOOTED UP0");
		ThefuckingSongSpr.animation.addByPrefix("1","DISCO0");
		//ThefuckingSongSpr.animation.addByPrefix("2","INTOXIC80");
		//ThefuckingSongSpr.animation.addByPrefix("4","QUICKDRAW0");
		//ThefuckingSongSpr.animation.addByPrefix("5","EXERROR");
		//ThefuckingSongSpr.animation.addByPrefix("6","ALTERBYTE");
		ThefuckingSongSpr.animation.play("1");
		ThefuckingSongSpr.antialiasing = false;
		ThefuckingSongSpr.screenCenter();
		ThefuckingSongSpr.x += 10;
		ThefuckingSongSpr.y -= 20;
		add(ThefuckingSongSpr);
		
		daBg = new FlxSprite().loadGraphic(Paths.image("8bit/game_room", "shared"));
		daBg.scale.set(2,2);
		
		daBg.antialiasing = false;
		daBg.screenCenter();
		add(daBg);
		daFlicker = new FlxSprite().loadGraphic(Paths.image("8bit/game_room_blu", "shared"));
		daFlicker.scale.set(2,2);
		daFlicker.antialiasing = false;
		daFlicker.screenCenter();
		add(daFlicker);
		daFlicker.visible = false;
	
		daBf = new FlxSprite(0,3000).loadGraphic(Paths.image("8bit/bf","shared"));
		daBf.scale.set(2,2);
		daBf.antialiasing = false;
		daBf.screenCenter(X);
		add(daBf);
		
		daBfFlicker = new FlxSprite(0, 200).loadGraphic(Paths.image("8bit/BF_line","shared"));
		daBfFlicker.scale.set(2,2);
		daBfFlicker.antialiasing = false;
		add(daBfFlicker);
		daBfFlicker.screenCenter(X);
		daBfFlicker.visible = false;

		diffic = new FlxSprite(FlxG.width - 440, -230);
		diffic.antialiasing = false;
		diffic.frames = Paths.getSparrowAtlas('8bit/Difficulty_selection', 'shared');
		diffic.animation.addByPrefix('easy', 'unEZ');
		diffic.animation.addByPrefix('normal', 'unNOM');
		diffic.animation.addByPrefix('hard', 'unHARD');
		diffic.setGraphicSize(Std.int(diffic.width * 2));
		diffic.animation.play('normal');
		add(diffic);
		
		/*var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 105, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);*/

		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			FlxTween.tween(daBf, {y: 200}, 0.6);
		});
		changeSong();
		
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
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.ACCEPT)
			play();
	}
	function changeDiff(?crap:Int = 0){
		var isBlank:Bool = false;
		curDiffInt += crap;
		if (curDiffInt == 3 || curDiffInt == -1)
			curDiffInt = 0;
		
		switch (curDiffInt){
			case 0:
				curDiffString = "-easy";
			case 1:
				curDiffString = "";
				isBlank = true;
			case 2:
				curDiffString = "-hard";
		}
		var help = (isBlank ? "normal" : curDiffString.substr(1).trim());
		diffic.animation.play(help);
		diffic.y = -230;
		switch (help)
		{
			case 'normal':
				diffic.y -= 0;
			case 'hard':
				diffic.y += 30;
			case 'easy':
				diffic.y -= 40;
		}
		FlxTween.tween(diffic, {x: diffic.x + 300}, 0.02, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
			diffic.x = FlxG.width - 500;
			if (help == 'easy')
				diffic.x += 60;
			else if (help == 'hard')
				diffic.x += 20;
		}});
	}
	function changeSong(?crap:Int = 0){
		curSelected += crap;
		if (curSelected == 2 || curSelected == 0)
			curSelected = 1;
		
		switch (curSelected){
			case 1:
				curSong = "disco";
			//case 2:
				//curSong = "intoxicate";
		}
		FlxG.sound.playMusic(Paths.inst(curSong), 0);
		ThefuckingSongSpr.animation.play(Std.string(curSelected));
	}
	function play(){
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(daBfFlicker, 2, 0.5);
			FlxFlicker.flicker(daFlicker, 2, 0.5, true, true, function(flick:FlxFlicker){
				PlayState.storyPlaylist = ["Disco"];
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
			});

	}
}