package mobile.objects.buttons;

#if android
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import objects.Gun;
import backend.Character;

class GunButton extends FlxSprite
{
	public var gun:Gun;
	public var owner:Character;

	public function new(gun:Gun, owner:Character)
	{
		super(514, 208);

		this.gun = gun;
		this.owner = owner;

		loadGraphic("assets/images/objects/buttons/button_shot.png");

		// Zoom: 66%
		scale.set(0.66, 0.66);
		updateHitbox();

		scrollFactor.set();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (owner == null || !owner.exists || !owner.canShoot)
			return;

		for (touch in FlxG.touches.list)
		{
			if (
				touch.justPressed &&
				overlapsPoint(
					FlxPoint.get(touch.screenX, touch.screenY)
				)
			)
			{
				gun.shoot();
				break;
			}
		}
	}

	override public function destroy():Void
	{
		gun = null;
		owner = null;
		super.destroy();
		#end
	}
}
