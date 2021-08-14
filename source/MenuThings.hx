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

class MenuThings extends FlxSpriteGroup{
	//varrrsss




	public var Gold:FlxSprite;
	public var Install:FlxSprite;
	public var Iron:FlxSprite;
	public var Rainbow:FlxSprite;
	public var Story:FlxSprite;
	public var pathOne:String = "";
	public var Xshit:Float = 0;
	public var Yshit:Float = 0;
//functionsss
	public function new(offsetX:Float, offsetY:Float){
		super(offsetX, offsetY);
		Xshit = offsetX;
		Yshit = offsetY;
		//pathOne = Paths.getSparrowAtlas('8bit/MUNE','shared');





		Freeplay = new FlxSprite(Xshit,Yshit);
		Freeplay.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Freeplay.animation.addByPrefix('selected','freepaly',24,false);
		Freeplay.animation.addByPrefix('unselected','unfreeplay',24,false);
		Freeplay.animation.addByPrefix('clicked','tapfreeplay0',24,false);
		Freeplay.scale.set(2,2);
		Freeplay.antialiasing = false;
		Freeplay.animation.play('unselected');
		add(Freeplay);
		if (FlxG.save.data.storyBeated)
			Freeplay.color = FlxColor.fromHSL(Freeplay.color.hue, Freeplay.color.saturation, 1, 1);
		else
			Freeplay.color = FlxColor.fromHSL(Freeplay.color.hue, Freeplay.color.saturation, 0.7, 1);

		Gold = new FlxSprite(Xshit,Yshit);
		Gold.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Gold.animation.addByPrefix('mmmhi','gold0',24,false);
		Gold.scale.set(2,2);
		Gold.antialiasing = false;
		Gold.animation.play('mmmhi');
		add(Gold);
		if (FlxG.save.data.GoldTrophy)
			Gold.color = FlxColor.fromHSL(Gold.color.hue, Gold.color.saturation, 1, 1);
		else
			Gold.color = FlxColor.fromHSL(Gold.color.hue, Gold.color.saturation, 0.7, 1);

		Install = new FlxSprite(Xshit,Yshit);
		Install.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Install.animation.addByPrefix('selected','install0',24,false);
		Install.animation.addByPrefix('unselected','uninstall0',24,false);
		Install.scale.set(2,2);
		Install.antialiasing = false;
		Install.animation.play('unselected');
		add(Install);

		Iron = new FlxSprite(Xshit,Yshit);
		Iron.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Iron.animation.addByPrefix('mmmhi','iron0',24,false);
		Iron.scale.set(2,2);
		Iron.antialiasing = false;
		Iron.animation.play('unselected');
		add(Iron);
		if (FlxG.save.data.IronTrophy)
			Iron.color = FlxColor.fromHSL(Iron.color.hue, Iron.color.saturation, 1, 1);
		else
			Iron.color = FlxColor.fromHSL(Iron.color.hue, Iron.color.saturation, 0.7, 1);

		Rainbow = new FlxSprite(Xshit,Yshit);
		Rainbow.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Rainbow.animation.addByPrefix('mmmhi','rainbow0',24,false);
		Rainbow.scale.set(2,2);
		Rainbow.antialiasing = false;
		Rainbow.animation.play('unselected');
		add(Rainbow);
		if (FlxG.save.data.RainbowTrophy)
			Rainbow.color = FlxColor.fromHSL(Rainbow.color.hue, Rainbow.color.saturation, 1, 1);
		else
			Rainbow.color = FlxColor.fromHSL(Rainbow.color.hue, Rainbow.color.saturation, 0.7, 1);

		Story = new FlxSprite(Xshit,Yshit);
		Story.frames = Paths.getSparrowAtlas('8bit/MUNE','shared');;
		Story.animation.addByPrefix('selected','story0',24,false);
		Story.animation.addByPrefix('unselected','unstory0',24,false);
		Story.animation.addByPrefix('clicked','tapstory0',24,false);
		Story.scale.set(2,2);
		Story.antialiasing = false;
		Story.animation.play('unselected');
		add(Story);
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