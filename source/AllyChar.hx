package;

import flixel.*

class AllyChar extends FlxSprite
{
	var loopDone:Int = 0;
	public static var playingAnim:Bool = false;
	
	public function changeAnim(id:Int, anim:String, loop:Bool, ?loopAmount:Int = 0)
	{
		switch (id)
		{
			case 1: //Kris
				switch (anim)
				{
					case "idle":
						doTheIdle(id);
				}
		}
	}
	
	public function doTheIdle(id:Int)
	{
		switch (id)
		{
			frames = fromJson(Paths.image("rpg/Kris_battle_idle", "shared"), Paths.json("images/rpg/Kris_battle_idle.json", "shared"));
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