package;

import flixel.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
//import openfl.utils.Assets as OpenFlAssets;

class BattleTest extends MusicBeatState
{
	//idfk.
	public static var enemACode:Int = 0; //0 for default aka darryl.
	public static var enemBCode:Int = -1;
	public static var enemCCode:Int = -1;
	
	var loopthing:Int = 0;
	var looplimit:Int = 10;
	
	public var enemyA:FlxSprite;
	
	override function create()
	{
		enemyA = new FlxSprite();
		enemyA.frames = fromJson(Paths.image("rpg/darrly-roll-start", "shared"), Paths.file("rpg/darrly-roll-start.json", "shared"));
		enemyA.animation.addByNames('idle0', ['darrly-roll-start 0.gif'], 24, false);
		enemyA.animation.addByNames('idle1', ['darrly-roll-start 1.gif'], 24, false);
		enemyA.animation.addByNames('idle2', ['darrly-roll-start 2.gif'], 24, false);
		enemyA.animation.addByNames('idle3', ['darrly-roll-start 3.gif'], 24, false);
		enemyA.animation.addByNames('idle4', ['darrly-roll-start 4.gif'], 24, false);
		enemyA.animation.addByNames('idle5', ['darrly-roll-start 5.gif'], 24, false);
		enemyA.animation.addByNames('idle6', ['darrly-roll-start 6.gif'], 24, false);
		enemyA.animation.addByNames('idle7', ['darrly-roll-start 7.gif'], 24, false);
		enemyA.animation.addByNames('idle8', ['darrly-roll-start 8.gif'], 24, false);
		enemyA.animation.addByNames('idle9', ['darrly-roll-start 9.gif'], 24, false);
		enemyA.animation.addByNames('idle10', ['darrly-roll-start 10.gif'], 24, false);
		enemyA.antialiasing = false;
		enemyA.scale.set(2,2);
		add(enemyA);
		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			enemyA.animation.play('idle' + Std.int(loopthing));
			loopthing += 1;
			if (loopthing != 11)
				tmr.reset(0.1);
			else
				changeAnim(1, "idle");
		});
	}
	
	function changeAnim(enem:Int, anim:String)
	{
		switch (enem)
		{
			case 1:
				remove(enemyA);
				switch (anim)
				{
					case "idle":
						enemyA = new FlxSprite();
						enemyA.frames = fromJson(Paths.image("rpg/darrly-idle", "shared"), Paths.file("rpg/darrly-idle.json", "shared"));
						enemyA.animation.addByNames('idle0', ['darrly-idle 0.gif'], 24, false);
						enemyA.animation.addByNames('idle1', ['darrly-idle 1.gif'], 24, false);
						enemyA.animation.addByNames('idle2', ['darrly-idle 2.gif'], 24, false);
						enemyA.animation.addByNames('idle3', ['darrly-idle 3.gif'], 24, false);
						enemyA.animation.addByNames('idle4', ['darrly-idle 4.gif'], 24, false);
						enemyA.animation.addByNames('idle5', ['darrly-idle 5.gif'], 24, false);
						enemyA.antialiasing = false;
						enemyA.scale.set(2,2);
						add(enemyA);
				}
		}
	}
	
	public static function fromJson(Source:FlxGraphicAsset, Description:String):Null<Dynamic> {
		var graphic:FlxGraphic = FlxG.bitmap.add(Source);
		if (graphic == null)
			return null;

		// No need to parse data again
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		if (graphic == null || Description == null)
			return null;

		frames = new FlxAtlasFrames(graphic);

		if (Assets.exists(Description))
			Description = Assets.getText(Description);

		var json = Json.parse(Description);
		var framelist = Reflect.fields(json.frames);

		for (framename in framelist)
		{
			var frame = Reflect.field(json.frames, framename);
			trace(frame);
			var rect = FlxRect.get(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h);
			// var duration:Int = frame.duration; // 100 = 10fps???

			frames.addAtlasFrame(rect, FlxPoint.get(rect.width, rect.height), FlxPoint.get(), framename);
		}

		return frames;
	}

}