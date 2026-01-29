package backend;

#if desktop
import hxwindowmode.WindowColorMode;

class Window
{
	// Apply the default Stickman window style
	public static function apply():Void
	{
		// Enable dark mode
		WindowColorMode.setDarkMode();

		// Window
		WindowColorMode.setWindowBorderColor(
			[138, 43, 226],
			true,
			true
		);

		// Dark title
		WindowColorMode.setWindowTitleColor(
			[30, 30, 30]
		);

		// Rounded corners
		WindowColorMode.setWindowCornerType(0);

		// Force redraw
		WindowColorMode.redrawWindowHeader();
	}

	/**
	 * public static function reset():Void
	 * {
	 * 	WindowColorMode.setLightMode();
	 * 	WindowColorMode.redrawWindowHeader();
	}
	*/
	#end
}
