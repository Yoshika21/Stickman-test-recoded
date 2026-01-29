package objects;

import flixel.FlxSprite;
import flixel.FlxG;
import backend.Character;

class Gun extends FlxSprite
{
	public var owner:Character;

	public function new(owner:Character)
	{
		super();

		this.owner = owner;

		// Load gun sprite
		loadGraphic("assets/images/objects/gun/gun.png");

		// Zoom: 19%
		scale.set(0.19, 0.19);
		updateHitbox();

		scrollFactor.set();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (owner == null || !owner.exists || !owner.visible)
			return;

		// -------------------------
		// Follow player character
		// -------------------------
		flipX = owner.flipX;

		if (!flipX)
		{
			x = owner.x - 442;
		}
		else
		{
			// When flipped, mirror position
			x = owner.x + owner.width - width + 442;
		}

		y = owner.y + 10;

		// -------------------------
		// Shooting (desktop only)
		// -------------------------
		#if desktop
		if (FlxG.mouse.justPressed)
		{
			shoot();
		}
		#end
	}

	function shoot():Void
	{
		Bullet.init();
	}

	override public function destroy():Void
	{
		owner = null;
		super.destroy();
	}
}
