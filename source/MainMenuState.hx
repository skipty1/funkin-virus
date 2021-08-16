package;

//import MenuThings;
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

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	//var optionShit:Array<String> = ['freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var ASS:String = "";
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.6" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;

	public static var finishedFunnyMove:Bool = false;
	public var triggered:Bool = false;

	var randomBg:Array<String> = ['8bit','red_eye','v8bit','SAND'];
	var spike:FlxSprite;
	

	public var Achievement:FlxSprite;
	public var Music:FlxSprite;
	public var Bestplayer:FlxSprite;
	public var Freeplay:FlxSprite;
	public var Gold:FlxSprite;
	public var Install:FlxSprite;
	public var Iron:FlxSprite;
	public var Rainbow:FlxSprite;
	public var Story:FlxSprite;
	public var Xshit:Float = 410;
	public var Yshit:Float = 90;
	public var hitboxStory:FlxObject;
	public var hitboxFreeplay:FlxObject;
	public var hitboxAchievement:FlxObject;
	public var hitboxSettings:FlxObject;
	public var hitboxMusic:FlxObject;

	override function create()
	{
		#if (sys && desktop)
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		#if !cpp

		FlxG.save.bind('funkin', 'virus99');

		PlayerSettings.init();

		KadeEngineData.initSave();
		MedalSaves.initMedal();
		#end

		Highscore.load();

		FlxG.mouse.visible = true;

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		ASS = FlxG.random.getObject(randomBg);

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('8bit/' + ASS,'shared'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 2));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = false;
		add(bg);

		var moreX:Float = Xshit * 2;
		var moreY:Float = Yshit;

		if (ASS == 'SAND'){
			var sentry:FlxSprite = new FlxSprite(-100,600).loadGraphic(Paths.image('8bit/MINI_SENTRY','shared'));
			sentry.scale.set(2,2);
			sentry.antialiasing = false;
			add(sentry);
			spike = new FlxSprite(-100,600).loadGraphic(Paths.image('8bit/SPIKE','shared'));
			spike.scale.set(2,2);
			spike.antialiasing = false;
			add(spike);
		}


		var madvirus:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('8bit/MVAT','shared'));
		madvirus.scrollFactor.x = 0;
		madvirus.scrollFactor.y = 0.10;
		madvirus.setGraphicSize(Std.int(madvirus.width * 2));
		madvirus.updateHitbox();
		madvirus.screenCenter();
		madvirus.antialiasing = false;

		add(madvirus);
