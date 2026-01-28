package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import backend.Transition;

class TitleState extends FlxState
{
	var logo:FlxSprite;
	var key:FlxSprite;
	var pressed:Bool = false;

	override public function create():Void
	{
		super.create();

		// Music
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic("assets/music/title.ogg", 1, true);
		}

		// Background
		var bg:FlxSprite = FlxGradient.createGradientFlxSprite(
			FlxG.width,
			FlxG.height,
			[
				FlxColor.fromRGB(255, 0, 0),
				FlxColor.fromRGB(0, 255, 0),
				FlxColor.fromRGB(0, 0, 255)
			],
			1,
			90
		);
		bg.scrollFactor.set();
		add(bg);

		// Logo
		logo = new FlxSprite("assets/images/menus/title/logo.png");
		logo.screenCenter(X);
		logo.y = 40;
		logo.alpha = 0;
		add(logo);

		// Key image
		key = new FlxSprite("assets/images/menus/title/key.png");
		key.scale.set(1.5, 1.5);
		key.updateHitbox();
		key.screenCenter(X);
		key.y = FlxG.height - key.height - 40;
		key.alpha = 0;
		add(key);

		// Fade in
		FlxTween.tween(logo, { alpha: 1 }, 0.8, { ease: FlxEase.quadOut });
		FlxTween.tween(key, { alpha: 1 }, 0.8, {
			ease: FlxEase.quadOut,
			startDelay: 0.2
		});

		Transition.fadeIn();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (pressed)
			return;

		var activated:Bool = false;

		// Mouse click (Windows)
		if (FlxG.mouse.justPressed)
			activated = true;

		// Keyboard
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
			activated = true;

		if (activated)
		{
			pressed = true;

			// Fade music
			if (FlxG.sound.music != null)
				FlxG.sound.music.fadeOut(0.4);

			// Play confirm sound and wait for it to finish
			var confirm:FlxSound = FlxG.sound.play(
				"assets/sounds/confirm.ogg"
			);

			confirm.onComplete = function()
			{
				Transition.switchState(new MainMenuState());
			};
		}
	}
}
