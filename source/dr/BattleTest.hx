package dr;

import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.*;
import flixel.util.*;
import flixel.text.*;
import flixel.tweens.FlxTween;
import SaveUtil;
import SaveUtil.Rpgvars;
import flixel.addons.effects.FlxTrail;
import flixel.tweens.FlxEase;
import dr.*;

using StringTools;

class BattleTest extends RPGState
{
	public static var roomId: Int = 1;
	public var savefile: SaveUtil;
	public var kris: Kris;
	public var soul: FlxSprite;
	public var enemyA: EnemChar;
	public var totalHp: Int = 1;
	// public var krisStatA: FlxSprite;
	// public var krisStatB: FlxSprite;

	// public var buttonFight: FlxSprite;
	// public var buttonAct: FlxSprite;
	// public var buttonItem: FlxSprite;
	// public var buttonDef: FlxSprite;
	// public var buttonSpare: FlxSprite;
	public var fightthing: FlxSprite;
	public var atkbar: FlxSprite;

	public var playerTurn: String = "kris";
	public var curButton: Int = 0;
	public var hpText: FlxText;
	public var isAttack: Bool = false;
	public var combo: Int = 0;
	public var krisDmg: Int = 0;
	public var enemyASpare: Int = 0;
	public var extradef: Int = 0;
	/*List for combos (Might change soon)
	* 0 : +0 AtkDmg.
	* 3 : +10AtkDmg.
	* 6 : +30AtkDmg.
	* 15 : +65AtkDmg.
	*/
	
	var textBox:FlxSprite;

	var addedButtons: Bool = false;
	var tweenVar: FlxTween;

	var krisStat:KrisStat;

	override function create() {
		savefile = new SaveUtil();
		savefile.rpgSave("init");
		Rpgvars.startInit();

		//Before anything, do bg.

		var squareGrid: FlxSprite = new FlxSprite().loadGraphic(Paths.image("rpg/bg", "shared"));
		squareGrid.antialiasing = false;
		squareGrid.setGraphicSize(Std.int(squareGrid.width * 2));
		squareGrid.updateHitbox();
		squareGrid.screenCenter();
		add(squareGrid);

		soul = new FlxSprite().loadGraphic(Paths.image("rpg/heart", "shared"));
		soul.setGraphicSize(Std.int(soul.width * 2));
		soul.updateHitbox();
		soul.setPosition(0, 0);
		soul.antialiasing = false;
		soul.color = 0xFF00FFF2;
		add(soul);

		kris = new Kris(297, 386);
		kris.setGraphicSize(Std.int(kris.width * 2));
		kris.updateHitbox();
		kris.screenCenter(Y);
		add(kris);

		enemyA = new EnemChar(1050, 386, "darryl");
		enemyA.setGraphicSize(Std.int(enemyA.width * 2));
		enemyA.updateHitbox();
		add(enemyA);

		textBox = new FlxSprite().loadGraphic(Paths.image("rpg/textThing", "shared"));
		textBox.screenCenter();
		add(textBox);

		totalHp = Rpgvars.krisHp;

		krisStat = new KrisStat();
		krisStat.screenCenter(X);
		krisStat.y = FlxG.height - krisStat.height;
		add(krisStat);

		krisStat.buttons("add");

		//DO THIS LATER!!!!!
		//hpText = new FlxText();
	}

