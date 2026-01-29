package mobile.objects.buttons;

#if android
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import backend.Character;

class Crouch extends FlxSprite
{
	public var target:Character;
	public var shrub:FlxSprite;

	var crouched:Bool = false;

	public function new(target:Character, shrub:FlxSprite)
	{
		super(310, 261);

		this.target = target;
		this.shrub = shrub;

		loadGraphic("assets/images/objects/buttons/crouch.png");
		setGraphicSize(Std.int(width * 0.51));
		updateHitbox();
		scrollFactor.set();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (touch in FlxG.touches.list)
		{
			if (
				touch.justPressed &&
				overlapsPoint(FlxPoint.get(touch.screenX, touch.screenY))
			)
			{
				// Only allow crouch if near shrub
				if (!target.overlaps(shrub))
					return;

				toggleCrouch();
				break;
			}
		}
	}

	function toggleCrouch():Void
	{
		crouched = !crouched;

		if (crouched)
		{
			// Hide
			target.alpha = 0;

			// Disable actions
			target.canMove = false;
			target.canShoot = false;
		}
		else
		{
			// Show
			target.alpha = 1;

			// Enable actions
			target.canMove = true;
			target.canShoot = true;
			#end
		}
	}
}
