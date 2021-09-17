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

class FreeplayState extends MusicBeatState
{
	public static var songs:Array<SongMetadata> = [];
	var daSongs:Array<String> = ["BOOTED UP","DISCO","INTOXIC8","QUICKDRAW","EXERROR"];
	var daBg:FlxSprite;
	var daFlicker:FlxSprite;
	var daBf:FlxSprite;
	var daBfFlicker:FlxSprite;
	var curMode:String = "";
	var curSong:String = "intoxicate";

	var selector:FlxText;
	public static var curSelected:Int = 1;
	public static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var diffCalcText:FlxText;
	var previewtext:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var combo:String = '';
	var ThefuckingSongSpr:FlxSprite;

	private var grpSongs:FlxTypedGroup<FlxSprite>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	public static var openedPreview = false;

	public static var songData:Map<String,Array<SwagSong>> = [];

	public static function loadDiff(diff:Int, format:String, name:String, array:Array<SwagSong>)
	{
		try 
		{
			array.push(Song.loadFromJson(Highscore.formatSong(format, diff), name));
		}
		catch(ex)
		{
			// do nada
		}
	}

	override function create()
	{

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end
		persistentUpdate = true;
		curSelected = 1;

		// LOAD MUSIC

		// LOAD CHARACTERS

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

		daBg = new FlxSprite(0,0).loadGraphic(Paths.image("8bit/game_room", "shared"));
		daBg.scale.set(2,2);
		
		daBg.antialiasing = true;
		add(daBg);
		daFlicker = new FlxSprite(0,0).loadGraphic(Paths.image("8bit/game_room_blu", "shared"));
		daFlicker.scale.set(2,2);
		daFlicker.antialiasing = true;
		add(daFlicker);
		daFlicker.visible = false;
	
		daBf = new FlxSprite(0,100).loadGraphic(Paths.image("8bit/bf","shared"));
		daBf.scale.set(2,2);
		daBf.antialiasing = true;
		add(daBf);
		FlxTween.tween(daBf, {y: 0}, 0.6);
	
		daBfFlicker = new FlxSprite(0,0).loadGraphic(Paths.image("8bit/bf","shared"));
		daBfFlicker.scale.set(2,2);
		daBfFlicker.antialiasing = true;
		add(daBfFlicker);
		daBfFlicker.visible = false;

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 105, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		diffCalcText = new FlxText(scoreText.x, scoreText.y + 66, 0, "", 24);
		diffCalcText.font = scoreText.font;
		add(diffCalcText);

		previewtext = new FlxText(scoreText.x, scoreText.y + 94, 0, "" + (KeyBinds.gamepad ? "X" : "SPACE") + " to preview", 24);
		previewtext.font = scoreText.font;
		//add(previewtext);

		comboText = new FlxText(diffText.x + 100, diffText.y, 0, "", 24);
		comboText.font = diffText.font;
		add(comboText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		#if (android || ios)
		addVirtualPad(FULL, A_B);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.save.data.lessUpdate)
			super.update(elapsed/2);
		else
			super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;
		comboText.text = combo + '\n';

		if (FlxG.sound.music.volume > 0.8)
		{
			FlxG.sound.music.volume -= 0.5 * FlxG.elapsed;
		}

		var upP = FlxG.keys.justPressed.UP;
		var downP = FlxG.keys.justPressed.DOWN;
		var accepted = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{

			if (gamepad.justPressed.DPAD_UP)
			{
				changeSelection(-1);
			}
			if (gamepad.justPressed.DPAD_DOWN)
			{
				changeSelection(1);
			}
			if (gamepad.justPressed.DPAD_LEFT)
			{
				changeDiff(-1);
			}
			if (gamepad.justPressed.DPAD_RIGHT)
			{
				changeDiff(1);
			}

			//if (gamepad.justPressed.X && !openedPreview)
				//openSubState(new DiffOverview());
		}

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		//if (FlxG.keys.justPressed.SPACE && !openedPreview)
			//openSubState(new DiffOverview());

		if (FlxG.keys.justPressed.LEFT)
			changeDiff(-1);
		if (FlxG.keys.justPressed.RIGHT)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		ThefuckingSongSpr.animation.play(Std.string(curSelected));

		if (accepted)
		{
			// adjusting the song name to be compatible

			PlayState.SONG = Song.loadFromJson(curSong + curMode, curSong);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.storyWeek = 1;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		switch (curDifficulty){
			case 0:
				curMode = "-easy";
			case 1:
				curMode = "";
			case 2:
				curMode = "-hard";
		}
		
		#if !switch
		intendedScore = Highscore.getScore(curSong, curDifficulty);
		combo = Highscore.getCombo(curSong, curDifficulty);
		#end
		diffCalcText.text = 'RATING: ' + DiffCalc.CalculateDiff(Song.loadFromJson(curSong + curMode, curSong));
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected == 3)
			curSelected = 1;
		if (curSelected == 0)
			curSelected = 1;

		switch(curSelected){
			case 1:
				curSong = "disco";
			case 2:
				curSong = "intoxicate";
		}

		#if !switch
		intendedScore = Highscore.getScore(curSong, curDifficulty);
		combo = Highscore.getCombo(curSong, curDifficulty);
		// lerpScore = 0;
		#end

		diffCalcText.text = 'RATING: ' + DiffCalc.CalculateDiff(Song.loadFromJson(curSong + curMode, curSong));
		
		#if PRELOAD_ALL
			FlxG.sound.playMusic(Paths.inst(curSong), 0);
		#end

		var hmm;
			try
			{
				hmm = Song.loadFromJson(curSong + curMode, curSong);
				if (hmm != null)
					Conductor.changeBPM(hmm.bpm);
			}
			catch(ex)
			{}

		if (openedPreview)
		{
			closeSubState();
			openSubState(new DiffOverview());
		}

		var bullShit:Int = 0;

	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	#if sys
	public var sm:SMFile;
	public var path:String;
	#end
	public var songCharacter:String = "";

	#if sys
	public function new(song:String, week:Int, songCharacter:String, ?sm:SMFile = null, ?path:String = "")
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.sm = sm;
		this.path = path;
	}
	#else
	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
	#end
}