	override public function update(elapsed: Float) {
		super.update(elapsed);

		if (FlxG.keys.justReleased.B)
			krisStat.closed = !krisStat.closed;

		totalHp = Rpgvars.krisHp;

		if (totalHp < 1)
			die();

		if (playerTurn == "enemy" && addedButtons) {
			turn("enemy");
			
			if (FlxG.keys.pressed.LEFT) 
				soul.x += 0.2;
			if (FlxG.keys.pressed.RIGHT)
				soul.x -= 0.2;
			if (FlxG.keys.pressed.UP)
				soul.y -= 0.2;
			if (FlxG.keys.pressed.DOWN)
				soul.y += 0.2;
			if (FlxG.keys.justPressed.Z)
				playerTurn = "kris";
		}

		if (playerTurn == "kris" && addedButtons) {
			turn("kris");
			
			if (FlxG.keys.justPressed.LEFT)
				krisStat.buttons("select", -1);
			if (FlxG.keys.justPressed.RIGHT)
				krisStat.buttons("select", 1);
			
			if (FlxG.keys.justPressed.Z && !isAttack) {
				switch (curButton)
				{
					case 0: //
						attack(false);
						krisStat.buttons("die");
					case 3:
						defend();
						krisStat.buttons("die");
					case 1:
						//
						enemyA.sparify(true, (thing) -> {
							enemyASpare = thing;
						}, 50);
						krisStat.buttons("die");
						playerTurn = "enemy";
					case 2:
						//do nada
					case 4:
						if (enemyASpare == 100 || enemyASpare > 100) {
							enemyA.sparify(false, (thing) -> {
								new FlxTimer().start(0.1, function(tmr:FlxTimer) {
									if (thing != true) {
										tmr.reset(0.1);
									}
									else {
										endBattle();
									}
								});
							});
						}
				}
			}
			
			if (FlxG.keys.justPressed.Z && isAttack && FlxObject.updateTouchingFlags(atkbar, fightthing)) {
				attack(true);
			}
		}

	}

	//Not final code function, will add special effects soon. If I forget remind me -Zack.
	public function die() {
		//FlxG.switchState(new GameOverRPG());
	}
	
	public function endBattle() {
		//
	}


	public function turn(string:String) {
		switch (string) {
			case "enemy":
				soul.visible = true;
				krisStat.buttons("die");
				krisStat.closed = true;
				curButton = 0;
			case "kris":
				if (extradef != 0)
					extradef == 0;
				
				soul.visible = false;
				krisStat.buttons("live");
				krisStat.closed = false;
		}
	}
	
	//TEMPLATE CODE, WILL CHANGE AFTER GETTING SPRITES.
	public function attack(bool:Bool) {
		if (!bool) {
			kris.lockAnim = true;
			kris.playAnim("attack-charge", true, false, 10);
			fightthing = new FlxSprite(306, 561).loadGraphic(Paths.image("rpg/Kris_Decision_bar", "shared"));
			fightthing.setGraphicSize(Std.int(fightthing.width * 2));
			fightthing.antialiasing = false;
			add(fightthing);
			
			atkbar = new FlxSprite(206, 561).loadGraphic(Paths.image("rpg/Decision_line", "shared"));
			atkbar.setGraphicSize(Std.int(atkbar.width * 2));
			atkbar.antialiasing = false;
			add(atkbar);
			
			FlxTween.tween(atkbar, {x: fightthing.getGraphicMidpoint().x - 100}, 1.2, {
				ease: FlxEase.smoothStepIn,
				onComplete: function (twn:FlxTween) {
					isAttack = false;
					FlxTween.tween(atkbar, {alpha: 0}, 0.2, {
						ease:FlxEase.smoothStepOut
					});
				}
			});
			FlxTween.tween(kris, {dmg: 280}, 1.2);
			FlxTween.color(atkbar, 1.2, 0xFFFFFFFF, 0xFF008BFF);
			isAttack = true;
		}
		else {
			kris.playAnim("attack", true, false, 10);
			isAttack = false;
			var Trail: FlxTrail;
			if (atkbar != null) {
				FlxTween.cancelTweensOf(atkbar);
				FlxTween.cancelTweensOf(kris);
				Trail = new FlxTrail(atkbar, null, 3, 10, 0.3, 0.069);
				add(Trail);
			}
			var float: Float = 2.1;
			
			new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				atkbar.setGraphicSize(Std.int(atkbar.width * float));
				atkbar.updateHitbox();
				if (float < 2.3) {
					float += 0.1;
					tmr.reset();
				}
				else {
					remove(Trail);
					remove(atkbar);
				}
			});
			var specifiedDmg = kris.dmg;
			var daRate: String = "good";
			if (specifiedDmg < 120) {
				daRate = "bad";
				combo = 0;
			}
			if (specifiedDmg > 120) {
				daRate = "good";
				combo++;
			}
			if (specifiedDmg > 250) {
				daRate = "sick";
				combo++;
			}
			enemyA.decreaseHp(specifiedDmg);
			
