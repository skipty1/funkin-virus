package;

import flixel.*
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

class AllyChar extends FlxSprite
{
	var loopDone:Int = 0;
	public var animOffsets:Map<String, Array<Dynamic>>;
	public static var lockAnim:Bool = false;
	
	public function new (xPos:Float, yPos:Float, char:String)
	{
		super(xPos,yPos);
		
		x = xPos;
		y = yPos;
		antialiasing = false;
		
		switch (char)
		{
			case "kris":
				frames = fromI8Array(
					[ { Source: Paths.image("rpg/Kris_battle_idle", "shared"), Description: Paths.file("images/rpg/Kris_battle_idle.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_intro", "shared"), Description: Paths.file("images/rpg/Kris_battle_intro.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_act", "shared"), Description: Paths.file("images/rpg/Kris_battle_act.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_attack", "shared"), Description: Paths.file("images/rpg/Kris_battle_attack.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_guard", "shared"), Description: Paths.file("images/rpg/Kris_battle_guard.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_hurt", "shared"), Description: Paths.file("images/rpg/Kris_battle_hurt.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_item", "shared"), Description: Paths.file("images/rpg/Kris_battle_item.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_sitting", "shared"), Description: Paths.file("images/rpg/Kris_battle_sitting.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_victory", "shared"), Description: Paths.file("images/rpg/Kris_battle_victory.json", "shared")}
					]
				);
				animation.addByNames('intro', ["Kris_battle_intro 0.gif", "Kris_battle_intro 1.gif", "Kris_battle_intro 2.gif", "Kris_battle_intro 3.gif", "Kris_battle_intro 4.gif", "Kris_battle_intro 5.gif", "Kris_battle_intro 6.gif", "Kris_battle_intro 7.gif", "Kris_battle_intro 8.gif", "Kris_battle_intro 9.gif", "Kris_battle_intro 10.gif", "Kris_battle_intro 11.gif"], 10, false);
				animation.addByNames("idle", ["Kris_battle_idle 0.gif", "Kris_battle_idle 1.gif", "Kris_battle_idle 2.gif", "Kris_battle_idle 3.gif", "Kris_battle_idle 4.gif", "Kris_battle_idle 5.gif"], 10, false);
				animation.addByNames("attack", ["Kris_battle_attack 0.gif", "Kris_battle_attack 1.gif", "Kris_battle_attack 2.gif", "Kris_battle_attack 3.gif", "Kris_battle_attack 4.gif", "Kris_battle_attack 5.gif", "Kris_battle_attack 6.gif", "Kris_battle_attack 7.gif"], 10, false);
				animation.addByNames("attack-charge", ["Kris_battle_attack 0.gif"], 10, false);
				animation.addByNames("act", ["Kris_battle_act 0.gif", "Kris_battle_act 1.gif", "Kris_battle_act 2.gif", "Kris_battle_act 3.gif", "Kris_battle_act 4.gif", "Kris_battle_act 5.gif", "Kris_battle_act 6.gif", "Kris_battle_act 7.gif", "Kris_battle_act 8.gif", "Kris_battle_act 9.gif", "Kris_battle_act 10.gif", "Kris_battle_act 11.gif"], 10, false);
				animation.addByNames("think", ["Kris_battle_act 0.gif", "Kris_battle_act 1"], 10, false);
				animation.addByNames("guard", ["Kris_battle_guard 0.gif", "Kris_battle_guard 1.gif", "Kris_battle_guard 2.gif", "Kris_battle_guard 3.gif", "Kris_battle_guard 4.gif", "Kris_battle_guard 5.gif"], 10, false);;
				animation.addByNames("item", ["Kris_battle_item 0.gif", "Kris_battle_item 1.gif", "Kris_battle_item 2.gif", "Kris_battle_item 3.gif", "Kris_battle_item 4.gif", "Kris_battle_item 5.gif", "Kris_battle_item 6.gif"], 10, false);
				animation.addByNames("grabbingitem", ["Kris_battle_item 7.gif"], 10, false);
				animation.addByNames("victory", ["Kris_battle_victory 0.gif", "Kris_battle_victory 1.gif", "Kris_battle_victory 2.gif", "Kris_battle_victory 3.gif", "Kris_battle_victory 4.gif", "Kris_battle_victory 5.gif", "Kris_battle_victory 6.gif", "Kris_battle_victory 7.gif"], 10, false);
				animation.addByNames("down", ["Kris_battle_sitting.png"], 10, false);
				animation.addByNames("hurt" ["Kris_battle_hurt.png"], 10, false);
				
				addOffset("down");
				addOffset("hurt");
				addOffset("victory");
				addOffset("grabbingitem");
				addOffset("item");
				addOffset("guard");
				addOffset("think");
				addOffset("act");
				addOffset("attack");
				addOffset("idle");
				addOffset("intro");
		}
		playAnim("intro", true, false, 10);
		setGraphicSize(Std.int(width * 2));
		updateHitbox();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!lockAnim && animation.finished)
			playAnim("idle", true, false, 10);
	}
	
	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);
		
		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}
	
	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
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
	
	public static function fromI8Array(array:Array<{Source:FlxGraphicAsset, Description:String}>):FlxAtlasFrames {
		var i8frames:Array<FlxAtlasFrames> = [];
		for (i8 in array)
			i8frames.push(fromJson(i8.Source, i8.Description));

		var parent = i8frames[0];
		i8frames.shift();

		for (frames in i8frames)
			for (frame in frames.frames)
				parent.pushFrame(frame);

		return parent;
	}
	
}