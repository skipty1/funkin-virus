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
	var stupidItems:MenuThings;

	public var Achievement:FlxSprite;
	public var Music:FlxSprite;
	public var Bestplayer:FlxSprite;

	override function create()
	{
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
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
		if (ASS == 'SAND'){
			var sentry:FlxSprite = new FlxSprite(-100,600).loadGraphic(Paths.image('8bit/MINI_SENTRY'));
			sentry.scale.set(2,2);
			sentry.antialiasing = false;
			add(sentry);
			spike = new FlxSprite(-100,600).loadGraphic(Paths.image('8bit/SPIKE'));
			spike.scale.set(2,2);
			spike.antialiasing = false;
			add(spike);
		}
		stupidItems = new MenuThings(0,0);
		add(stupidItems);

		Achievement = new FlxSprite(Xshit, Yshit);
		Achievement.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Achievement.animation.addByPrefix('selected','Achievement0',24,false);
		Achievement.animation.addByPrefix('unselected','unAchievement0',24,false);
		Achievement.scale.set(2,2);
		Achievement.antialiasing = false;
		Achievement.animation.play('unselected');
		add(Achievement);

		Music = new FlxSprite(Xshit,Yshit);
		Music.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Music.animation.addByPrefix('selected','MUSIC',24,false);
		Music.animation.addByPrefix('unselected','UNMUSIC',24,false);
		Music.scale.set(2,2);
		Music.antialiasing = false;
		Music.animation.play('unselected');
		add(Music);

		Bestplayer = new FlxSprite(Xshit,Yshit);
		Bestplayer.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Bestplayer.animation.addByPrefix('mmmhi','best player',24,false);
		Bestplayer.scale.set(2,2);
		Bestplayer.antialiasing = false;
		Bestplayer.animation.play('mmmhi');
		add(Bestplayer);
		if (FlxG.save.data.BestTrophy)
			Bestplayer.color = FlxColor.fromHSL(Bestplayer.color.hue, Bestplayer.color.saturation, 1, 1);
		else
			Bestplayer.color = FlxColor.fromHSL(Bestplayer.color.hue, Bestplayer.color.saturation, 0.7, 1);



		var madvirus:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('8bit/MVAT','shared'));
		madvirus.scrollFactor.x = 0;
		madvirus.scrollFactor.y = 0.10;
		madvirus.setGraphicSize(Std.int(madvirus.width * 2));
		madvirus.updateHitbox();
		madvirus.screenCenter();
		madvirus.antialiasing = false;

		add(madvirus);

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

		FlxG.camera.fade(FlxColor.BLACK,0.7,true);

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
			if (FlxG.mouse.overlaps(spike) && FlxG.mouse.justPressed && ASS == 'SAND' && !FlxG.save.data.Spike)
				medalPop('Spike');
//animation system for overlaps
			if (FlxG.mouse.overlaps(stupidItems.Achievement)){
				stupidItems.playAnimation(4, 'selected');
			}else{
				stupidItems.playAnimation(4, 'unselected');
			}

			if (FlxG.mouse.overlaps(stupidItems.Music)){
				stupidItems.playAnimation(3, 'selected');
			}else{
				stupidItems.playAnimation(3, 'unselected');
			}

			if (FlxG.mouse.overlaps(stupidItems.Freeplay)){
				stupidItems.playAnimation(2, 'selected');
			}else{
				stupidItems.playAnimation(2, 'unselected');
			}

			if (FlxG.mouse.overlaps(stupidItems.Install)){
				stupidItems.playAnimation(1, 'selected');
			}else{
				stupidItems.playAnimation(1, 'unselected');
			}

			if (FlxG.mouse.overlaps(stupidItems.Story)){
				stupidItems.playAnimation(0, 'selected');
			}else{
				stupidItems.playAnimation(0, 'unselected');
			}
//select system
			if (FlxG.mouse.overlaps(stupidItems.Story) && FlxG.mouse.justPressed){
				stupidItems.playAnimation(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new TitleState());
			}

			if (FlxG.mouse.overlaps(stupidItems.Freeplay) && FlxG.mouse.justPressed && FlxG.save.data.storyBeated){
				stupidItems.playAnimation(2, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new FreeplayState());
			}

			if (FlxG.mouse.overlaps(stupidItems.Install) && FlxG.mouse.justPressed){
				//stupidItems.play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new OptionsMenu());
			}

			if (FlxG.mouse.overlaps(stupidItems.Music) && FlxG.mouse.justPressed){
				//stupidItems.play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new TapeState());
			}

			if (FlxG.mouse.overlaps(stupidItems.Achievement) && FlxG.mouse.justPressed){
				//stupidItems.play(0, 'clicked');
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
}
