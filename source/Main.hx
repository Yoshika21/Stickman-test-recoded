package;

import lime.app.Application;
import openfl.display.Sprite;
import flixel.FlxGame;
import states.TitleState;

class Main extends Application
{
	public function new()
	{
		super();
	}

	override function onWindowCreate():Void
	{
		super.onWindowCreate();

		// OpenFL root
		var root = new Sprite();
		window.stage.addChild(root);

		// Start Flixel
		var game = new FlxGame(
			0, 0,
			TitleState,
			60, 60,
			true
		);

		root.addChild(game);
	}
}
