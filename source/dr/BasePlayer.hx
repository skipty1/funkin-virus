package dr;

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
import dr.*;

class BasePlayer extends AllyChar {
	public var speed:Int = 300; // speed of player
	
	var up:Bool = false;
	var down:Bool = false;
	var left:Bool = false;
	var right:Bool = false;

	public var freeze:Bool = false;
	
	public function new(?x:Float = 0, ?y:Float = 0, ?char:String = "kris") {
		super(x, y, char);
		//makeGraphic(20, 20, FlxColor.BLUE);
		drag.x = drag.y = 1600;
	}

	override public function update(elapsed:Float) {
		if(!freeze)
			updateMovement();
		
		super.update(elapsed);
	}

	function updateMovement()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		#if FLX_KEYBOARD
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);
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
			if ((velocity.x != 0 || velocity.y != 0)/* && touching == NONE*/)
			{

				switch (facing)
				{
					case FlxObject.LEFT:
						playAnim("walk-left");
					case FlxObject.RIGHT:
						playAnim("walk-right");
					case FlxObject.UP:
						playAnim("walk-up");
					case FlxObject.DOWN:
						playAnim("walk-down");
					case _:
				}
			}
		}

		var upR:Bool = false;
		var downR:Bool = false;
		var leftR:Bool = false;
		var rightR:Bool = false;

		#if FLX_KEYBOARD
		upR = FlxG.keys.anyJustReleased([UP, W]);
		downR = FlxG.keys.anyJustReleased([DOWN, S]);
		leftR = FlxG.keys.anyJustReleased([LEFT, A]);
		rightR = FlxG.keys.anyJustReleased([RIGHT, D]);
		#end

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

}