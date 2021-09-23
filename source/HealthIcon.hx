package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		frames = Paths.getSparrowAtlas('8bit/BITS');
		animation.addByPrefix('fake',"fakebit0", 24, false);
		animation.addByPrefix('fake-win',"fakebit0",24,false);
		animation.addByPrefix('fake-lose',"fakebit0",24,false);
		animation.addByPrefix('bf-pixel', "BF0", 24, false, isPlayer);
		animation.addByPrefix('virus', "8V0", 24, false, isPlayer);
		animation.addByPrefix('bit', "8B0", 24, false, isPlayer);
		//animation.addByPrefix('retro', [6, 7], 0, false, isPlayer);
		animation.addByPrefix('classic', "8S0", 24, false, isPlayer);
		animation.addByPrefix('virus-mad', "MAD0", 24, false, isPlayer);
		//animation.addByPrefix('dark', [12, 13], 0, false, isPlayer);
		//animation.addByPrefix('blue', [14, 15], 0, false, isPlayer);
		animation.addByPrefix('bf-pixel-lose', "BF LOSING", 24, false, isPlayer);
		animation.addByPrefix('virus-lose', "8V LOSING", 24, false, isPlayer);
		animation.addByPrefix('bit-lose', "8B LOSING", 24, false, isPlayer);
		//animation.addByPrefix('retro-lose', [7, 7], 0, false, isPlayer);
		animation.addByPrefix('classic-lose', "8S LOSING", 2, false, isPlayer);
		animation.addByPrefix('virus-mad-lose', "MAD LOSING", 24, false, isPlayer);
		//animation.addByPrefix('dark-lose', [13, 13], 0, false, isPlayer);
		//animation.addByPrefix('blue-lose', [15, 15], 0, false, isPlayer);
		animation.addByPrefix('virus-win', "8V WINNING", 24, false, isPlayer);
		//animation.addByPrefix('dark-win', [21, 21], 0, false, isPlayer);
		animation.addByPrefix('bf-pixel-win', "BF WINNING", 24, false, isPlayer);
		animation.addByPrefix('bit-win', "8B WINNING", 24, false, isPlayer);
		animation.addByPrefix('classic-win', "8S WINNING", 24, false, isPlayer);
		animation.addByPrefix("virus-mad-win","MAD WINNING",24,false,isPlayer);
		animation.play(char, false);

		scrollFactor.set();
		antialiasing = false;//cuz pixelll
	}

	override function update(elapsed:Float)
	{
		if (FlxG.save.data.lessUpdate)
			super.update(elapsed/2);
		else
			super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
