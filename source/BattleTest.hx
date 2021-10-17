package;

import flixel.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
//import openfl.utils.Assets as OpenFlAssets;

class BattleTest extends MusicBeatState
{
	//idfk.
	public static var enemACode:Int = 0; //0 for default aka darryl.
	public static var enemBCode:Int = -1;
	public static var enemCCode:Int = -1;
	
	public static var hasBit:Bool = false;
	
	var loopthing:Int = 0;
	var looplimit:Int = 10;
	var enemyAcurAnim:String = "";
	var battleTimer:Float = 0.0;
	
	public var enemyA:FlxSprite;
	public var kris:AllyChar;
	
	override function create()
	{
		enemyA = new FlxSprite();
		enemyA.frames = fromJson(Paths.image("rpg/darrly-roll-start", "shared"), Paths.file("images/rpg/darrly-roll-start.json", "shared"));
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
		enemyA.x = 1054;
		enemyA.y = 254;
		
		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			battleTimer += 0.1;
			tmr.reset(0.1);
		});
		
		kris = new AllyChar();
		kris.frames = fromJson(Paths.image("rpg/Kris_battle_intro", "shared"), Paths.file("images/rpg/Kris_battle_intro.json", "shared"));
		kris.animation.addByNames('idle0', ['Kris_battle_intro 0.gif'], 24, false);
		kris.animation.addByNames('idle1', ['Kris_battle_intro 1.gif'], 24, false);
		kris.animation.addByNames('idle2', ['Kris_battle_intro 2.gif'], 24, false);
		kris.animation.addByNames('idle3', ['Kris_battle_intro 3.gif'], 24, false);
		kris.animation.addByNames('idle4', ['Kris_battle_intro 4.gif'], 24, false);
		kris.animation.addByNames('idle5', ['Kris_battle_intro 5.gif'], 24, false);
		kris.animation.addByNames('idle6', ['Kris_battle_intro 6.gif'], 24, false);
		kris.animation.addByNames('idle7', ['Kris_battle_intro 7.gif'], 24, false);
		kris.animation.addByNames('idle8', ['Kris_battle_intro 8.gif'], 24, false);
		kris.animation.addByNames('idle9', ['Kris_battle_intro 9.gif'], 24, false);
		kris.animation.addByNames('idle10', ['Kris_battle_intro 10.gif'], 24, false);
		kris.animation.addByNames('idle11', ['Kris_battle_intro 11.gif'], 24, false);
		kris.antialiasing = false;
		kris.scale.set(2,2);
		add(kris);
		new FlxTimer().start(0.1, function(tmr:FlxTimer){
			enemyA.animation.play('idle' + Std.int(loopthing));
			loopthing += 1;
			if (loopthing != 11)
			{
				tmr.reset(0.1);
			}
			else
			{
				remove(kris);
				loopthing = 0;
				kris.changeAnim(1, "idle");
			}
		});
		kris.x = 262;
		kris.y = enemyA.y;
	}
	
	function changeAnim(enem:Int, anim:String)
	{
		
		switch (enem)
		{
			case 1:
				remove(enemyA);
				enemyAcurAnim = anim;
				switch (anim)
				{
					case "idle":
						enemyA = new FlxSprite();
						enemyA.x = 1054;
						enemyA.y = 254;
						enemyA.frames = fromJson(Paths.image("rpg/darrly-idle", "shared"), Paths.file("images/rpg/darrly-idle.json", "shared"));
						enemyA.animation.addByNames('idle0', ['darrly-idle 0.gif'], 24, false);
						enemyA.animation.addByNames('idle1', ['darrly-idle 1.gif'], 24, false);
						enemyA.animation.addByNames('idle2', ['darrly-idle 2.gif'], 24, false);
						enemyA.animation.addByNames('idle3', ['darrly-idle 3.gif'], 24, false);
						enemyA.animation.addByNames('idle4', ['darrly-idle 4.gif'], 24, false);
						enemyA.animation.addByNames('idle5', ['darrly-idle 5.gif'], 24, false);
						enemyA.antialiasing = false;
						enemyA.scale.set(2,2);
						add(enemyA);
						playAnim(1, 5, true);
				}
		}
	}
	
	
	
	function playAnim(enem:Int, frames:Int, loop:Bool)
	{
		looplimit = frames + 1;
		loopthing = 0;
		switch (enem)
		{
			case 1:
				new FlxTimer().start(0.1, function(tmr:FlxTimer){
					enemyA.animation.play("idle" + loopthing);
					if (loopthing != looplimit)
					{
						tmr.reset(0.1);
					}
					else
					{
						if (looping)
						{
							loopthing = 0;
							trace("anim finished");
							changeAnim(enem, enemyAcurAnim);
						}
						else
						{
							loopthing = 0;
							trace("anim finished");
							changeAnim(enem, "idle");
						}
					}
				});
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