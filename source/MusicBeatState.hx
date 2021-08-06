package;

#if windows
import Discord.DiscordClient;
#end
import flixel.util.FlxColor;
import openfl.Lib;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.input.actions.FlxActionInput;
import ui.FlxVirtualPad;
import Achievements;
import flixel.*;
import flixel.tweens.FlxTween;
import flixel.util.*;
import flixel.text.FlxText;

class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var curDecimalBeat:Float = 0;
	private var controls(get, never):Controls;

	public var cameraStuff:FlxCamera;
	public var fpressed:Int = 0;
	public static var dontSpam:Bool = false;
	public static var endedSongs:Int = 0;
	public static var storyCompleted:Bool = false;
	public static var songEnded:Bool = false;
	public var upOne:Bool = false;
	public var upTwo:Bool = false;
	public var downOne:Bool = false;
	public var downTwo:Bool = false;
	public var rightOne:Bool = false;
	public var leftOne:Bool = false;
	public var rightTwo:Bool = false;
	public var leftTwo:Bool = false;
	public var oneB:Bool = false;
	public var oneA:Bool = false;
	public var twoB:Bool = false;
	public var twoA:Bool = false;
	public static var deaths:Int = 0;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	#if (android || ios)
	var _virtualpad:FlxVirtualPad;

	var trackedinputs:Array<FlxActionInput> = [];

	// adding virtualpad to state
	public function addVirtualPad(?DPad:FlxDPadMode, ?Action:FlxActionMode) {
		_virtualpad = new FlxVirtualPad(DPad, Action);
		_virtualpad.alpha = 0.75;
		add(_virtualpad);
		controls.setVirtualPad(_virtualpad, DPad, Action);
		trackedinputs = controls.trackedinputs;
		controls.trackedinputs = [];

		#if android
		controls.addAndroidBack();
		#end
	}
	
	override function destroy() {
		controls.removeFlxInput(trackedinputs);

		super.destroy();
	}
	#else
	public function addVirtualPad(?DPad, ?Action){};
	#end

	override function create()
	{
		cameraStuff = new FlxCamera();
		cameraStuff.bgColor.alpha = 0;
		FlxG.cameras.add(cameraStuff);

		TimingStruct.clearTimings();
		(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
	}


	var array:Array<FlxColor> = [
		FlxColor.fromRGB(148, 0, 211),
		FlxColor.fromRGB(75, 0, 130),
		FlxColor.fromRGB(0, 0, 255),
		FlxColor.fromRGB(0, 255, 0),
		FlxColor.fromRGB(255, 255, 0),
		FlxColor.fromRGB(255, 127, 0),
		FlxColor.fromRGB(255, 0 , 0)
	];

	var skippedFrames = 0;

	override function update(elapsed:Float)
	{
		//everyStep();
		var nextStep:Int = updateCurStep();

		if (nextStep >= 0)
		{
			if (nextStep > curStep)
			{
				for (i in curStep...nextStep)
				{
					curStep++;
					updateBeat();
					stepHit();
				}
			}
			else if (nextStep < curStep)
			{
				//Song reset?
				curStep = nextStep;
				updateBeat();
				stepHit();
			}
		}

		if (Conductor.songPosition < 0)
			curDecimalBeat = 0;
		else
		{
			if (TimingStruct.AllTimings.length > 1)
			{
				var data = TimingStruct.getTimingAtTimestamp(Conductor.songPosition);

				FlxG.watch.addQuick("Current Conductor Timing Seg", data.bpm);

				Conductor.crochet = ((60 / data.bpm) * 1000);

				var percent = (Conductor.songPosition - (data.startTime * 1000)) / (data.length * 1000);

				curDecimalBeat = data.startBeat + (((Conductor.songPosition/1000) - data.startTime) * (data.bpm / 60));
			}
			else
			{
				curDecimalBeat = (Conductor.songPosition / 1000) * (Conductor.bpm/60);
				Conductor.crochet = ((60 / Conductor.bpm) * 1000);
			}
		}

		if (FlxG.save.data.fpsRain && skippedFrames >= 6)
			{
				if (currentColor >= array.length)
					currentColor = 0;
				(cast (Lib.current.getChildAt(0), Main)).changeFPSColor(array[currentColor]);
				currentColor++;
				skippedFrames = 0;
			}
			else
				skippedFrames++;

		if ((cast (Lib.current.getChildAt(0), Main)).getFPSCap != FlxG.save.data.fpsCap && FlxG.save.data.fpsCap <= 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

		if (FlxG.save.data.lessUpdate)
			super.update(elapsed/2);
		else
			super.update(elapsed);

//shit for Achievements
		if (FlxG.keys.justPressed.F && !dontSpam)
			fpressed += 1;

		switch (fpressed){
			case 69:
				fpressed == 70;
				if (!dontSpam && !FlxG.save.data.Sus)
					medalPop('Sus');
			case 420:
				fpressed == 421;
				if (!dontSpam && !FlxG.save.data.BigSus)
					medalPop('Big Sus');
		}
		
		if (endedSongs == 1 && !dontSpam && !FlxG.save.data.GGWP)
			medalPop('GGWP');
		
		if (storyCompleted && !dontSpam && !FlxG.save.data.Gamer)
			medalPop('Gamer');
		
		if (!FlxG.save.data.ProPlayer){
		//CRAP FOR SECRET CODEEE
			if (FlxG.keys.justPressed.UP && !dontSpam && !upOne){
			upOne = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.UP && !dontSpam && !upOne)
				upOne = false;

		if (upOne && FlxG.keys.justPressed.UP && !dontSpam && upOne && !upTwo){
			upTwo = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.DOWN && !dontSpam && upTwo){
			upOne = false;
			upTwo = false;
			}
			if (FlxG.keys.justPressed.DOWN && !dontSpam && upTwo && !downOne){
			downOne = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.DOWN && !dontSpam && downOne){
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.DOWN && !dontSpam && downOne && !downTwo){
			downTwo = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.LEFT && downTwo && !downSpam){
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.LEFT && downTwo && !dontSpam && !leftOne){
			leftOne = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (!FlxG.keys.justPressed.RIGHT && leftOne && FlxG.keys.justPressed.ANY && !dontSpam){
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
		if (FlxG.keys.justPressed.RIGHT && leftOne && !dontSpam && !rightOne){
			rightOne = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.LEFT && !dontSpam && rightOne){
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.LEFT && !dontSpam && rightOne && !leftTwo){
			leftTwo = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !dontSpam && leftTwo && !FlxG.keys.justPressed.RIGHT){
			leftTwo = false;
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.RIGHT && leftTwo && !dontSpam && !rightTwo){
			rightTwo = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.B && !dontSpam && rightTwo){
			rightTwo = false;
			leftTwo = false;
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.B && !dontSpam && rightTwo && !oneB){
			oneB = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.A && !dontSpam && oneB){
			oneB = false;
			rightTwo = false;
			leftTwo = false;
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
		if (FlxG.keys.justPressed.A && !oneA && oneB && !dontSpam){
			oneA = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
					dontSpam = false;
				});
			}
		
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.B && oneA && !dontSpam){
			oneA = false;
			oneB = false;
			rightTwo = false;
			leftTwo = false;
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.B && !twoB && oneA && !dontSpam){
			twoB = true;
			dontSpam = true;
				new FlxTimer().start(0.5, function(tmr:FlxTimer){
				dontSpam = false;
				});
			}
			if (FlxG.keys.justPressed.ANY && !FlxG.keys.justPressed.A && twoB && !dontSpam){
			twoB = false;
			oneA = false;
			oneB = false;
			rightTwo = false;
			leftTwo = false;
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
			if (FlxG.keys.justPressed.A && twoB && !dontSpam && !FlxG.save.data.ProPlayer){
			medalPop('Pro Player');
			twoB = false;
			oneA = false;
			oneB = false;
			rightTwo = false;
			leftTwo = false;
			rightOne = false;
			leftOne = false;
			downTwo = false;
			downOne = false;
			upTwo = false;
			upOne = false;
			}
		}

		if (!FlxG.save.data.DUNABD && !dontSpam && deaths >= 5 && PlayState.isEasy)
			medalPop('DUNABD');

		if (!FlxG.save.data.CDBZ && !dontSpam && PlayState.misses == 0 && songEnded)
			medalPop('CDBZ');

		if (!FlxG.save.data.Coin && !dontSpam && deaths == 0 && storyCompleted)
			medalPop('One Coin');

	}

	private function updateBeat():Void
	{
		lastBeat = curBeat;
		curBeat = Math.floor(curStep / 4);
	}

	public static var currentColor = 0;

	private function updateCurStep():Int
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		return lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}
	
	public function fancyOpenURL(schmancy:String)
	{
		#if linux
		Sys.command('/usr/bin/xdg-open', [schmancy, "&"]);
		#else
		FlxG.openURL(schmancy);
		#end
	}

	public function medalPop(ass:String){
		//dontSpam = false;
		Achievements.popup(ass)
		.cameras = [cameraStuff];
		
		textPop(ass);
	}

	public function textPop(ass:String){
		dontSpam = true;
		FlxG.sound.play(Paths.sound('unlock' + FlxG.random.int(1,2),'shared'));
		var txt:FlxText = new FlxText(0, 0, 0, "", 48);
		txt.color = FlxColor.fromRGB(133, 256, 133);
		txt.alignment = CENTER;
		txt.y = FlxG.height - 125;
		txt.alpha = 0;
		txt.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK, 3);
		txt.cameras = [cameraStuff];
		add(txt);
		switch (ass){
			case 'Sus':
				txt.text = "SUS!\nPress F 69 times.\n";
				FlxG.save.data.Sus = true;
			case 'Big Sus':
				txt.text = "BIG SUS!\nPress F 420 times.\n";
				FlxG.save.data.BigSus = true;
			case 'GGWP':
				txt.text = "GOOD GAME WELL PLAY! (GGWP)\nComplete one song.\n";
				FlxG.save.data.GGWP = true;
			case 'Gamer':
				txt.text = "Gamer!\nComplete story mode.\n";
				FlxG.save.data.Gamer = true;
			case 'Blue Spy':
				txt.text = "BluSpy!\nFC Chapter 1.\n";
				FlxG.save.data.BluSpy = true;
			case 'Pro Player':
				txt.text = "Pro Player!\nEnter the magical cheat code passed down from the ancestors.\n";
				FlxG.save.data.ProPlayer = true;
			case 'ECHO':
				txt.text = "ECHO!\nDiscover and defeat DarkBit.\n";
				FlxG.save.data.ECHO = true;
			case 'Firewall':
				txt.text = "Firewall!\nFC The 2nd chapter.\n";
				FlxG.save.data.Firewall = true;
			case 'DUNABD':
				txt.text = "DUNABD! (Do you need a backup dumbfudge?)\nDie 5 times in easy\n";
				FlxG.save.data.DUNABD = true;
			case 'CDBZ':
				txt.text = "CDBZ! (Cant divide by zero)\nFC The final chapter\n";
				FlxG.save.data.CDBZ = true;
			case 'Good Ending':
				txt.text = "Good Ending!\nGet the good ending.\n";
				FlxG.save.data.GoodEnding = true;
			case 'Bad Ending':
				txt.text = "Bad Ending!\nGet the bad ending.\n";
				FlxG.save.data.BadEnding = true;
			case 'Spike':
				txt.text = "Spike!\nFind the hidden spike.\n";
				FlxG.save.data.Spike = true;
			case 'One Coin':
				txt.text = "Only One Coin!\nComplete storymode with no deaths.\n";
				FlxG.save.data.Coin = true;
			case 'TWTMF':
				txt.text = "TWTMF! (The way to make friends.)\nFC The fourth chapter.\n";
				FlxG.save.data.TWTMF = true;
			default:
				txt.text = "how\n";
		}
		txt.screenCenter(X);
		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			txt.alpha += 0.1;
			if (txt.alpha < 0.9)
				tmr.reset(0.1);
		});
		new FlxTimer().start(6, function(tmr:FlxTimer){
			remove(txt);
			dontSpam = false;
		});
	}
}
//im not a good flxtext dude. :(