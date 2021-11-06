package dr;

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

class Kris extends AllyChar
{
	public var hp:Int = 160;
	public var def:Int = 8;
	public var atk:Int = 14;
	public var isDef:Bool = false;
	public var dmg:Int = 0;
	public var lockAnim: Bool = false;
	
	public function new(x:Float, y:Float, ?char:String = "kris")
	{
		super(x, y, char);
	}
	
	override public function update(el:Float)
	{
		super.update(el);
		
		if (hp < 1 && !lockAnim)
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
			playAnim("idle", true, false, 10);
	}
	
	public function decreaseHp(amount:Int)
	{
		var realAmount = amount;
		var thing:Int = def + def;
		realAmount = amount - thing;
		hp -= realAmount;
		FlxG.sound.play(Paths.sound("rpg/hurt", "shared"));
	}
}