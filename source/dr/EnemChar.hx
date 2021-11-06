package dr;

import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.*;
import flixel.tweens.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import dr.*;

using StringTools;

class EnemChar extends FlxSprite
{
	var loopDone:Int = 0;
	public var animOffsets:Map<String, Array<Dynamic>>;
	public static var lockAnim:Bool = false;
	public var hp:Int = 1;
	public var def:Int = 2;
	public var atkDmg:Int = 3;
	public var sparePersentage:Int = 0;
	public var maxSpareP:Int = 101;
	var name:String = "";
	
	public function new (xPos:Float, yPos:Float, char:String)
	{
		super(xPos,yPos);

		animOffsets = [];
		
		x = xPos;
		y = yPos;
		antialiasing = false;
		name = char;
		
		switch (char)
		{
			case "darryl":
				frames = fromI8Array(
					[ { Source: Paths.image("rpg/darrly-roll-over", "shared"), Description: Paths.file("images/rpg/darrly-roll-over.json", "shared")}, { Source: Paths.image("rpg/darrly-roll-start", "shared"), Description: Paths.file("images/rpg/darrly-roll-start.json", "shared")}, { Source: Paths.image("rpg/darrly-idle", "shared"), Description: Paths.file("images/rpg/darrly-idle.json", "shared")}, { Source: Paths.image("rpg/darrly-gun", "shared"), Description: Paths.file("images/rpg/darrly-gun.json", "shared")}, { Source: Paths.image("rpg/darrly-walk", "shared"), Description: Paths.file("images/rpg/darrly-walk.json", "shared")}, { Source: Paths.image("rpg/darryl-hurt", "shared"), Description: Paths.file("images/rpg/darryl-hurt.json", "shared")}, { Source: Paths.image("rpg/darryl-spared", "shared"), Description: Paths.file("images/rpg/darryl-spared.json", "shared")}]
				);
				animation.addByNames("roll-over", ["darrly-roll-over 0.gif", "darrly-roll-over 1.gif", "darrly-roll-over 2.gif", "darrly-roll-over 3.gif", "darrly-roll-over 4.gif", "darrly-roll-over 5.gif"], 10, false);
				animation.addByNames("idle", ["darrly-idle 0.gif", "darrly-idle 1.gif", "darrly-idle 2.gif", "darrly-idle 3.gif", "darrly-idle 4.gif", "darrly-idle 5.gif"], 10, false);
				animation.addByNames("gun-1", ["darrly-gun 0.gif", "darrly-gun 1.gif", "darrly-gun 2.gif", "darrly-gun 4.gif"], 10, false);
				animation.addByNames("gun-2", ["darrly-gun 5.gif", "darrly-gun 6.gif", "darrly-gun 7.gif", "darrly-gun 8.gif", "darrly-gun 9.gif", "darrly-gun 10.gif"], 10, false);
				animation.addByNames("roll-start", ["darrly-roll-start 0.gif", "darrly-roll-start 1.gif", "darrly-roll-start 2.gif", "darrly-roll-start 3.gif", "darrly-roll-start 4.gif", "darrly-roll-start 5.gif", "darrly-roll-start 6.gif", "darrly-roll-start 7.gif", "darrly-roll-start 8.gif", "darrly-roll-start 9.gif", "darrly-roll-start 10.gif"], 10, false);
				animation.addByNames("walk", ["darrly-walk 0.gif", "darrly-walk 1.gif", "darrly-walk 2.gif", "darrly-walk 3.gif", "darrly-walk 4.gif", "darrly-walk 5.gif", "darrly-walk 6.gif", "darrly-walk 7.gif"], 10, false);
				animation.addByNames("roll", ["darrly-roll-start 5.gif", "darrly-roll-start 6.gif", "darrly-roll-start 7.gif", "darrly-roll-start 8.gif", "darrly-roll-start 9.gif", "darrly-roll-start 10.gif"], 10, false);
				animation.addByNames("hurt", ["darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif", "darryl-hurt 0.gif"], 10, false);
				animation.addByNames("spare", ["darryl-spared 0.gif"], 10, false);
				addOffset("gun-1", -10, -10);
				addOffset("gun-2", -10, -10);
				addOffset("roll-over", -10, -10);
				addOffset("roll-start", -10, -10);
				addOffset("roll", -10, -10);
				addOffset("walk");
				addOffset("idle");
				addOffset("spare");
				addOffset("hurt");
				
				flipX = true;
				hp = 420;
				def = 20;
				atkDmg = 32;
				
				playAnim("roll-over", true, false, 10);
		}
		//playAnim("intro", true, false, 10);
		setGraphicSize(Std.int(width * 2));
		updateHitbox();
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (!lockAnim && animation.finished && sparePersentage != 100)
			playAnim("idle", true, false, 10);
		
		if (!lockAnim && animation.finished && sparePersentage == 100)
			playAnim("spare", true, false, 10);
		
		if (sparePersentage == maxSpareP)
		{
			sparePersentage = maxSpareP - 1;
		}
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
			// trace(frame);
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
	
	public function decreaseHp(amount:Int)
	{
		var realAmount = amount;
		var thing:Int = def + def;
		realAmount = amount - thing;
		hp -= realAmount;
		playAnim("hurt", true, false, 10);
	}
	
	public function actify(IsKris:Bool, act:String, Callback:Dynamic):Void
	{
		if (IsKris)
		{
			switch (name)
			{
				case "darryl":
					switch (act)
					{
						case "check":
							Callback("* Darryl - DEF: 6 ATK: 31 (20)\n* A barrel and a pirate, knows that you pirated some games before.\n");
						case "roll":
							Callback("* Kris rolls something!\n* Darryl's ATTACKS become faster.\n");
						default:
							Callback("* Darryl - DEF: 6 ATK: 31 (20)\n* A barrel and a pirate, knows that you pirated some games before.\n");
					}
			}
		}
		else
		{
			Callback("* 8-BIT pretends to be a ball!\n* Darryl's ATTACKS become slightly faster.\n");
		}
	}
	
	public function sparify(IsAct:Bool, Callback:Dynamic, ?persent:Int)
	{
		if (IsAct)
		{
			sparePersentage += persent;
			Callback(sparePersentage);
		}
		else
		{
			var xThing = x;
			FlxTween.color(this, 0.3, FlxColor.fromHSL(this.color.hue, this.color.saturation, 1, 1), 0xFFFFFFFF);
			FlxTween.tween(this, {x: xThing + 100, alpha: 0}, 0.3, {
				ease: FlxEase.cubeInOut,
				onComplete: function (twn:FlxTween){
					Callback(true);
				}
			});
		}
	}
}