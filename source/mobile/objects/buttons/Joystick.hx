package mobile.objects.buttons;

#if android
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import backend.Character;

class Joystick extends FlxSprite
{
	public var thumb:FlxSprite;
	public var target:Character;

	// Default positions
	var basePos:FlxPoint;
	var thumbPos:FlxPoint;

	public function new(target:Character)
	{
		super(-490, 241);

		this.target = target;

		// Base joystick
		loadGraphic("assets/images/objects/buttons/joystick.png");
		setGraphicSize(Std.int(width * 0.61));
		updateHitbox();
		scrollFactor.set();

		basePos = new FlxPoint(x, y);

		// Thumb
		thumb = new FlxSprite(-490, 239);
		thumb.loadGraphic("assets/images/objects/buttons/joystick_thumb.png");
		thumb.setGraphicSize(Std.int(thumb.width * 0.63));
		thumb.updateHitbox();
		thumb.scrollFactor.set();

		thumbPos = new FlxPoint(thumb.x, thumb.y);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var touching:Bool = false;

		for (touch in FlxG.touches.list)
		{
			if (touch.pressed && overlapsPoint(
				FlxPoint.get(touch.screenX, touch.screenY)
			))
			{
				touching = true;

				// Move character (+5 X)
				target.x += 5;

				// Thumb follows finger
				thumb.x = touch.screenX - thumb.width * 0.5;
				thumb.y = touch.screenY - thumb.height * 0.5;
				break;
			}
		}

		// Reset thumb when released
		if (!touching)
		{
			thumb.x = thumbPos.x;
			thumb.y = thumbPos.y;
			#end
		}
	}
}

