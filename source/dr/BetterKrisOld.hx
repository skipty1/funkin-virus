package dr;

import flixel.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import flixel.util.FlxSignal;
import flixel.util.FlxDestroyUtil;
import Achievements.MedalSaves;
import openfl.Lib;
import flixel.math.FlxVector;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import openfl.display.Bitmap;
import flixel.tile.FlxTilemap;
import openfl.utils.Assets;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.*;
import openfl.utils.Assets;
import openfl.utils.AssetType;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import dr.*;

using StringTools;

class BetterKris extends FlxSprite
{
	public var hp:Int = 160;
	public var def:Int = 8;
	public var atk:Int = 14;
	public var isDef:Bool = false;
	public var dmg:Int = 0;
	public var lockAnim: Bool = false;
	public var speed:Int = 300; // speed of player
	
	public function new(?x:Float, ?y:Float)
	{
		super(x, y);
		
				frames = fromI8Array(
					[ { Source: Paths.image("rpg/Kris_battle_idle", "shared"), Description: Paths.file("images/rpg/Kris_battle_idle.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_intro", "shared"), Description: Paths.file("images/rpg/Kris_battle_intro.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_act", "shared"), Description: Paths.file("images/rpg/Kris_battle_act.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_attack", "shared"), Description: Paths.file("images/rpg/Kris_battle_attack.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_guard", "shared"), Description: Paths.file("images/rpg/Kris_battle_guard.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_hurt", "shared"), Description: Paths.file("images/rpg/Kris_battle_hurt.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_item", "shared"), Description: Paths.file("images/rpg/Kris_battle_item.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_sitting", "shared"), Description: Paths.file("images/rpg/Kris_battle_sitting.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_victory", "shared"), Description: Paths.file("images/rpg/Kris_battle_victory.json", "shared")}, { Source: Paths.image("rpg/Kris_goup", "shared"), Description: Paths.file("images/rpg/Kris_goup.json", "shared")}, { Source: Paths.image("rpg/Kris_goright", "shared"), Description: Paths.image("images/rpg/Kris_goright.json", "shared")}, { Source: Paths.image("rpg/Kris_goleft", "shared"), Description: Paths.file("images/rpg/Kris_goleft.json", "shared")}, { Source: Paths.image("rpg/Kris_godown", "shared"), Description: Paths.file("images/rpg/Kris_godown.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_attack_ready", "shared"), Description: Paths.file("images/rpg/Kris_battle_attack_ready.json", "shared")}, { Source: Paths.image("rpg/Kris_battle_act_ready", "shared"), Description: Paths.I8json("rpg/Kris_battle_act_ready", "shared")}
					]
				);
				animation.addByNames('intro', ["Kris_battle_intro 0.gif", "Kris_battle_intro 1.gif", "Kris_battle_intro 2.gif", "Kris_battle_intro 3.gif", "Kris_battle_intro 4.gif", "Kris_battle_intro 5.gif", "Kris_battle_intro 6.gif", "Kris_battle_intro 7.gif", "Kris_battle_intro 8.gif", "Kris_battle_intro 9.gif", "Kris_battle_intro 10.gif", "Kris_battle_intro 11.gif"], 10, false);
				animation.addByNames("idle", ["Kris_battle_idle 0.gif", "Kris_battle_idle 1.gif", "Kris_battle_idle 2.gif", "Kris_battle_idle 3.gif", "Kris_battle_idle 4.gif", "Kris_battle_idle 5.gif"], 10, false);
				animation.addByNames("attack", ["Kris_battle_attack 0.gif", "Kris_battle_attack 1.gif", "Kris_battle_attack 2.gif", "Kris_battle_attack 3.gif", "Kris_battle_attack 4.gif", "Kris_battle_attack 5.gif", "Kris_battle_attack 6.gif", "Kris_battle_attack 7.gif"], 10, false);
				animation.addByNames("attack-charge", ["Kris_battle_attack_ready 0.gif"], 10, false);
				animation.addByNames("act", ["Kris_battle_act 0.gif", "Kris_battle_act 1.gif", "Kris_battle_act 2.gif", "Kris_battle_act 3.gif", "Kris_battle_act 4.gif", "Kris_battle_act 5.gif", "Kris_battle_act 6.gif", "Kris_battle_act 7.gif", "Kris_battle_act 8.gif", "Kris_battle_act 9.gif", "Kris_battle_act 10.gif", "Kris_battle_act 11.gif"], 10, false);
				animation.addByNames("think", ["Kris_battle_act_ready 0.gif", "Kris_battle_act_ready 1"], 10, false);
				animation.addByNames("guard", ["Kris_battle_guard 0.gif", "Kris_battle_guard 1.gif", "Kris_battle_guard 2.gif", "Kris_battle_guard 3.gif", "Kris_battle_guard 4.gif", "Kris_battle_guard 5.gif"], 10, false);
				animation.addByNames("item", ["Kris_battle_item 0.gif", "Kris_battle_item 1.gif", "Kris_battle_item 2.gif", "Kris_battle_item 3.gif", "Kris_battle_item 4.gif", "Kris_battle_item 5.gif", "Kris_battle_item 6.gif"], 10, false);
				animation.addByNames("grabbingitem", ["Kris_battle_item 7.gif"], 10, false);
				animation.addByNames("victory", ["Kris_battle_victory 0.gif", "Kris_battle_victory 1.gif", "Kris_battle_victory 2.gif", "Kris_battle_victory 3.gif", "Kris_battle_victory 4.gif", "Kris_battle_victory 5.gif", "Kris_battle_victory 6.gif", "Kris_battle_victory 7.gif"], 10, false);
				animation.addByNames("died", ["Kris_battle_sitting.png"], 10, false);
				animation.addByNames("hurt", ["Kris_battle_hurt.png"], 10, false);
				
				animation.addByNames("walk-left", ["Kris_goleft 0.gif", "Kris_goleft 1.gif", "Kris_goleft 2.gif", "Kris_goleft 3.gif"], 10, false);
				animation.addByNames("walk-right", ["Kris_goright 0.gif", "Kris_goright 1.gif", "Kris_goright 2.gif", "Kris_goright 3.gif"], 10, false);
				animation.addByNames("walk-up", ["Kris_goup 0.gif", "Kris_goup 1.gif", "Kris_goup 2.gif", "Kris_goup 3.gif"], 10, false);
				animation.addByNames("walk-down", ["Kris_godown 0.gif", "Kris_godown 1.gif", "Kris_godown 2.gif", "Kris_godown 3.gif"], 10, false);
				animation.addByNames("left", ["Kris_goleft 0.gif"], 10, false);
				animation.addByNames("up", ["Kris_goup 0.gif"], 10, false);
				animation.addByNames("right", ["Kris_goright 0.gif"], 10, false);
				animation.addByNames("down", ["Kris_godown 0.gif"], 10, false);
				
				addOffset("died");
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
				addOffset("down");
				addOffset("walk-down");
				addOffset("up");
				addOffset("walk-up");
				addOffset("left");
				addOffset("walk-left");
				addOffset("right");
				addOffset("walk-right");

		playAnim("down", true, false, 10);
		setGraphicSize(Std.int(width * 2));
		updateHitbox();
	}
	
