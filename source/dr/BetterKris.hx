package dr;

import flixel.FlxG;

class BetterKris extends BasePlayer {
    public var hp:Int = 160;
	public var def:Int = 8;
	public var atk:Int = 14;
	public var isDef:Bool = false;
	public var dmg:Int = 0;
	public var lockAnim: Bool = false;
    
    public function new(?x:Float, ?y:Float)
    {
        super(x, y, "kris");
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