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

	public static function popup(name:String, duration:Float = 0.5):Achievements
	{
		var a:Achievements = new Achievements(name);

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
}

class MedalSaves{
	//public var Savecrap:Array<Bool> = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];//20 bools.
	//nvm idfk.
	public static function initMedal()
	{
		if (FlxG.save.data.loaded == null){
			FlxG.save.data.GGWP = false;
			FlxG.save.data.Gamer = false;
			FlxG.save.data.BluSpy = false;
			FlxG.save.data.TOUHOU = false;
			FlxG.save.data.ProPlayer = false;
			FlxG.save.data.ECHO = false;
			FlxG.save.data.GoodEnding = false;
			FlxG.save.data.BadEnding = false;
			FlxG.save.data.Firewall = false;
			FlxG.save.data.DUNABD = false;
			FlxG.save.data.CDBZ = false;
			FlxG.save.data.Spike = false;
			FlxG.save.data.Coin = false;
			FlxG.save.data.TWTMF = false;
			FlxG.save.data.NewWorld = false;
			FlxG.save.data.WildWest = false;
			FlxG.save.data.Sus = false;
			FlxG.save.data.BigSus = false;
			FlxG.save.data.Perfect = false;
			FlxG.save.data.loaded = true;
		}
		if (FlxG.save.data.NewWorld)
			FlxG.save.data.NewWorld = false;
	}
}

class AttachedAchievement extends FlxSprite {
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
	
	public function getAchievementIndex(string:String) {
		switch (string) {
			
		}
	}

	override function update(elapsed:Float) {
		if (sprTracker != null)
			setPosition(sprTracker.x - 130, sprTracker.y + 25);

		super.update(elapsed);
	}
}
//special thanks to lucky (creator of funkin android) for helpin me on this! -Zack