			var Rating:FlxSprite = new FlxSprite().loadGraphic(Paths.image("8bit/" + daRate + "-pixel"));
			Rating.x = enemyA.x - 100;
			Rating.y = enemyA.getGraphicMidpoint().y;
			Rating.acceleration.x = 500;
			Rating.velocity.x += FlxG.random.int(90, 120);
		
			Rating.antialiasing = false;
			Rating.setGraphicSize(Std.int(Rating.width * 2));
			add(Rating);
		
			FlxTween.tween(Rating, {alpha: 0}, 0.3, {
				onComplete: function (twn:FlxTween) {
					Rating.destroy();
					isAttack = false;
					remove(fightthing);
					kris.dmg = 0;
					kris.playAnim("idle", true, false, 10);
					kris.lockAnim = false;
				}
			});
		}
	}
	
	//im a fcuking genius.
	//im not a fcuking genius.
	public function tweenDmg(thing:Int, v:Float) {
		krisDmg = Std.int(v);
	}
	
	public function defend() {
		extradef = 15;
		playerTurn = "enemy";
		
	}

}

// trying to use class
class KrisStat extends FlxSpriteGroup {
	
	var openStat:FlxSprite;
	var closedStat:FlxSprite;

	var buttonFight:FlxSprite;
	var buttonAct:FlxSprite;
	var buttonItem:FlxSprite;
	var buttonDef:FlxSprite;
	var buttonSpare:FlxSprite;
	
	var curButton:Int = 0;

	@:isVar public var closed(get, set):Bool;
	function get_closed():Bool
		return closed;
	
	function set_closed(closed:Bool):Bool {
		// if (closed)
		// {
		// 	openStat.visible = false;
		// 	closedStat.visible = true;
		// }else
		// {
		// 	openStat.visible = true;
		// 	closedStat.visible = false;
		// }

		// buttonFight.visible = !closed;
		// buttonDef.visible = !closed;
		// buttonItem.visible = !closed;
		// buttonSpare.visible = !closed;
		// buttonAct.visible = !closed;	

		FlxTween.num(closed ? 1 : 0, closed ? 0 : 1, 0.5, {}, val ->{
			buttonFight.y = buttonAct.y = buttonItem.y = buttonDef.y = buttonSpare.y = FlxMath.lerp(160, 80, val); // use openStat.y instead of this
			openStat.y = FlxMath.lerp(openStat.width / 2, 0, val);
		});
		
		return this.closed = closed;
	}
	public function new(?x, ?y) {
		super(x, y);

		openStat = new FlxSprite().loadGraphic(Paths.image("rpg/bar_open", "shared"));
		openStat.setGraphicSize(Std.int(openStat.width * 2));
		openStat.updateHitbox();
		openStat.antialiasing = false;

		closedStat = new FlxSprite().loadGraphic(Paths.image("rpg/bar", "shared"));
		closedStat.setGraphicSize(Std.int(closedStat.width * 2));
		closedStat.updateHitbox();
		closedStat.antialiasing = false;
		closedStat.x = 2;
		closedStat.y = openStat.height - closedStat.height;

		add(closedStat);
		add(openStat);
		initButtons();
		closed = false;
	}	

