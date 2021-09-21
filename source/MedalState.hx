package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import MedalSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import BitData;
import MedalSprite;
#if windows
import Discord.DiscordClient;
#end

class MedalState extends MusicBeatState
{
	private var grptext:FlxTypedGroup<Alphabet>;

	private var medalGroup:FlxTypedGroup<MedalSprite>;

	var curSelected:Int = 0;

	var menuItems:Array<String> = [];

	var notice:FlxText;
	//var data:BitData = new BitData();

	override public function create() 
	{
		#if (android || ios || desktop)
		menuItems = ['GGWP',
			'Gamer',
			'Blue Spy',
			'TOUHOU Bit',
			'Pro Player',
			'ECHO',
			'Good Ending',
			'Bad Ending',
			'Firewall',
			'DUNABD',
			'CDBZ',
			'Spike',
			'One Coin',
			'TWTMF',
			'New World',
			'Wild West',
			'Sus',
			'Big Sus',
			'The Perfect Player'
		];
		#end
		#if windows
		if (FlxG.save.data.discordPresence)
			DiscordClient.changePresence("Checking achievements.", null);
		#end
		FlxG.sound.playMusic(Paths.music('trophyRoom','shared'));
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = FlxColor.fromRGB(82, 79, 78);
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grptext = new FlxTypedGroup<Alphabet>();
		add(grptext);

		medalGroup = new FlxTypedGroup<MedalSprite>();
		add(medalGroup);

		for (i in 0...menuItems.length)
		{ 
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grptext.add(controlLabel);

			var med = new MedalSprite(controlLabel.x + controlLabel.width + 10, controlLabel.y - 20, menuItems[i]);
			medalGroup.add(med);
			add(med);
			//FlxG.save.data

			switch (menuItems[i]){
				case 'The Perfect Player':
					med.changeShit(FlxG.save.data.Perfect);
				case 'Wild West':
					med.changeShit(FlxG.save.data.WildWest);
				case 'New World':
					med.changeShit(FlxG.save.data.NewWorld);
				case 'TWTMF':
					med.changeShit(FlxG.save.data.TWTMF);
				case 'One Coin':
					med.changeShit(FlxG.save.data.Coin);
				case 'Spike':
					med.changeShit(FlxG.save.data.Spike);
				case 'CDBZ':
					med.changeShit(FlxG.save.data.CDBZ);
				case 'DUNABD':
					med.changeShit(FlxG.save.data.DUNABD);
				case 'Firewall':
					med.changeShit(FlxG.save.data.Firewall);
				case 'Bad Ending':
					med.changeShit(FlxG.save.data.BadEnding);
				case 'Good Ending':
					med.changeShit(FlxG.save.data.GoodEnding);
				case 'ECHO':
					med.changeShit(FlxG.save.data.ECHO);
				case 'Pro Player':
					med.changeShit(FlxG.save.data.ProPlayer);
				case 'TOUHOU Bit':
					med.changeShit(FlxG.save.data.TOUHOU);
				case 'Blue Spy':
					med.changeShit(FlxG.save.data.BluSpy);
				case 'Gamer':
					med.changeShit(FlxG.save.data.Gamer);
				case 'GGWP':
					med.changeShit(FlxG.save.data.GGWP);
				case 'Sus':
					med.changeShit(FlxG.save.data.Sus);
				case 'Big Sus':
					med.changeShit(FlxG.save.data.BigSus);
			}

			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		var noticebg = new FlxSprite(0, FlxG.height - 56).makeGraphic(FlxG.width, 60, FlxColor.BLACK);
		noticebg.alpha = 0.25;

		notice = new FlxText(0, 0, 0, "", 24);

		notice.screenCenter();
		notice.y = FlxG.height - 56;
		notice.alpha = 0.6;
		add(noticebg);
		add(notice);
		#if (android || ios)
		addVirtualPad(FULL, A_B);
		#end
		changeSelection();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.save.data.lessUpdate)
			super.update(elapsed/2);
		else
			super.update(elapsed);

		for (i in 0...medalGroup.length)
		{
			medalGroup.members[i].x = grptext.members[i].x + grptext.members[i].width + 10;
			medalGroup.members[i].y = grptext.members[i].y - 20;
		}
		var daSelected:String = menuItems[curSelected];

		switch (daSelected){
			case 'One Coin':
				switch (FlxG.save.data.Coin){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Only One Coin!\nComplete story mode with no deaths.\n';
				}
			case 'Spike':
				switch (FlxG.save.data.Spike){
					case false | null:
						notice.text = 'Spike.\n';
					case true:
						notice.text = 'Spike!\nFind the hidden spike.\n';
				}
			case 'CDBZ':
				switch (FlxG.save.data.CDBZ){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = "CDBZ! (Can't divide by zero.)\nFC The final chapter.\n";
				}
			case 'Bad Ending':
				switch (FlxG.save.data.BadEnding){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Bad Ending!\nGet the bad ending.\n';
				}
			case 'Good Ending':
				switch (FlxG.save.data.GoodEnding){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Good Ending!\nGet the good ending.\n';
				}
			case 'DUNABD':
				switch (FlxG.save.data.DUNABD){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'DUNABD! (Do you need a backup, dumbfudge?)\nDie 5 times in easy mode.\n';
				}
			case 'Firewall':
				switch (FlxG.save.data.Firewall){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Firewall!\nFC The 2nd chapter.\n';
				}
			case 'ECHO':
				switch (FlxG.save.data.ECHO){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'ECHO!\nDiscover and defeat DarkBit.\n';
				}
			case 'Pro Player':
				switch (FlxG.save.data.ProPlayer){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Pro Player!\nEnter the magical cheat code passed down from the ancestors.\n';
				}
			case 'TOUHOU Bit':
				switch (FlxG.save.data.TOUHOU){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'TOUHOU Bit!\nMiss more than 100 times and win.\n';
				}
			case 'Blue Spy':
				switch (FlxG.save.data.BluSpy){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Blue Spy!\nFC Chapter one.\n';
				}
			case 'Gamer':
				switch (FlxG.save.data.Gamer){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'Gamer!\nComplete story mode.\n';
				}
			case 'GGWP':
				switch (FlxG.save.data.GGWP){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'GOOD GAME WELL PLAY!\nComplete one song.\n';
				}
			case 'Sus':
				switch (FlxG.save.data.Sus){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'SUS!\nPress F 69 times\n';
				}
			case 'Big Sus':
				switch (FlxG.save.data.BigSus){
					case false | null:
						notice.text = '???';
					case true:
						notice.text = 'BIG SUS!\nPress F 420 times\n';
						//bruuuuuu!
				}
		}

		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
			FlxG.save.flush();
			FlxG.switchState(new OptionsMenu());
		}

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grptext.length - 1;
		if (curSelected >= grptext.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grptext.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	// code from here https://stackoverflow.com/questions/23689001/how-to-reliably-format-a-floating-point-number-to-a-specified-number-of-decimal
	public static function floatToStringPrecision(n:Float, prec:Int){
		n = Math.round(n * Math.pow(10, prec));
		var str = ''+n;
		var len = str.length;
		if(len <= prec){
		  while(len < prec){
			str = '0'+str;
			len++;
		  }
		  return Std.parseFloat('0.'+str);
		}
		else{
		  return Std.parseFloat(str.substr(0, str.length-prec) + '.'+str.substr(str.length-prec));
		}//what.
	  }
}