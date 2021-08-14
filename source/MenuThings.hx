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
import flixel.util.FlxColor;
import Paths;

using StringTools;

class TapeStuff extends FlxSpriteGroup{
	//varrrsss
	public var pathTwo:String = "";
	public var leftkey:FlxSprite;
	public var menu:FlxSprite;
	public var playkey:FlxSprite;
	public var rightkey:FlxSprite;
	public var sp:FlxSprite;

	//functionsss
	public function new(x:Float,y:Float){

		super(x,y);

		//pathTwo = Paths.getSparrowAtlas('8bit/tap_them','shared');

		leftkey = new FlxSprite(x,y);
		leftkey.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		leftkey.scale.set(2,2);
		leftkey.animation.addByPrefix("selected","left0",24,false);
		leftkey.animation.addByPrefix("unselected","unleft0",24,false);
		leftkey.animation.addByPrefix("clicked","tapleft0",24,false);
		leftkey.animation.play("unselected");
		leftkey.antialiasing = false;
		add(leftkey);

		menu = new FlxSprite(x,y);
		menu.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		menu.scale.set(2,2);
		menu.animation.addByPrefix("selected","menu0",24,false);
		menu.animation.addByPrefix("unselected","unmenu0",24,false);
		menu.animation.addByPrefix("clicked","tapmenu0",24,false);
		menu.animation.play("unselected");
		menu.antialiasing = false;
		add(menu);

		playkey = new FlxSprite(x,y);
		playkey.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		playkey.scale.set(2,2);
		playkey.animation.addByPrefix("selected","paly0",24,false);
		playkey.animation.addByPrefix("unselected","unplay0",24,false);
		playkey.animation.addByPrefix("clicked","tapplay0",24,false);
		playkey.animation.play("unselected");
		playkey.antialiasing = false;
		add(playkey);

		rightkey = new FlxSprite(x,y);
		rightkey.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		rightkey.scale.set(2,2);
		rightkey.animation.addByPrefix("selected","right0",24,false);
		rightkey.animation.addByPrefix("unselected","unright0",24,false);
		rightkey.animation.addByPrefix("clicked","tapright0",24,false);
		rightkey.animation.play("selected");
		rightkey.antialiasing = false;
		add(rightkey);

		sp = new FlxSprite(x,y);
		sp.frames = Paths.getSparrowAtlas('8bit/tap_them','shared');;
		sp.scale.set(2,2);
		sp.animation.addByPrefix("selected","sp0",24,false);
		sp.animation.addByPrefix("unselected","unsp0",24,false);
		sp.animation.addByPrefix("clicked","tapsp0",24,false);
		sp.animation.play("unselected");
		sp.antialiasing = false;
		add(sp);
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