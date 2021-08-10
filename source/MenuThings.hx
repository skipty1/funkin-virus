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

class MenuThings extends FlxSpriteGroup{
	//varrrsss
	public var Achievement:FlxSprite;
	public var Music:FlxSprite;
	public var Bestplayer:FlxSprite;
	public var Freeplay:FlxSprite;
	public var Gold:FlxSprite;
	public var Install:FlxSprite;
	public var Iron:FlxSprite;
	public var Rainbow:FlxSprite;
	public var Story:FlxSprite;
	public var path:String = "";
	public var Xshit:Float = 0;
	public var Yshit:Float = 0;
//functionsss
	public function new(offsetX:Float, offsetY:Float){
		super(offsetX, offsetY);
		Xshit = offsetX;
		Yshit = offsetY;
		path = Paths.getSparrowAtlas('8bit/MUNE','shared');

		Achievement = new FlxSprite(Xshit, Yshit);
		Achievement.frames = path;
		Achievement.animation.addByPrefix('selected','Achievement0',24,false);
		Achievement.animation.addByPrefix('unselected','unAchievement0',24,false);
		Achievement.scale.set(2,2);
		Achievement.antialiasing = false;
		Achievement.animation.play('unselected');
		add(Achievement);

		Music = new FlxSprite(Xshit,Yshit);
		Music.frames = path;
		Music.animation.addByPrefix('selected','MUSIC',24,false);
		Music.animation.addByPrefix('unselected','UNMUSIC',24,false);
		Music.scale.set(2,2);
		Music.antialiasing = false;
		Music.animation.play('unselected');
		add(Music);

		Bestplayer = new FlxSprite(Xshit,Yshit);
		Bestplayer.frames = path;
		Bestplayer.animation.addByPrefix('mmmhi','best player',24,false);
		Bestplayer.scale.set(2,2);
		Bestplayer.antialiasing = false;
		Bestplayer.animation.play('mmmhi');
		add(Bestplayer);
		if (FlxG.save.data.ProPlayer)
			Bestplayer.color = FlxColor.fromHSL(Bestplayer.color.hue, Bestplayer.color.saturation, 1, 1);
		else
			Bestplayer.color = FlxColor.fromHSL(Bestplayer.color.hue, Bestplayer.color.saturation, 0.7, 1);


		Freeplay = new FlxSprite(Xshit,Yshit);
		Freeplay.frames = path;
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
		Gold.frames = path;
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
		Install.frames = path;
		Install.animation.addByPrefix('selected','install0',24,false);
		Install.animation.addByPrefix('unselected','uninstall0',24,false);
		Install.scale.set(2,2);
		Install.antialiasing = false;
		Install.animation.play('unselected');
		add(Install);

		Iron = new FlxSprite(Xshit,Yshit);
		Iron.frames = path;
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
		Rainbow.frames = path;
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
		Story.frames = path;
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