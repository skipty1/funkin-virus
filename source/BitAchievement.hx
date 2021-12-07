package;

import haxe.Constraints.Function;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import Paths;

using StringTools;

//fhisjdx

class BitAchievements extends FlxSpriteGroup{
	//vars here
	var icon:FlxSprite;

	var bg:FlxSprite;
	
	public static var medalInfo:Array<Dynamic> = [//name, desc, tag, hidden
		["Save Complete", "Log in to GameJolt in-game.", "gjsave", true],
		["Good Game Well Played", "Complete a song.", "ggwp", false],
		["TouHou Bit", "Finish a song with over 100 misses.", "usucklmao", false],
		["Do you need a backup, dumbass?", "Fail 5 times in easy difficulty", "usucklol", false],
		["Sussy", "Press F 69 times in main menu.", "amogus", true],
		["Blu Spy", "FC D1SC0", "bluespyinthebase", false],
		["Spike", "Find the hidden spike.", "spike", true],
		["Bussy", "Press F 420 times in main menu.", "saiyanamogus", true],
		["Game Not Over", "Complete Story Mode", "storynotover", false],
		["Pro Player", "Enter a cheat code passed down from generation to generation in main menu", "soniccheatcode", true],
		["A New World?", "Enter a code that accesses a new world.. maybe.", "dinnerbone", false],
		["Single-Life", "Complete story mode without dying once.", "sweatyplayer", false],
		["The Perfect Player", "Complete everything in the game", "sweatymfplayer", false]
	];
	
	public static var achievementsMap:Map<String, Bool> = new Map<String, Bool>();

	//functions here
	private function new(?ASS:String){
		visible = false;
		super();
		
		bg = new FlxSprite().loadGraphic(Paths.image('8bit/UNLOCK', 'shared'));
		bg.scale.set(3,3);
		bg.updateHitbox();
		bg.antialiasing = false;
		add(bg);


		icon = new FlxSprite();
		//animations
		icon.frames = Paths.getSparrowAtlas('8bit/them','shared');

		icon.scale.set(3,3);
		icon.updateHitbox();
		icon.animation.addByPrefix('GGWP','GGWP',24,false);
		icon.animation.addByPrefix('Gamer','GAMER',24,false);
		icon.animation.addByPrefix('Blue Spy','BLUSPY',24,false);
		icon.animation.addByPrefix('TOUHOU Bit','touhou bit',24,false);
		icon.animation.addByPrefix('Pro Player','pro player',24,false);
		icon.animation.addByPrefix('ECHO','ECHO',24,false);
		icon.animation.addByPrefix('Good Ending','good ending',24,false);
		icon.animation.addByPrefix('Bad Ending','bad ending',24,false);
		icon.animation.addByPrefix('Firewall','firewall',24,false);
		icon.animation.addByPrefix('DUNABD','DUNABD',24,false);
		icon.animation.addByPrefix('CDBZ','CDBZ',24,false);
		icon.animation.addByPrefix('Spike','spike',24,false);//spike :)
		icon.animation.addByPrefix('One Coin','Only one coin',24,false);
		icon.animation.addByPrefix('TWTMF','TWTMF',24,false);
		icon.animation.addByPrefix('New World','new world',24,false);
		icon.animation.addByPrefix('Wild West','wild west',24,false);
		icon.animation.addByPrefix('Sus','sus',24,false);
		icon.animation.addByPrefix('Big Sus','BIG SUS',24,false);
		icon.animation.addByPrefix('The Perfect Player','The perfect player',24,false);
		
		icon.antialiasing = false;
		icon.setPosition(0, 0);
		add(icon);
		
		if (ASS == null)
		{
			trace('ass is null, aftermath of lmao too hard :(');
			icon.animation.play('Sus');
		}
		else
		{
			icon.animation.play(ASS);
			trace('ASS is there, dont lmao too hard now. that surgery costed a lot');
		}
		
	}

	public function play(duration:Float = 0.5, ?onEnd:Function)
	{
		//trace('playing "$name" achievement');

		x = FlxG.width - width - (width / 3);

		var y_start:Float = -height;
		var y_end:Float = 15;

		height = y_start;

		// hide
		var end = (_) ->
		{
			new FlxTimer().start(4, (_) ->
			{
				FlxTween.num(y_end, y_start, duration, {onComplete: function(_) visible = false && onEnd()}, (value) ->
				{
					y = value;
				});
			}, 4000);
		}

		// show
		FlxTween.num(y_start, y_end, duration, {onComplete: end, ease: FlxEase.bounceOut}, (value) ->
		{
			y = value;
		});

		visible = true;
	}

	//static var queue:Array<Achievements>;

	public static function popup(name:String, duration:Float = 0.5):BitAchievement
	{
		var a:BitAchievement = new BitAchievement(name);

		/*
		var camcontrol = new FlxCamera();
		FlxG.cameras.add(camcontrol);
		camcontrol.bgColor.alpha = 0;
		a.cameras = [camcontrol];
		*/

		FlxG.state.add(a);

		a.play(duration, _ ->
		{
			FlxG.state.remove(a);
			a.destroy();
			a = null;
			//camcontrol.destroy();
		});

		return a;
	}
	
	public static function unlockAchievement(name:String):Void {
		FlxG.log.add('Completed achievement "' + name +'"');
		achievementsMap.set(name, true);
		popup(name);
		FlxG.sound.play(Paths.sound('unlock' + FlxG.random.int(1,2),'shared'), 0.7);
	}

	public static function isAchievementUnlocked(name:String) {
		if(achievementsMap.exists(name) && achievementsMap.get(name)) {
			return true;
		}
		return false;
	}
}

class MedalSaves{
	public static function loadAchievements():Void {
		if(FlxG.save.data != null) {
			if(FlxG.save.data.achievementsMap != null) {
				BitAchievement.achievementsMap = FlxG.save.data.achievementsMap;
			}
			if(FlxG.save.data.achievementsUnlocked != null) {
				FlxG.log.add("Trying to load stuff");
				var savedStuff:Array<String> = FlxG.save.data.achievementsUnlocked;
				for (i in 0...savedStuff.length) {
					BitAchievement.achievementsMap.set(savedStuff[i], true);
				}
			}
		}
	}
}

class BitAttachedAchievement extends FlxSprite {
	public var sprTracker:FlxSprite;
	private var tag:String;
	public function new(x:Float = 0, y:Float = 0, name:String) {
		super(x, y);

		changeAchievement(name);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function changeAchievement(tag:String) {
		this.tag = tag;
		reloadAchievementImage();
	}

	public function reloadAchievementImage() {
		if(Achievements.isAchievementUnlocked(tag)) {
			frames = Paths.getSparrowAtlas('8bit/them', "shared");
			antialiasing = false;
			animation.addByPreifx('icon', [getAchievementIndex(tag)], 0, false, false);
			animation.play('icon');
		} else {
			loadGraphic(Paths.image('8bit/LOCK', "shared"));
		}
		scale.set(0.7, 0.7);
		updateHitbox();
	}
	
	public function getAchievementIndex(string:String):String {
		switch (string) {
			case "ggwp":
				return "GGWP";
			default:
				return "sus";
		}
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}
//special thanks to lucky (creator of funkin android) for helpin me on this! -Zack