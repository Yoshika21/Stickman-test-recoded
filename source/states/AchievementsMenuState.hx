package states;

import flixel.FlxState;
import backend.AchievementsLoader;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import flixel.input.keyboard.FlxKey;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;

class AchievementsMenuState extends FlxState
{
	var achievementNames:Array<String>;
	var index:Int = 0;

	var btnLeft:FlxSprite;
	var btnRight:FlxSprite;

	// Android back button
	var backBtn:FlxSprite;
	var backText:FlxText;

	override public function create():Void
	{
		super.create();

		// Ensure achievements are loaded
		AchievementsLoader.loadAchievements();

		achievementNames = [];
		for (k in AchievementsLoader.achievements.keys())
			achievementNames.push(k);

		if (achievementNames.length == 0)
			return;

		AchievementsLoader.currentAchievement = achievementNames[index];

		add(new AchievementsUI());
		createButtons();
		createAndroidBack();
	}

	function createButtons():Void
	{
		// Left Button
		btnLeft = new FlxSprite(40, FlxG.height / 2);
		btnLeft.frames = Paths.getSparrowAtlas(
			"menus/achievements/buttons/button_left"
		);
		btnLeft.animation.addByPrefix("idle", "buttonleft idle", 24, true);
		btnLeft.animation.addByPrefix("anim", "buttonleft anim", 24, false);
		btnLeft.animation.play("idle");
		btnLeft.y -= btnLeft.height / 2;
		add(btnLeft);

		// Right Button
		btnRight = new FlxSprite(
			FlxG.width - 200,
			FlxG.height / 2
		);
		btnRight.frames = Paths.getSparrowAtlas(
			"menus/achievements/buttons/button_right"
		);
		btnRight.animation.addByPrefix("idle", "buttonright idle", 24, true);
		btnRight.animation.addByPrefix("anim", "buttonright anim", 24, false);
		btnRight.animation.play("idle");
		btnRight.y -= btnRight.height / 2;
		add(btnRight);
	}

	function createAndroidBack():Void
	{
		if (!FlxG.onMobile)
			return;

		backBtn = new FlxSprite()
			.makeGraphic(90, 60, FlxColor.RED);
		backBtn.alpha = 0.6;
		backBtn.x = FlxG.width - backBtn.width - 20;
		backBtn.y = FlxG.height - backBtn.height - 20;
		add(backBtn);

		backText = new FlxText(
			backBtn.x,
			backBtn.y + 12,
			backBtn.width,
			"B"
		);
		backText.setFormat(
			"assets/fonts/VCR.ttf",
			24,
			FlxColor.RED,
			CENTER,
			FlxColor.BLACK
		);
		add(backText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Desktop Controls
		if (!FlxG.onMobile)
		{
			if (FlxG.keys.justPressed.A || FlxG.keys.justPressed.LEFT)
				previousAchievement();

			if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.RIGHT)
				nextAchievement();

			if (FlxG.keys.justPressed.B)
				goBack();
		}
		else
		{
			// Mobile Controls
			if (FlxG.mouse.justPressed)
			{
				if (btnLeft.overlapsPoint(FlxG.mouse.getWorldPosition()))
					previousAchievement();

				if (btnRight.overlapsPoint(FlxG.mouse.getWorldPosition()))
					nextAchievement();

				if (backBtn != null
					&& backBtn.overlapsPoint(FlxG.mouse.getWorldPosition()))
					goBack();
			}
		}
	}

	function previousAchievement():Void
	{
		btnLeft.animation.play("anim", true);

		index--;
		if (index < 0)
			index = achievementNames.length - 1;

		changeAchievement();
	}

	function nextAchievement():Void
	{
		btnRight.animation.play("anim", true);

		index++;
		if (index >= achievementNames.length)
			index = 0;

		changeAchievement();
	}

	function changeAchievement():Void
	{
		AchievementsLoader.currentAchievement = achievementNames[index];
	}

	function goBack():Void
	{
		Transition.switchState(new MainMenuState());
	}
}
