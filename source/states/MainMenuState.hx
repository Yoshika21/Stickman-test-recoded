package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import backend.Transition;
import Sys;

class MainMenuState extends FlxState
{
	var buttons:Array<FlxSprite> = [];
	var selectedIndex:Int = 0;

	// Android double-click
	var lastClick:Array<Float> = [];
	static inline var DOUBLE_CLICK_TIME:Float = 0.35;

	override public function create():Void
	{
		super.create();

		// Backgrounds
		add(bg("blue_sky"));
		add(bg("clouds_1"));
		add(bg("water"));
		add(bg("ground"));
		add(bg("mountains_with_stroke"));

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
		addButton("start", FlxG.height * 0.52);
		addButton("achievements", FlxG.height * 0.64);
		addButton("quit", FlxG.height * 0.76);

		updateSelection();
		Transition.fadeIn();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if desktop
		handleKeyboard();
		#end

		handlePointerInput();
	}

	// --------------------------------------------------
	// Input
	// --------------------------------------------------

	function handleKeyboard():Void
	{
		if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT)
			changeSelection(-1);

		if (FlxG.keys.justPressed.D || FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.S)
			changeSelection(1);

		if (FlxG.keys.justPressed.ENTER)
			activateSelection();
	}

	function handlePointerInput():Void
	{
		for (i in 0...buttons.length)
		{
			var btn = buttons[i];
			var hovering =
				FlxG.mouse.overlaps(btn) ||
				touchOverlaps(btn);

			if (!hovering)
				continue;

			setSelection(i);

			if (FlxG.mouse.justPressed || FlxG.touches.justStarted().length > 0)
			{
				var now = FlxG.game.ticks / 1000;
				if (now - lastClick[i] <= DOUBLE_CLICK_TIME)
					activateSelection();
				lastClick[i] = now;
			}
		}
	}

	// --------------------------------------------------
	// Selection logic
	// --------------------------------------------------

	function changeSelection(dir:Int):Void
	{
		selectedIndex = (selectedIndex + dir + buttons.length) % buttons.length;
		updateSelection();
	}

	function setSelection(i:Int):Void
	{
		if (selectedIndex != i)
		{
			selectedIndex = i;
			updateSelection();
		}
	}

	function updateSelection():Void
	{
		for (i in 0...buttons.length)
		{
			buttons[i].animation.play(
				i == selectedIndex ? "selected" : "idle"
			);
		}
	}

	function activateSelection():Void
	{
		switch (selectedIndex)
		{
			case 0: // Start
				Transition.switchState(new PlayState());

			case 1: // Achievements
				Transition.switchState(new AchievementsMenuState());

			case 2: // Quit
				Sys.exit(0);
		}
	}

	// --------------------------------------------------
	// Helpers
	// --------------------------------------------------

	function addButton(name:String, yPos:Float):Void
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

		add(btn);
		buttons.push(btn);
		lastClick.push(-1);
	}

	function bg(name:String):FlxSprite
	{
		var spr = new FlxSprite();
		spr.loadGraphic('assets/images/menus/main/$name.png');
		return spr;
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
