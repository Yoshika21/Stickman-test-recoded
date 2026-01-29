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

		instance = this;

		loadGraphic("assets/images/objects/gun/bullet.png");
		visible = false;
		exists = false;

		scrollFactor.set();
	}

	// Called by Gun
	public static function init():Void
	{
		if (instance != null)
			instance.fire();
	}

	function fire():Void
	{
		if (activeShot)
			return;

		if (gun.owner.overlaps(shrub))
			return;

		activeShot = true;
		exists = true;
		visible = true;

		x = gun.x - 397;
		y = gun.y - 18;

		var dir = enemy.x > x ? 1 : -1;
		velocity.x = speed * dir;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!activeShot)
			return;

		if (overlaps(enemy))
		{
			hitEnemy(enemy, shrub);
		}

		if (x < -width || x > FlxG.width + width)
		{
			resetBullet();
		}
	}

	public function hitEnemy(enemy:Character, shrub:FlxSprite):Bool
	{
		resetBullet();

		if (!Reflect.hasField(enemy, "health"))
			enemy.health = 200;

		enemy.health -= 50;

		enemy.color = FlxColor.RED;
		FlxTween.color(enemy, 0.25, FlxColor.RED, FlxColor.WHITE);

		if (enemy.health <= 0)
		{
			enemy.kill();
			return true;
		}

		return false;
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
