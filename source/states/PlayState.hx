package states;

import flixel.FlxState;
import Sys;

class PlayState extends FlxState
{
	override function create():Void
	{
		super.create();

		// As soon as PlayState starts, close the app
		Sys.exit(0);
	}
}
