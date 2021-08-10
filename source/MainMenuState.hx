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
	var camFollow:FlxObject;
	public static var finishedFunnyMove:Bool = false;
	public var triggered:Bool = false;

	var randomBg:Array<String> = ['8bit','red_eye','v8bit','SAND'];
	var spike:FlxSprite;
	var stupidItems:MenuThings;

	override function create()
	{
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
		var madvirus:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('8bit/MVAT','shared'));
		madvirus.scrollFactor.x = 0;
		madvirus.scrollFactor.y = 0.10;
		madvirus.setGraphicSize(Std.int(madvirus.width * 2));
		madvirus.updateHitbox();
		madvirus.screenCenter();
		madvirus.antialiasing = false;

		add(madvirus);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// magenta.scrollFactor.set();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();
		#if (android || ios)
		addVirtualPad(UP_DOWN, A_B);
		#end
		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (FlxG.mouse.overlaps(spike) && FlxG.mouse.justPressed && ASS == 'SAND')
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
				stupidItems.play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new StoryMenuState());
			}

			if (FlxG.mouse.overlaps(stupidItems.Freeplay) && FlxG.mouse.justPressed && FlxG.save.data.storyBeated){
				stupidItems.play(2, 'clicked');
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
				//selectedSomethin = true;
				//FlxG.mouse.visible = false;
				//FlxG.switchState(new OptionsMenu());
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
