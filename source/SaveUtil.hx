package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.math.FlxPoint;

using StringTools;

class SaveUtil
{
	var save:FlxSave;
	
	public function new()
	{
		save = new FlxSave();
		save.bind("deltarune");
	}
	
	public function rpgSave(mode:String, ?slot:Int = 0):Void
	{
		switch (mode)
		{
			case "init":
				if (save.data.init == null)
				{
					save.data.name = "kris";
					save.data.power = 1;
					save.data.love = 3;
					save.data.map = 1;
					save.data.team = ["kris"];
					save.data.killed = 0;
					save.data.played = false;
					save.data.defeatedboss = false;
					save.data.items = ["funni dog"];
					save.data.init = true;
					
					save.flush();
				}
			case "save":
				if (slot == 0)
				{
					trace("ERROR: No slot given, save has been stopped.");
					return;
				}
				
				if (save.data.init == null)
				{
					trace("ERROR: Variable Save has not been initialized, initialize it first.");
					return;
				}
				
				save.data.map = Rpgvars.roomId;
				save.data.killed = Rpgvars.killsTotal;
				
				var saveThing = {
					"name": save.data.name,
					"lv": save.data.love,
					"power": save.data.power,
					"map": save.data.map,
					"team": save.data.team,
					"killed": save.data.killed,
					"played": save.data.played,
					"defeatedBoss": save.data.defeatedboss,
					"items": save.data.items
				}
				var saveThingstringed:String = haxe.Json.stringify(saveThing);
				trace(saveThingstringed);
				
				#if sys
				/*if (!sys.FileSystem.exists(Sys.getCwd() + "assets/shared/saves/slot_ch3_0.json"))
				{
					sys.FileSystem
				}*/
				sys.io.File.saveContent(Sys.getCwd() + 'assets/shared/saves/slot_ch3_' + Std.int(slot) + '.json', saveThingstringed);
				#end
		}
	}
	
	public function returnSave()
	{
		FlxG.save.data.killsTotal = save.data.killed;
		FlxG.save.data.roomId = save.data.map;
		FlxG.save.data.chars = save.data.team;
		FlxG.save.data.killsDarryl = 0;
		
		switch (save.data.map)
		{
			case 1:
				FlxG.save.data.roomName = "battletest";
		}
	}
}

class Rpgvars
{
	public static var killsDarryl:Int;
	public static var roomId:Int;
	public static var chars:Array<String>;
	public static var killsTotal:Int;
	public static var roomName:String;
	public static var chapter:Int;
	public static var krisHp:Int;
	
	public static function startInit()
	{
		var configure = new SaveUtil();
		configure.rpgSave("init");
		
		if (FlxG.save.data.rpgInit == null)
		{
			configure.returnSave();
		}
		killsDarryl = FlxG.save.data.killsDarryl;
		roomId = FlxG.save.data.roomId;
		chars = FlxG.save.data.chars;
		killsTotal = FlxG.save.data.killsDarryl;
		roomName = FlxG.save.data.roomName;
		chapter = 3;
		krisHp = 160;
	}
}