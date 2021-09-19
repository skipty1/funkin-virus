//So i can know what data is what.
package;

import flixel.util.FlxTimer;
import flash.display.Loader;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import haxe.crypto.Md5;
import haxe.crypto.Sha1;
import flixel.FlxG;
#if flash
import flash.Lib;
#end

class KeyJolt{
	public static function checkAllAchieve(?returnMissing:Bool = false, ?returnAchieved:Bool = false){
		//I need trophy ids first.
	}
	//-1 is null
	//0 is storyBeated
	//1 is discoBeated
	//2 is intoxicateBeated.
	//3 is discoScore
	//4 is intoxicateScore
	//5 is betaTester
	
	public static function getData(dataId:Int = -1, ?user:Bool = false):String{
		var Stupid:String = "";
		var ass = Std.string(dataId);
		FlxGameJolt.fetchData(ass, user, (stringT) -> {
			Stupid = stringT;
		});
		return Stupid;
	}
	public static function setData(dataId:Int = -1, value:String, ?user:Bool = false){
		var ass = Std.string(dataId);
		FlxGameJolt.setData(ass, value, user);
	}
	public static function updateData(dataId:Int, Operation:String, Value:String, ?User:Bool = false){
		var ass = Std.string(dataId);
		FlxGameJolt.updateData(ass, Operation, Value, User);
	}
	public static function removeData(dataId:Int, ?user:Bool = false){
		var ass = Std.string(dataId);
		FlxGameJolt.removeData(ass, user);
	}
}