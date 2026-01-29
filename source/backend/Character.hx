package backend;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxCollision;
import haxe.Json;
import states.sub.GameOverSubstate;
import openfl.Assets;

class Character extends FlxSprite
{
	public var canMove:Bool = true;
	public var canShoot:Bool = true;
	public var charName:String;
	public var isEnemy:Bool = false;

	public function new(x:Float, y:Float, jsonName:String, isEnemy:Bool = false)
	{
		super(x, y);

		this.isEnemy = isEnemy;
		charName = jsonName;

		loadFromJson(jsonName);
	}

	function loadFromJson(name:String):Void
	{
		var jsonPath = 'assets/data/characters/' + name + '.json';
		var raw = Assets.getText(jsonPath);
		var data:Dynamic = Json.parse(raw);

		// Load Spr
		var img:String = data.charInfo.imagePath;
		loadGraphic(
			'assets/images/characters/' + img + '.png',
			true
		);

		if (Assets.exists('assets/images/characters/' + img + '.xml'))
		{
			frames = flixel.graphics.frames.FlxAtlasFrames.fromSparrow(
				'assets/images/characters/' + img + '.png',
				'assets/images/characters/' + img + '.xml'
			);
		}

		// Scale
		scale.set(
			data.charInfo.scale[0],
			data.charInfo.scale[1]
		);

		// Zoom 54%
		setGraphicSize(Std.int(width * 0.54));
		updateHitbox();

		// Anims
		for (animName in Reflect.fields(data.charAnims))
		{
			var anim = Reflect.field(data.charAnims, animName);

			animation.addByPrefix(
				animName,
				anim.name,
				anim.fps,
				anim.loop
			);
		}

		animation.play("idle");

		// Flip enemy
		if (isEnemy)
		{
			flipX = true;
		}
	}

	// Collision
	public function checkEnemyCollision(enemy:Character, shrub:FlxSprite):Void
	{
		if (!enemy.visible || !visible)
			return;

		// If enemy hidden behind shrub, ignore
		if (enemy.overlaps(shrub))
			return;

		if (this.overlaps(enemy))
		{
			FlxG.switchState(new GameOverSubstate());
		}
	}
}
