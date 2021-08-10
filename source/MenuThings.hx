package;

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

		
	}
}