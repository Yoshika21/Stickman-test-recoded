package objects;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import backend.Character;

class Bullet extends FlxSprite
{
	public static var instance:Bullet;

	public var gun:Gun;
	public var enemy:Character;
	public var shrub:FlxSprite;

	var speed:Float = 900;
	var activeShot:Bool = false;

	public function new(gun:Gun, enemy:Character, shrub:FlxSprite)
	{
		super();

		this.gun = gun;
		this.enemy = enemy;
		this.shrub = shrub;

		loadGraphic("assets/images/objects/gun/bullet.png");
		visible = false;
		exists = false;

		scrollFactor.set();
	}

	// --------------------------------------------------
	// Init (called from Gun)
	// --------------------------------------------------

	public static function init():Void
	{
		if (instance != null)
			instance.fire();
	}

	function fire():Void
	{
		if (activeShot)
			return;

		// Can't shoot if player hidden behind shrubs
		if (gun.owner.overlaps(shrub))
			return;

		activeShot = true;
		exists = true;
		visible = true;

		// Spawn relative to gun
		x = gun.x - 397;
		y = gun.y - 18;

		// Direction towards enemy
		var dir = enemy.x > x ? 1 : -1;
		velocity.x = speed * dir;
	}

	// --------------------------------------------------
	// Update
	// --------------------------------------------------

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!activeShot)
			return;

		// Hit enemy
		if (overlaps(enemy))
		{
			hitEnemy();
		}

		// Out of screen cleanup
		if (x < -width || x > FlxG.width + width)
		{
			resetBullet();
		}
	}

	// --------------------------------------------------
	// Hit logic
	// --------------------------------------------------

	public static function hitEnemy(enemy:Character, shrub:FlxSprite):Bool
	{
		resetBullet();

		// Damage
		if (!Reflect.hasField(enemy, "health"))
			enemy.health = 200;

		enemy.health -= 50;

		// Red flash overlay
		enemy.color = FlxColor.RED;
		FlxTween.color(
			enemy,
			0.25,
			FlxColor.RED,
			FlxColor.WHITE
		);

		// Enemy death
		if (enemy.health <= 0)
		{
			enemy.kill();
		}
	}

	function resetBullet():Void
	{
		activeShot = false;
		exists = false;
		visible = false;
		velocity.set();
	}

	override public function destroy():Void
	{
		gun = null;
		enemy = null;
		shrub = null;
		super.destroy();
	}
}
