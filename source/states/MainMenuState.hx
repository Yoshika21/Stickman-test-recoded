package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import backend.Transition;
import Sys;

class MainMenuState extends FlxState
{
	// Buttons
	var startBtn:FlxSprite;
	var quitBtn:FlxSprite;

	// Error text
	var errorText:FlxText;

	// Double click logic
	var lastStartClick:Float = -1;
	var lastQuitClick:Float = -1;
	static inline var DOUBLE_CLICK_TIME:Float = 0.35;

	override public function create():Void
	{
		super.create();

		// --- Background layers ---
		add(bg("blue_sky"));
		add(bg("clouds_1"));
		add(bg("water"));
		add(bg("ground"));
		add(bg("mountains_with_stroke"));

		// --- Waterfall animation ---
		var waterfall = new FlxSprite();
		waterfall.frames = FlxAtlasFrames.fromSparrow(
			"assets/images/menus/main/waterfall.png",
			"assets/images/menus/main/waterfall.xml"
		);
		waterfall.animation.addByPrefix(
			"loop",
			"waterfalling",
			24,
			true
		);
		waterfall.animation.play("loop");
		add(waterfall);

		// Foreground clouds
		add(bg("clouds_2"));

		// --- Start button ---
		startBtn = createButton(
			"start",
			FlxG.height * 0.55
		);
		add(startBtn);

		// --- Quit button ---
		quitBtn = createButton(
			"quit",
			startBtn.y + 120
		);
		add(quitBtn);

		// --- Error text (hidden by default) ---
		errorText = new FlxText(
			10,
			10,
			FlxG.width - 20,
			"Error: PlayState is still unfinished, you're unable to play the full game yet."
		);
		errorText.setFormat(
			null,
			16,
			FlxColor.RED,
			LEFT,
			FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK
		);
		errorText.alpha = 0;
		add(errorText);

		Transition.fadeIn();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		handleButton(startBtn, true);
		handleButton(quitBtn, false);
	}

	// --------------------------------------------------
	// Button handling
	// --------------------------------------------------

	function handleButton(btn:FlxSprite, isStart:Bool):Void
	{
		var hovering:Bool =
			FlxG.mouse.overlaps(btn) ||
			touchOverlaps(btn);

		btn.animation.play(hovering ? "selected" : "idle");

		if (!hovering)
			return;

		if (FlxG.mouse.justPressed || FlxG.touches.justStarted().length > 0)
		{
			var now:Float = FlxG.game.ticks / 1000;

			if (isStart)
			{
				if (now - lastStartClick <= DOUBLE_CLICK_TIME)
					confirmStart();
				lastStartClick = now;
			}
			else
			{
				if (now - lastQuitClick <= DOUBLE_CLICK_TIME)
					confirmQuit();
				lastQuitClick = now;
			}
		}
	}

	// --------------------------------------------------
	// Confirm actions
	// --------------------------------------------------

	function confirmStart():Void
	{
		// Cancel sound
		FlxG.sound.play("assets/sounds/cancel.ogg");

		showErrorMessage();
	}

	function confirmQuit():Void
	{
		// Confirm sound, then exit when finished
		var snd = FlxG.sound.play("assets/sounds/confirm.ogg");
		snd.onComplete = function()
		{
			Sys.exit(0);
		};
	}

	// --------------------------------------------------
	// Error text logic
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
			{
				ease: FlxEase.linear
			}
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

	function touchOverlaps(spr:FlxSprite):Bool
	{
		for (touch in FlxG.touches.list)
		{
			if (
				touch.justPressed &&
				spr.overlapsPoint(
					FlxPoint.get(touch.screenX, touch.screenY)
				)
			)
				return true;
		}
		return false;
	}
}