//1100
		Achievement = new FlxSprite(1000 - moreX + 400, 660 + 70);
		Achievement.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Achievement.animation.addByPrefix('selected','Achievement0',24,false);
		Achievement.animation.addByPrefix('unselected','unAchievement0',24,false);
		Achievement.scale.set(2,2);
		Achievement.antialiasing = false;
		Achievement.animation.play('unselected');
		add(Achievement);

		Music = new FlxSprite(1235 - moreX + 200,660 + 70);
		Music.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Music.animation.addByPrefix('selected','MUSIC0',24,false);
		Music.animation.addByPrefix('unselected','UNMUSIC0',24,false);
		Music.scale.set(2,2);
		Music.antialiasing = false;
		Music.animation.play('unselected');
		add(Music);

		Bestplayer = new FlxSprite(Xshit,Yshit);
		Bestplayer.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Bestplayer.animation.addByPrefix('mmmhi','best player0',24,false);
		Bestplayer.scale.set(2,2);
		Bestplayer.antialiasing = false;
		Bestplayer.animation.play('mmmhi');
		add(Bestplayer);
		if (FlxG.save.data.BestTrophy)
			Bestplayer.color = FlxColor.fromHSL(Bestplayer.color.hue, Bestplayer.color.saturation, 1, 1);
		else
			Bestplayer.color = FlxColor.fromHSL(Bestplayer.color.hue, Bestplayer.color.saturation, 0.7, 1);

		Freeplay = new FlxSprite(1100 - moreX + 90,320 - Yshit + 20);
		Freeplay.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Freeplay.animation.addByPrefix('selected','freepaly0',24,false);
		Freeplay.animation.addByPrefix('unselected','unfreeplay0',24,false);
		Freeplay.animation.addByPrefix('clicked','tapfreeplay0',24,false);
		Freeplay.scale.set(2,2);
		Freeplay.antialiasing = false;
		Freeplay.animation.play('unselected');
		add(Freeplay);
		if (FlxG.save.data.storyBeated)
			Freeplay.color = FlxColor.fromHSL(Freeplay.color.hue, Freeplay.color.saturation, 1, 1);
		else
			Freeplay.color = FlxColor.fromHSL(Freeplay.color.hue, Freeplay.color.saturation, 0.5, 1);

		Gold = new FlxSprite(1082 - Xshit,110);
		Gold.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Gold.animation.addByPrefix('mmmhi','gold0',24,false);
		Gold.scale.set(2,2);
		Gold.antialiasing = false;
		Gold.animation.play('mmmhi');
		add(Gold);
		if (FlxG.save.data.GoldTrophy)
			Gold.color = FlxColor.fromHSL(Gold.color.hue, Gold.color.saturation, 1, 1);
		else
			Gold.color = FlxColor.fromHSL(Gold.color.hue, Gold.color.saturation, 0.7, 1);

		Install = new FlxSprite(1025 - moreX + 300, 660 + 70);
		Install.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Install.animation.addByPrefix('selected','install0',24,false);
		Install.animation.addByPrefix('unselected','uninstall0',24,false);
		Install.scale.set(2,2);
		Install.antialiasing = false;
		Install.animation.play('unselected');
		add(Install);

		Iron = new FlxSprite(1000 - Xshit,110 - Yshit);
		Iron.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Iron.animation.addByPrefix('mmmhi','iron0',24,false);
		Iron.scale.set(2,2);
		Iron.antialiasing = false;
		Iron.animation.play('unselected');
		add(Iron);
		if (FlxG.save.data.IronTrophy)
			Iron.color = FlxColor.fromHSL(Iron.color.hue, Iron.color.saturation, 1, 1);
		else
			Iron.color = FlxColor.fromHSL(Iron.color.hue, Iron.color.saturation, 0.7, 1);

		Rainbow = new FlxSprite(1208 - Xshit,110 - Yshit);
		Rainbow.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Rainbow.animation.addByPrefix('mmmhi','rainbow0',24,false);
		Rainbow.scale.set(2,2);
		Rainbow.antialiasing = false;
		Rainbow.animation.play('unselected');
		add(Rainbow);
		if (FlxG.save.data.RainbowTrophy)
			Rainbow.color = FlxColor.fromHSL(Rainbow.color.hue, Rainbow.color.saturation, 1, 1);
		else
			Rainbow.color = FlxColor.fromHSL(Rainbow.color.hue, Rainbow.color.saturation, 0.7, 1);

		Story = new FlxSprite(730 - Xshit,320 - Yshit);
		Story.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Story.animation.addByPrefix('selected','story0',24,false);
		Story.animation.addByPrefix('unselected','unstory0',24,false);
		Story.animation.addByPrefix('clicked','tapstory0',24,false);
		Story.scale.set(2,2);
		Story.antialiasing = false;
		Story.animation.play('unselected');
		add(Story);

		hitboxStory = new FlxObject(730, 320, 214, 88);
		add(hitboxStory);

		hitboxStory.visible = false;

		hitboxFreeplay = new FlxObject(1100, 320, 214, 88);
		add(hitboxFreeplay);

		hitboxFreeplay.visible = false;

		hitboxMusic = new FlxObject(1235, 660, 136, 136);
		add(hitboxMusic);

		hitboxMusic.visible = false;

		hitboxSettings = new FlxObject(1025, 660, 136, 136);
		add(hitboxSettings);

		hitboxMusic.visible = false;

		hitboxAchievement = new FlxObject(1100, 660, 136, 136);
		add(hitboxAchievement);

		hitboxAchievement.visble = false;

		// magenta.scrollFactor.set();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		firstStart = false;

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FUNKIN VIRUS - " + kadeEngineVer + " Kade Engine" : "FUNKIN VIRUS - PRIVATE DEMO"), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		//FlxG.camera.fade(FlxColor.BLACK,0.7,true);

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (FlxG.keys.justPressed.X)
			trace('x' + FlxG.mouse.x);
		if (FlxG.keys.justPressed.Y)
			trace('y' + FlxG.mouse.y);
		if (FlxG.keys.justPressed.F)
			trace('x:' + FlxG.mouse.x + ' y:' + FlxG.mouse.y);

		if (!selectedSomethin)
		{
			if (spike != null && ASS == 'SAND'){
				if (FlxG.mouse.overlaps(spike) && FlxG.mouse.justPressed && ASS == 'SAND' && !FlxG.save.data.Spike)
					medalPop('Spike');
			}
//animation system for overlaps
			if (FlxG.mouse.overlaps(hitboxAchievement)){
				playAnimation(4, 'selected');
			}else{
				playAnimation(4, 'unselected');
			}

			if (FlxG.mouse.overlaps(hitboxMusic)){
				playAnimation(3, 'selected');
			}else{
				playAnimation(3, 'unselected');
			}

			if (FlxG.mouse.overlaps(hitboxFreeplay)){
				playAnimation(2, 'selected');
			}else{
				playAnimation(2, 'unselected');
			}

			if (FlxG.mouse.overlaps(hitboxSettings)){
				playAnimation(1, 'selected');
			}else{
				playAnimation(1, 'unselected');
			}

			if (FlxG.mouse.overlaps(hitboxStory)){
				playAnimation(0, 'selected');
			}else{
				playAnimation(0, 'unselected');
			}
//select system
			if (FlxG.mouse.overlaps(hitboxStory) && FlxG.mouse.justPressed){
				playAnimation(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new TitleState());
			}

			if (FlxG.mouse.overlaps(hitboxFreeplay) && FlxG.mouse.justPressed && FlxG.save.data.storyBeated){
				playAnimation(2, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new FreeplayState());
			}

			if (FlxG.mouse.overlaps(hitboxSettings) && FlxG.mouse.justPressed){
				//play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new OptionsMenu());
			}

			if (FlxG.mouse.overlaps(hitboxMusic) && FlxG.mouse.justPressed){
				//play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new TapeState());
			}

			if (FlxG.mouse.overlaps(hitboxAchievement) && FlxG.mouse.justPressed){
				//play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new MedalState());
			}

			if (controls.BACK)
			{
				
			}
		}

		if (FlxG.save.data.lessUpdate)
			super.update(elapsed/2);
		else
			super.update(elapsed);

	}
	public function playAnimation(ID:Int,Anim:String){
		switch (ID){
			case 0:
				Story.animation.play(Anim);
			case 1:
				Install.animation.play(Anim);
			case 2:
				Freeplay.animation.play(Anim);
			case 3:
				Music.animation.play(Anim);
			case 4:
				Achievement.animation.play(Anim);
			default:
				trace('No valid animation');
		}
	}
}