	function initButtons() {
		buttonFight = new FlxSprite().loadGraphic(Paths.image("rpg/FIGHT", "shared"));
		buttonFight.setGraphicSize(Std.int(buttonFight.width * 2));
		buttonFight.updateHitbox();
		buttonFight.antialiasing = false;
		buttonFight.setPosition(8, openStat.height - buttonFight.height - 10);
		add(buttonFight);
		var y = openStat.height - buttonFight.height - 10;
		trace(openStat.height - buttonFight.height - 10);

		buttonAct = new FlxSprite().loadGraphic(Paths.image("rpg/ACT", "shared"));
		buttonAct.setGraphicSize(Std.int(buttonAct.width * 2));
		buttonAct.updateHitbox();
		buttonAct.antialiasing = false;
		buttonAct.setPosition(buttonFight.x + buttonFight.width + 10, y);
		add(buttonAct);

		buttonItem = new FlxSprite().loadGraphic(Paths.image("rpg/ITEM", "shared"));
		buttonItem.setGraphicSize(Std.int(buttonAct.width * 1));
		buttonItem.updateHitbox();
		buttonItem.setPosition(buttonAct.x + buttonAct.width + 10, y);
		add(buttonItem);

		buttonDef = new FlxSprite().loadGraphic(Paths.image("rpg/DEFEND", "shared"));
		buttonDef.setGraphicSize(Std.int(buttonDef.width * 2));
		buttonDef.updateHitbox();
		buttonDef.setPosition(buttonItem.x + buttonItem.width + 10, y);
		buttonDef.antialiasing = false;
		add(buttonDef);

		buttonSpare = new FlxSprite().loadGraphic(Paths.image("rpg/SPARE", "shared"));
		buttonSpare.setGraphicSize(Std.int(buttonSpare.width * 2));
		buttonSpare.antialiasing = false;
		buttonSpare.setPosition(buttonDef.x + buttonDef.width + 10, y);
		add(buttonSpare);
	}
	public function buttons(string: String, ?int: Int = 0) {
		switch (string) {
			case "add":
				initButtons();

			case "die":
				// buttonFight.visible = false;
				// buttonSpare.visible = false;
				// buttonAct.visible = false;
				// buttonItem.visible = false;
				// buttonDef.visible = false;

			case "live":
				// buttonFight.visible = true;
				// buttonDef.visible = true;
				// buttonItem.visible = true;
				// buttonSpare.visible = true;
				// buttonAct.visible = true;

			case "select":
				curButton += int;

				if (curButton == -1)
					curButton = 4;
				if (curButton == 5)
					curButton = 0;

				switch (curButton) {
					case 0:
						remove(buttonFight);
						buttonFight = new FlxSprite().loadGraphic(Paths.image("rpg/FIGHT_Selected", "shared"));
						buttonFight.setGraphicSize(Std.int(buttonFight.width * 2));
						buttonFight.updateHitbox();
						buttonFight.antialiasing = false;
						buttonFight.setPosition(openStat.getGraphicMidpoint().x - 20, openStat.y);
						add(buttonFight);
					case 1:
						remove(buttonAct);
						buttonAct = new FlxSprite().loadGraphic(Paths.image("rpg/ACT_Selcted", "shared"));
						buttonAct.setGraphicSize(Std.int(buttonAct.width * 2));
						buttonAct.updateHitbox();
						buttonAct.antialiasing = false;
						buttonAct.setPosition(openStat.getGraphicMidpoint().x - 10, openStat.y);
						add(buttonAct);
					case 2:
						remove(buttonItem);
						buttonItem = new FlxSprite().loadGraphic(Paths.image("rpg/ITEM_Selected", "shared"));
						buttonItem.setGraphicSize(Std.int(buttonAct.width * 2));
						buttonItem.updateHitbox();
						buttonItem.setPosition(openStat.getGraphicMidpoint().x, openStat.y);
						add(buttonItem);
					case 3:
						remove(buttonDef);
						buttonDef = new FlxSprite().loadGraphic(Paths.image("rpg/DEFEND_Selected", "shared"));
						buttonDef.setGraphicSize(Std.int(buttonDef.width * 2));
						buttonDef.updateHitbox();
						buttonDef.setPosition(openStat.getGraphicMidpoint().x + 10, openStat.y);
						buttonDef.antialiasing = false;
						add(buttonDef);
					case 4:
						remove(buttonSpare);
						buttonSpare = new FlxSprite().loadGraphic(Paths.image("rpg/SPARE_Selected", "shared"));
						buttonSpare.setGraphicSize(Std.int(buttonSpare.width * 2));
						buttonSpare.antialiasing = false;
						buttonSpare.setPosition(openStat.getGraphicMidpoint().x + 20, openStat.y);
						add(buttonSpare);
				}
		}
	}
}