
import flixel.FlxG;
import FlxGameJolt;

class GameJoltPlayerData{
	public static function loadInit(){
		if (FlxG.save.data.gameJoltLoad == null){
			FlxG.save.data.banned = false;
			FlxG.save.data.songScores = 0;
			FlxG.save.data.lockedTrophies = 10;
			FlxG.save.data.unlockedTrophies = 0;
			FlxG.save.data.Logged = false;
			FlxG.save.data.completedSongs = 0;
			FlxG.save.data.gameBeaten = false;
			FlxG.save.data.user = null;
			FlxG.save.data.token = null;
			FlxG.save.data.gameJoltLoad = true;
		}
		joltInit();
	}
	public static function joltInit():Void{
		if (FlxGameJolt._initialized){
			var http = new haxe.Http("https://raw.githubusercontent.com/zacksgamerz/funkin-virus/master/users.banned");
			var returnedData:Array<String> = [];
			http.onData = function (data:String)
			{
				returnedData[0] = data.substring(0, data.indexOf(';'));
				returnedData[1] = data.substring(data.indexOf('-'), data.length);
				if (FlxGameJolt._usertoken == returnedData[0].trim())
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
			
			http.request();
			FlxG.save.data.Logged = FlxGameJolt._initialized;
			FlxG.save.data.lockedTrophies = FlxGameJolt.TROPHIES_MISSING;
			FlxG.save.data.unlockedTrophies = FlxGameJolt.TROPHIES_ACHIEVED;
		}
	}
}