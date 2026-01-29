package states.sub;

import flixel.FlxSubState;
import flixel.FlxSprite;
import states.PlayState;
import states.MainMenuState;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.input.touch.FlxTouch;
import flixel.sound.FlxSound;
import backend.Transition;

class GameOverSubstate extends FlxSubState
{
	var bg:FlxSprite;

	override public function create():Void
	{
		super.create();

		// bg img
		bg = new FlxSprite(0, 0);

		#if android
		bg.loadGraphic("assets/images/gameOver/overA.png");
		#else
		bg.loadGraphic("assets/images/gameOver/over.png");
		#end

		bg.scrollFactor.set();
		bg.screenCenter();
		add(bg);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// desktop input
		#if desktop
		if (FlxG.keys.justPressed.ENTER)
		{
			confirm();
		}

		if (FlxG.keys.justPressed.B || FlxG.keys.justPressed.SPACE)
		{
			cancel();
		}
		#end

		// droid input
		#if android
		if (FlxG.android.justPressed.BACK)
		{
			cancel();
		}

		// Touch screen
		if (FlxG.touches.justReleased().length > 0)
		{
			confirm();
		}
		#end
	}

	// actions
	function confirm():Void
	{
		FlxG.sound.play("assets/sounds/confirm.ogg");

		Transition.switchState(
			new PlayState()
		);
	}

	function cancel():Void
	{
		FlxG.sound.play("assets/sounds/cancel.ogg");

		Transition.switchState(
			new MainMenuState()
		);
	}

	override public function destroy():Void
	{
		bg = null;
		super.destroy();
	}
}
