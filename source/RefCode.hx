package;

//import utils.TextureUtil;
import flixel.FlxSprite;

class TestState extends MusicBeatState {
	override public function create() {
		super.create();


		sprite = new FlxSprite();
		sprite.frames = TextureUtil.fromI8Array([ { Source: Paths.image('darrly-idle'), Description: Paths.file('images/darrly-idle.json')}, { Source: Paths.image('darrly-gun'), Description: Paths.file('images/darrly-gun.json')} ]);
		// trace(sprite.frames.frames);
		sprite.animation.addByNames('idle', ["darrly-idle 0.gif", "darrly-idle 1.gif", "darrly-idle 2.gif", "darrly-idle 3.gif", "darrly-idle 4.gif", "darrly-idle 5.gif"], 10, false);
		sprite.animation.addByNames('gun', ["darrly-gun 0.gif", "darrly-gun 1.gif", "darrly-gun 2.gif", "darrly-gun 3.gif", "darrly-gun 4.gif", "darrly-gun 5.gif", "darrly-gun 6.gif", "darrly-gun 7.gif", "darrly-gun 8.gif", "darrly-gun 9.gif", "darrly-gun 10.gif"], 10, false);
		sprite.animation.play('idle');
		sprite.setGraphicSize(Std.int(sprite.width * 4));
		sprite.updateHitbox();
		sprite.screenCenter();
		add(sprite);
	}
	var sprite:FlxSprite;

	override public function update(dt:Float) {
		if (sprite.animation.curAnim.name == 'idle' && sprite.animation.finished)
			sprite.animation.play('gun');

		if (sprite.animation.curAnim.name == 'gun' && sprite.animation.finished)
			sprite.animation.play('idle');
		
		
		super.update(dt);
	}
}