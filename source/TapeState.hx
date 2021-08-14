package;

import MenuThings;
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
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
//import MenuThings.TapeStuff;

using StringTools;

class TapeState extends MusicBeatState{
	public var TapeThings:TapeStuff;
	public var rareSounds:Array<String> = ["starr01","patient08"];
	public var songs:Array<String> = ["D1SC0","INTOXIC8","SALOON8"];
	public var Playing:FlxSprite;
	public var Instructions:FlxText;
	public var songID:String = "disco";
	public var isPaused:Bool = false;
	public var leftkey:FlxSprite;
	public var menu:FlxSprite;
	public var playkey:FlxSprite;
	public var rightkey:FlxSprite;
	public var sp:FlxSprite;

	override function create(){
		if (FlxG.sound.music.playing)
			FlxG.sound.music.stop();

		super.create();

		if (FlxG.save.data.closedd == null)
			FlxG.save.data.closedd = false;

		var tapeBg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('8bit/musicbg','shared'));
		tapeBg.scale.set(2,2);
		tapeBg.screenCenter();
		tapeBg.antialiasing = false;
		add(tapeBg);

		var box:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('8bit/cdbox','shared'));
		box.scale.set(2,2);
		box.screenCenter();
		box.antialiasing = false;
		add(box);

		Playing = new FlxSprite(-100).loadGraphic(Paths.image('8bit/playing','shared'));
		Playing.scale.set(2,2);
		Playing.screenCenter();
		Playing.antialiasing = false;
		add(Playing);
		Playing.visible = false;

		leftkey = new FlxSprite(0,0);
		leftkey.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		leftkey.scale.set(2,2);
		leftkey.animation.addByPrefix("selected","left0",24,false);
		leftkey.animation.addByPrefix("unselected","unleft0",24,false);
		leftkey.animation.addByPrefix("clicked","tapleft0",24,false);
		leftkey.animation.play("unselected");
		leftkey.antialiasing = false;
		add(leftkey);

		menu = new FlxSprite(0,0);
		menu.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		menu.scale.set(2,2);
		menu.animation.addByPrefix("selected","menu0",24,false);
		menu.animation.addByPrefix("unselected","unmenu0",24,false);
		menu.animation.addByPrefix("clicked","tapmenu0",24,false);
		menu.animation.play("unselected");
		menu.antialiasing = false;
		add(menu);

		playkey = new FlxSprite(0,0);
		playkey.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		playkey.scale.set(2,2);
		playkey.animation.addByPrefix("selected","paly0",24,false);
		playkey.animation.addByPrefix("unselected","unplay0",24,false);
		playkey.animation.addByPrefix("clicked","tapplay0",24,false);
		playkey.animation.play("unselected");
		playkey.antialiasing = false;
		add(playkey);

		rightkey = new FlxSprite(0,0);
		rightkey.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		rightkey.scale.set(2,2);
		rightkey.animation.addByPrefix("selected","right0",24,false);
		rightkey.animation.addByPrefix("unselected","unright0",24,false);
		rightkey.animation.addByPrefix("clicked","tapright0",24,false);
		rightkey.animation.play("selected");
		rightkey.antialiasing = false;
		add(rightkey);

		sp = new FlxSprite(0,0);
		sp.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		sp.scale.set(2,2);
		sp.animation.addByPrefix("selected","sp0",24,false);
		sp.animation.addByPrefix("unselected","unsp0",24,false);
		sp.animation.addByPrefix("clicked","tapsp0",24,false);
		sp.animation.play("unselected");
		sp.antialiasing = false;
		add(sp);

		Instructions = new FlxText(0, 0, 0, "Click the buttons to navigate or play songs\nPress BACK to leave.\nPress P to Pause\n(C to Close Instructions)\n");
		Instructions.screenCenter(X);
		Instructions.screenCenter(Y);
		Instructions.alignment = CENTER;
		Instructions.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK, 3);
		if (!FlxG.save.data.closedd)
			add(Instructions);

		changeSong();

		//playSong("disco");
	}

	override function update(elapsed:Float){
		if (FlxG.keys.justPressed.C && !FlxG.save.data.closedd){
			remove(Instructions);
			FlxG.save.data.closedd = true;
		}

		super.update(elapsed);

		if (FlxG.keys.justPressed.P){
			pauseSong();
		}

		if (FlxG.mouse.overlaps(leftkey) && FlxG.mouse.justPressed){
			changeSong(-1);
			playAnim(0, "clicked");
		}

		if (FlxG.mouse.overlaps(menu) && FlxG.mouse.justPressed ){
			quit();
			playAnim(1, "clicked");
		}

		if (FlxG.mouse.overlaps(playkey) && FlxG.mouse.justPressed){
			playSong(songID);
			playAnim(2, "clicked");
		}

		if (FlxG.mouse.overlaps(rightkey) && FlxG.mouse.justPressed){
			changeSong(1);
			playAnim(3, "clicked");
		}

		if (FlxG.mouse.overlaps(sp) && FlxG.mouse.justPressed){
			playAnim(4, "clicked");
			dontLeave();
		}

		if (FlxG.mouse.overlaps(sp))
			playAnim(4, "selected");
		else
			playAnim(4, "unselected");

		if (FlxG.mouse.overlaps(rightkey))
			playAnim(3, "selected");
		else
			playAnim(3, "unselected");

		if (FlxG.mouse.overlaps(playkey))
			playAnim(2, "selected");
		else
			playAnim(2, "unselected");

		if (FlxG.mouse.overlaps(menu))
			playAnim(1, "selected");
		else
			playAnim(1, "unselected");

		if (FlxG.mouse.overlaps(leftkey))
			playAnim(0, "selected");
		else
			playAnim(0, "unselected");
	}
	var stupid:Int = 0;
	function changeSong(?uh:Int = 0){
		stupid += uh;

		if (stupid < 0 || stupid > 1)
			stupid = 0;

		switch (stupid){
			case 0:
				songID = "disco";
			case 1:
				songID = "intoxicate";
			default:
				songID = "invalid";
		}
		textAppear();
	}

	function playSong(song:String){
		if (FlxG.sound.music.playing && !isPaused)
			FlxG.sound.music.stop();

		if (FlxG.random.bool(20)){
			FlxG.sound.play(Paths.sound(FlxG.random.getObject(rareSounds), 'shared'));
		}else{
			if (isPaused){
				FlxG.sound.music.resume();
				isPaused = false;
			}else{
				FlxG.sound.playMusic(Paths.music(song), 0);
			}
		}

		Playing.visible = true;
		textAppear(true);
	}

	function pauseSong(){
		if (FlxG.sound.music.playing){
			FlxG.sound.music.pause();
			isPaused = true;
			Playing.visible = false;
		}
	}

	function quit(){
		FlxG.switchState(new MainMenuState());
	}

	function dontLeave(){
		if (FlxG.random.bool(1)){
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();

			FlxG.sound.play(Paths.sound('starrpark','shared'));
			//new FlxTimer()
		}
	}
	var txt:FlxText;
	var removedtext = true;
	function textAppear(?isPlay:Bool = false){
		if (!removedtext){
			remove(txt);
			removedtext = true;
		}
		txt = new FlxText(0, 0, 0, "Selected: " + songID + "\n", 48);

		if (isPlay)
			txt.text = "Playing: " + songID + "\n";

		txt.color = FlxColor.fromRGB(133, 256, 133);
		txt.alignment = CENTER;
		txt.y = FlxG.height - 125;
		txt.alpha = 0;
		txt.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK, 3);
		add(txt);
		removedtext = false;
		txt.screenCenter(X);

		if (!removedtext){
			new FlxTimer().start(0.1, function(tmr:FlxTimer){
				txt.alpha += 0.1;
				if (txt.alpha < 0.9)
					tmr.reset(0.1);
			});

			new FlxTimer().start(3.5, function(tmrvv:FlxTimer){
				new FlxTimer().start(0.1, function(tmr:FlxTimer){
					txt.alpha -= 0.1;
					if (txt.alpha != 0){
						tmr.reset(0.1);
					}else{
						if (!removedtext){
							remove(txt);
							removedtext = true
						}
					}
				});
			});
		}
	}
	public function playAnim(ID:Int,Anim:String){
		switch (ID){
			case 0:
				leftkey.animation.play(Anim);
			case 1:
				menu.animation.play(Anim);
			case 2:
				playkey.animation.play(Anim);
			case 3:
				rightkey.animation.play(Anim);
			case 4:
				sp.animation.play(Anim);
			default:
				trace('Invalid Id');
		}
	}
}