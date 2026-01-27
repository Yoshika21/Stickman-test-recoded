package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class Transition
{
	public static var overlay:FlxSprite;
	public static var loading:FlxSprite;
	public static var active:Bool = false;

	// Fade out and switch state
	public static function switchState(next:FlxState, ?duration:Float = 0.6):Void
	{
		if (active) return;
		active = true;

		// Black overlay
		overlay = new FlxSprite()
			.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.scrollFactor.set();
		overlay.alpha = 0;
		FlxG.state.add(overlay);

		// Loading Image
		loading = new FlxSprite();
		loading.loadGraphic("assets/images/menus/loading.png");
		loading.screenCenter();
		loading.scrollFactor.set();
		loading.alpha = 0;
		FlxG.state.add(loading);

		// Fade out
		FlxTween.tween(overlay, { alpha: 1 }, duration, {
			ease: FlxEase.quadOut
		});

		FlxTween.tween(loading, { alpha: 1 }, duration, {
			ease: FlxEase.quadOut,
			onComplete: function(_) {
				FlxG.switchState(() -> next);
			}
		});
	}

	// Fade in (when new state)
	public static function fadeIn(?duration:Float = 0.6):Void
	{
		if (overlay == null) return;

		overlay.alpha = 1;
		loading.alpha = 1;

		FlxG.state.add(overlay);
		FlxG.state.add(loading);

		FlxTween.tween(overlay, { alpha: 0 }, duration, {
			ease: FlxEase.quadIn,
			onComplete: function(_) {
				cleanup();
			}
		});

		FlxTween.tween(loading, { alpha: 0 }, duration, {
			ease: FlxEase.quadIn
		});
	}

	// Cleanup
	static function cleanup():Void
	{
		if (overlay != null)
		{
			overlay.kill();
			overlay.destroy();
			overlay = null;
		}

		if (loading != null)
		{
			loading.kill();
			loading.destroy();
			loading = null;
		}

		active = false;
	}
}