	override public function update(el:Float)
	{
		super.update(el);
		
		/*if (hp < 1 && !lockAnim)
		{
			playAnim("down", true, false, 10);
			lockAnim = true;
		}
		if (hp > 1 && lockAnim && animation.curAnim.name == "down")
		{
			playAnim("idle", true, false, 10);
			lockAnim = false;
		}
		if (animation.finished && !lockAnim)
			playAnim("idle", true, false, 10);*/
		
		updateMovement();
		
	}
	
	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;
		var upR:Bool = false;
		var downR:Bool = false;
		var leftR:Bool = false;
		var rightR:Bool = false;

		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
		upR = FlxG.keys.anyReleased([UP, W]);
		downR = FlxG.keys.anyReleased([DOWN, S]);
		leftR = FlxG.keys.anyReleased([LEFT, A]);
		rightR = FlxG.keys.anyReleased([RIGHT, D]);
		#end

		// #if mobile
		// var virtualPad = PlayState.virtualPad;
		// up = up || virtualPad.buttonUp.pressed;
		// down = down || virtualPad.buttonDown.pressed;
		// left = left || virtualPad.buttonLeft.pressed;
		// right = right || virtualPad.buttonRight.pressed;
		// #end

		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		if (up || down || left || right)
		{
			onMove.dispatch();

			var newAngle:Float = 0;
			if (up)
			{
				
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
				facing = FlxObject.UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = FlxObject.DOWN;
			}
			else if (left)
			{
				newAngle = 180;
				facing = FlxObject.LEFT;
			}
			else if (right)
			{
				newAngle = 0;
				facing = FlxObject.RIGHT;
			}

			// determine our velocity based on angle and speed
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), newAngle);

			// if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
			if ((velocity.x != 0 || velocity.y != 0) && touching == NONE && animation.finished)
			{
			// 	stepSound.play();
			// step sound???

				switch (facing)
				{
					case LEFT:
						playAnim("walk-left", true, false, 10);
					case UP:
						playAnim("walk-up", true, false, 10);
					case DOWN:
						playAnim("walk-down", true, false, 10);
					case RIGHT:
						playAnim("walk-right", true, false, 10);
				}
			}
		}
		
		if ((upR || downR || leftR || rightR) && animation.finished) {
			if (upR)
				playAnim("up", true, false, 10);
			if (downR)
				playAnim("down", true, false, 10);
			if (leftR)
				playAnim("left", true, false, 10);
			if (rightR)
				playAnim("right", true, false, 10);
		}
	}
	
	public function decreaseHp(amount:Int)
	{
		var realAmount = amount;
		var thing:Int = def + def;
		realAmount = amount - thing;
		hp -= realAmount;
		FlxG.sound.play(Paths.sound("rpg/hurt", "shared"));
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
}