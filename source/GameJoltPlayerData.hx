
import flixel.FlxG;
import FlxGameJolt;

class GameJoltPlayerData{
	public static function loadInit(?ass:Bool = false){
		joltInit(ass);
	}
	public static function joltInit(ass:Bool):Void{
		if (FlxGameJolt._initialized){
			/*var http = new haxe.Http("https://raw.githubusercontent.com/zacksgamerz/funkin-virus/master/users.banned");
			var returnedData:Array<String> = [];
			http.onData = function (data:String)
			{
				returnedData[0] = data.substring(0, data.indexOf(';'));
				returnedData[1] = data.substring(data.indexOf('-'), data.length);
				if (FlxGameJolt._userToken == returnedData[0])
					{
						trace('Banned user moment. Token: ' + returnedData[0]);
						FlxG.save.data.banned = true;
						return;
					}
					else
					{
						trace('Not banned');
					}
				}

			http.onError = function (error) {
			  trace('error: $error');
			  return;
			}
			*/
			KeyJolt.setData(0,"false",true);
			KeyJolt.setData(1,"false",true);
			KeyJolt.setData(2,"false",true);
			KeyJolt.setData(5,"false",true);
			if (FlxG.save.data.storyBeated)
				KeyJolt.setData(0,"true",true);
			if (FlxG.save.data.discoBeated)
				KeyJolt.setData(1,"true",true);
			if (FlxG.save.data.intoxicateBeated)
				KeyJolt.setData(2,"true",true);
			if (ass)
				KeyJolt.setData(5,"true",true);
			
			KeyJolt.setData(3,Std.string(FlxG.save.data.discoScore),true);
			KeyJolt.setData(4,Std.string(FlxG.save.data.intoxicateScore),true);
		}
	}
}