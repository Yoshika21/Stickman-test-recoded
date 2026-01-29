package backend;

import flixel.system.FlxBasePreloader;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Lib;

@:bitmap("setup/art/preloadArt.png")
class PreloadImage extends BitmapData {}

class StickmanPreloader extends FlxBasePreloader
{
	var logo:Sprite;

	public function new(MinDisplayTime:Float = 3, ?AllowedURLs:Array<String>)
	{
		super(MinDisplayTime, AllowedURLs);
	}

	override function create():Void
	{
		_width  = Lib.current.stage.stageWidth;
		_height = Lib.current.stage.stageHeight;

		// Base scale relative to 2560px wide screens
		var ratio:Float = _width / 2560;

		// --- Logo ---
		logo = new Sprite();
		logo.addChild(new Bitmap(new PreloadImage()));

		logo.scaleX = ratio;
		logo.scaleY = ratio;

		centerLogo();
		addChild(logo);

		super.create();
	}

	override function update(percent:Float):Void
	{
		if (percent < 69)
		{
			var delta:Float = percent / 1920;

			logo.scaleX += delta;
			logo.scaleY += delta;

			logo.x -= percent * 0.6;
			logo.y -= percent * 0.5;
		}
		else
		{
			var finalScale:Float = _width / 1280;

			logo.scaleX = finalScale;
			logo.scaleY = finalScale;

			centerLogo();
		}

		super.update(percent);
	}

	override function destroy():Void
	{
		logo = null;
		super.destroy();
	}

	// --------------------------------------------------
	// Helpers
	// --------------------------------------------------

	inline function centerLogo():Void
	{
		logo.x = (_width - logo.width) * 0.5;
		logo.y = (_height - logo.height) * 0.5;
	}
}
