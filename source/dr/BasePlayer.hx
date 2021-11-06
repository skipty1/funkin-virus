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

class BasePlayer extends FlxSprite {
	public var speed:Int = 300; // speed of player
	
	var up:Bool = false;
	var down:Bool = false;
	var left:Bool = false;
	var right:Bool = false;

	public var onMove:FlxSignal;
	
	public function new(?x:Float = 0, ?y:Float = 0) {
		super(x, y);
		//makeGraphic(20, 20, FlxColor.BLUE);
		drag.x = drag.y = 1600;

		onMove = new FlxSignal();
	}

	override public function update(elapsed:Float) {
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
			// if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
			// {
			// 	stepSound.play();

			// 	switch (facing)
			// 	{
			// 		case LEFT, RIGHT:
			// 			animation.play("lr");
			// 		case UP:
			// 			animation.play("u");
			// 		case DOWN:
			// 			animation.play("d");
			// 		case _:
			// 	}
			// }
		}
	}	
}