package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import backend.Transition;
import Sys;

class MainMenuState extends FlxState
{
	var startBtn:FlxSprite;
	var quitBtn:FlxSprite;
	var errorText:FlxText;

	// 0 = start, 1 = quit
	var selectedIndex:Int = 0;

	override public function create():Void
	{
		super.create();

		// Background layers
		add(bg("blue_sky"));
		add(bg("clouds_1"));
		add(bg("water"));
		add(bg("ground"));
		add(bg("mountains_with_stroke"));

		// Waterfall
		var waterfall = new FlxSprite();
		waterfall.frames = FlxAtlasFrames.fromSparrow(
			"assets/images/menus/main/waterfall.png",
			"assets/images/menus/main/waterfall.xml"
		);
		waterfall.animation.addByPrefix("loop", "waterfalling", 24, true);
		waterfall.animation.play("loop");
		add(waterfall);

		add(bg("clouds_2"));

		// Buttons
		startBtn = createButton("start", FlxG.height * 0.55);
		add(startBtn);

		quitBtn = createButton("quit", startBtn.y + 120);
		add(quitBtn);

		// Error text
		errorText = new FlxText(
			10, 10, FlxG.width - 20,
			"Error: PlayState is still unfinished, you're unable to play the full game yet."
		);
		errorText.setFormat(
			null, 16, FlxColor.RED, LEFT,
			FlxTextBorderStyle.OUTLINE, FlxColor.BLACK
		);
		errorText.alpha = 0;
		add(errorText);

		updateSelection();
		Transition.fadeIn();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Navigate LEFT / A → Start
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A)
		{
			selectedIndex = 0;
			updateSelection();
		}

		// Navigate RIGHT / D → Quit
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D)
		{
			selectedIndex = 1;
			updateSelection();
		}

		// Confirm
		if (FlxG.keys.justPressed.ENTER)
		{
			if (selectedIndex == 0)
				confirmStart();
			else
				confirmQuit();
		}
	}

	// --------------------------------------------------
	// Selection visuals
	// --------------------------------------------------

	function updateSelection():Void
	{
		startBtn.animation.play(
			selectedIndex == 0 ? "selected" : "idle"
		);
		quitBtn.animation.play(
			selectedIndex == 1 ? "selected" : "idle"
		);
	}

	// --------------------------------------------------
	// Actions
	// --------------------------------------------------

	function confirmStart():Void
	{
		FlxG.sound.play("assets/sounds/cancel.ogg");
		showErrorMessage();
	}

	function confirmQuit():Void
	{
		var snd = FlxG.sound.play("assets/sounds/confirm.ogg");
		snd.onComplete = function()
		{
			Sys.exit(0);
		};
	}

	// --------------------------------------------------
	// Error message
	// --------------------------------------------------

	function showErrorMessage():Void
	{
		if (errorText.alpha > 0)
			return;

		errorText.alpha = 1;
		FlxTween.tween(
			errorText,
			{ alpha: 0 },
			10,
			{ ease: FlxEase.linear }
		);
	}

	// --------------------------------------------------
	// Helpers
	// --------------------------------------------------

	function bg(name:String):FlxSprite
	{
		var spr = new FlxSprite();
		spr.loadGraphic('assets/images/menus/main/$name.png');
		return spr;
	}

	function createButton(name:String, yPos:Float):FlxSprite
	{
		var btn = new FlxSprite();
		btn.frames = FlxAtlasFrames.fromSparrow(
			'assets/images/menus/main/options/$name.png',
			'assets/images/menus/main/options/$name.xml'
		);
		btn.animation.addByPrefix("idle", '$name idle', 0, false);
		btn.animation.addByPrefix("selected", '$name selected', 0, false);
		btn.animation.play("idle");
		btn.screenCenter(X);
		btn.y = yPos;
		return btn;
	}
}
