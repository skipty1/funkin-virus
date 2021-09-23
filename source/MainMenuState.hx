package;

//import MenuThings;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import FlxGameJolt;
import flixel.math.FlxRect;
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
	public static var comingBack = false;

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
	public var cloud:FlxSprite;
	public var Rainbow:FlxSprite;
	public var Story:FlxSprite;
	public var Xshit:Float = 410;
	public var Yshit:Float = 90;
	public var hitboxStory:FlxObject;
	public var hitboxFreeplay:FlxObject;
	public var hitboxAchievement:FlxObject;
	public var hitboxSettings:FlxObject;
	public var hitboxMusic:FlxObject;
	public var hitboxCloud:FlxObject;

	override function create()
	{
		if (comingBack){
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			comingBack = false;
		}
		FlxG.mouse.visible = true;

		FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 0.5);
		FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 2);

		FlxG.mouse.visible = true;

		#if windows
		if (FlxG.save.data.discordPresence)
			DiscordClient.changePresence("In the Main Menu", null);
		#end

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
			var sentry:FlxSprite = new FlxSprite(-50,500).loadGraphic(Paths.image('8bit/MINI_SENTRY','shared'));
			sentry.scale.set(2,2);
			sentry.updateHitbox();
			sentry.antialiasing = false;
			add(sentry);
			spike = new FlxSprite(-50,500).loadGraphic(Paths.image('8bit/SPIKE','shared'));
			spike.scale.set(2,2);
			spike.updateHitbox();
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

		Install = new FlxSprite(Achievement.x - 50, 660 + 70);
		Install.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Install.animation.addByPrefix('selected','install0',24,false);
		Install.animation.addByPrefix('unselected','uninstall0',24,false);
		Install.scale.set(2,2);
		Install.antialiasing = false;
		Install.animation.play('unselected');
		add(Install);

		Music = new FlxSprite(Install.x - 50, 730);
		Music.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Music.animation.addByPrefix('selected','MUSIC0',24,false);
		Music.animation.addByPrefix('unselected','UNMUSIC0',24,false);
		Music.scale.set(2,2);
		Music.antialiasing = false;
		Music.animation.play('unselected');
		add(Music);
		Music.color = FlxColor.fromHSL(Music.color.hue, Music.color.saturation, 0.1, 1);

		cloud = new FlxSprite(Music.x - 350, 730);
		cloud.frames = Paths.getSparrowAtlas('8bit/clouds','shared');
		cloud.animation.addByPrefix('selected','cloud',24,false);
		cloud.animation.addByPrefix('unselected','uncloud0',24,false);
		cloud.scale.set(2,2);
		cloud.antialiasing = false;
		cloud.animation.play('unselected');
		add(cloud);

		Bestplayer = new FlxSprite(-18, 204);
		Bestplayer.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Bestplayer.animation.addByPrefix('mmmhi','best player0',24,false);
		Bestplayer.scale.set(2,2);
		Bestplayer.antialiasing = false;
		Bestplayer.animation.play('mmmhi');
		add(Bestplayer);
		if (!FlxG.save.data.Spike)
			Bestplayer.visible = false;

		// 1100 - moreX + 70,320 - Yshit - 20
		Freeplay = new FlxSprite(38, 44);
		Freeplay.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Freeplay.animation.addByPrefix('selected','freepaly0',24,false);
		Freeplay.animation.addByPrefix('unselected','unfreeplay0',24,false);
		Freeplay.animation.addByPrefix('clicked','tapfreeplay0',24,false);
		Freeplay.antialiasing = false;
		Freeplay.animation.play('unselected');
		// set scale after anim?
		Freeplay.scale.set(2,2);
		Freeplay.updateHitbox();
		add(Freeplay);
		if (FlxG.save.data.discoBeated)
			Freeplay.color = FlxColor.fromHSL(Freeplay.color.hue, Freeplay.color.saturation, 1, 1);
		else
			Freeplay.color = FlxColor.fromHSL(Freeplay.color.hue, Freeplay.color.saturation, 0.3, 1);

		Gold = new FlxSprite(440, 204);
		Gold.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Gold.animation.addByPrefix('mmmhi','gold0',24,false);
		Gold.scale.set(2,2);
		Gold.antialiasing = false;
		Gold.animation.play('mmmhi');
		add(Gold);
		if (!FlxG.save.data.storyBeatedNom)
			Gold.visible = false;

		Iron = new FlxSprite(270, 204);
		Iron.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Iron.animation.addByPrefix('mmmhi','iron',24,false);
		Iron.scale.set(2,2);
		Iron.antialiasing = false;
		Iron.animation.play('mmmhi');
		add(Iron);
		if (!FlxG.save.data.storyBeatedEz)
			Iron.visible = false;

		Rainbow = new FlxSprite(Bestplayer.x - 50, 204);
		Rainbow.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Rainbow.animation.addByPrefix('mmmhi','rainbow',24,false);
		Rainbow.scale.set(2,2);
		Rainbow.antialiasing = false;
		Rainbow.animation.play('mmmhi');
		add(Rainbow);
		if (!FlxG.save.data.storyBeatedHard)
			Rainbow.visible = false;

		Story = new FlxSprite(730 - Xshit, 225);
		Story.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');
		Story.animation.addByPrefix('selected','story0',24,false);
		Story.animation.addByPrefix('unselected','unstory0',24,false);
		Story.animation.addByPrefix('clicked','tapstory0',24,false);
		Story.scale.set(2,2);
		Story.antialiasing = false;
		Story.animation.play('unselected');
		add(Story);

		hitboxStory = new FlxObject(615, 290, 214, 88);
		add(hitboxStory);

		hitboxStory.visible = false;

		hitboxFreeplay = new FlxObject(1000, 290, 214, 88);
		add(hitboxFreeplay);

		hitboxFreeplay.visible = false;

		hitboxMusic = new FlxObject(925, 630, 65, 70);
		add(hitboxMusic);
		
		hitboxCloud = new FlxObject(785, 630, 70,70);
		add(hitboxCloud);
		hitboxCloud.visible = false;

		hitboxMusic.visible = false;

		hitboxSettings = new FlxObject(1019, 611, 100, 100);
		add(hitboxSettings);

		hitboxMusic.visible = false;

		hitboxAchievement = new FlxObject(1175, 625, 80, 80);
		add(hitboxAchievement);

		hitboxAchievement.visible = false;

		// magenta.scrollFactor.set();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		firstStart = false;

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FUNKIN VIRUS - " + kadeEngineVer + " Kade Engine" : " FUNKIN VIRUS - PRIVATE DEMO"), 12);
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
	var onDiffic:Bool = false;
	var difficEz:FlxSprite;
	var difficNor:FlxSprite;
	var difficHar:FlxSprite;
	var black:FlxSprite;
	var curDiff:Int = 0;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			//if (FlxG.keys.justPressed.A && FlxGameJolt._initialized)
				//FlxGameJolt.setData("BetaTester?", "true", false);

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

			if (FlxG.mouse.overlaps(hitboxCloud)){
				playAnimation(5, "selected");
			}else{
				playAnimation(5, "unselected");
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
				openDifficSelect();
				//FlxG.switchState(new TitleState());
			}
			if (FlxG.mouse.overlaps(hitboxCloud) && FlxG.mouse.justPressed){
				FlxG.mouse.visible = false;
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.switchState(new GamejoltState());
			}

			if (FlxG.mouse.overlaps(hitboxFreeplay) && FlxG.mouse.justPressed){
				playAnimation(2, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new NewFreeplay());
			}

			if (FlxG.mouse.overlaps(hitboxSettings) && FlxG.mouse.justPressed){
				//play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new OptionsMenu());
			}

			/*if (FlxG.mouse.overlaps(hitboxMusic) && FlxG.mouse.justPressed){
				//play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new TapeState());
			}*/

			if (FlxG.mouse.overlaps(hitboxAchievement) && FlxG.mouse.justPressed){
				//play(0, 'clicked');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.switchState(new MedalState());
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}
		}
		if (onDiffic){
			if (controls.UP_P)
				openDifficSelect(1);
			if (controls.DOWN_P)
				openDifficSelect(-1);

			if (controls.ACCEPT){
				FlxG.sound.play(Paths.sound('confirmMenu'));
				openDifficSelect(-99, false, true);
			}
			if (controls.BACK){
				FlxG.sound.play(Paths.sound('cancelMenu'));
				openDifficSelect(-99, true);
			}
			if (difficEz.animation.curAnim.name == "tapped" && difficEz.animation.curAnim.finished)
				difficEz.animation.play("selected");
			if (difficNor.animation.curAnim.name == "tapped" && difficNor.animation.curAnim.finished)
				difficNor.animation.play("selected");
			if (difficHar.animation.curAnim.name == "tapped" && difficHar.animation.curAnim.finished)
				difficHar.animation.play("selected");
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
			case 5:
				cloud.animation.play(Anim);
			default:
				trace('No valid animation');
		}
	}
	function openDifficSelect(?huh:Int = -99, ?die:Bool = false, ?play:Bool = false){
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		if (huh == -99){
			black = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 10, FlxG.height * 10, FlxColor.BLACK);
			black.scrollFactor.set();
			black.alpha = 0.4;
			add(black);
			onDiffic = true;
			difficEz = new FlxSprite(350, 250);
			difficEz.frames = Paths.getSparrowAtlas("8bit/Difficulty_selection","shared");
			difficEz.animation.addByPrefix("selected","EZ",24,false);
			difficEz.animation.addByPrefix("unselected","unEZ");
			difficEz.animation.addByPrefix("tapped","tap EZ");
			difficEz.animation.play("unselected");
			difficEz.scale.set(2,2);
			add(difficEz);
			difficNor = new FlxSprite(350,250);
			difficNor.frames = Paths.getSparrowAtlas("8bit/Difficulty_selection","shared");
			difficNor.animation.addByPrefix("selected","NOM",24,false);
			difficNor.animation.addByPrefix("unselected","unNOM");
			difficNor.animation.addByPrefix("tapped","tap NOM");
			difficNor.animation.play("unselected");
			difficNor.scale.set(2,2);
			add(difficNor);
			difficHar = new FlxSprite(350,250);
			difficHar.frames = Paths.getSparrowAtlas("8bit/Difficulty_selection","shared");
			difficHar.animation.addByPrefix("selected","HARD",24,false);
			difficHar.animation.addByPrefix("unselected","unHARD");
			difficHar.animation.addByPrefix("tapped","tap HARD");
			difficHar.animation.play("unselected");
			difficHar.scale.set(2,2);
			add(difficHar);
			difficHar.antialiasing = false;
			difficNor.antialiasing = false;
			difficEz.antialiasing = false;
		}
		if (die){
			remove(black);
			remove(difficEz);
			remove(difficHar);
			remove(difficNor);
			onDiffic = false;
			selectedSomethin = false;
			FlxG.mouse.visible = true;
		}
		if (huh != -99){
			if (huh == 0)
				curDiff = huh;
			else
				curDiff += huh;
			if (curDiff < 0)
				curDiff = 2;
			if (curDiff > 2)
				curDiff = 0;
		}
		switch (curDiff){
			case 0:
				difficEz.animation.play("tapped", true);
				difficNor.animation.play("unselected");
				difficHar.animation.play("unselected");
			case 1:
				difficNor.animation.play("tapped", true);
				difficEz.animation.play("unselected");
				difficHar.animation.play("unselected");
			case 2:
				difficHar.animation.play("tapped", true);
				difficNor.animation.play("unselected");
				difficEz.animation.play("unselected");
		}
		if (play){
			PlayState.storyPlaylist = ["Disco"];
			PlayState.isStoryMode = true;
			PlayState.storyDifficulty = curDiff;
			var poop:String = Highscore.formatSong(PlayState.storyPlaylist[0], curDiff);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = 1;
			PlayState.campaignScore = 0;
			LoadingState.loadAndSwitchState(new PlayState(), true);
		}
	}
}