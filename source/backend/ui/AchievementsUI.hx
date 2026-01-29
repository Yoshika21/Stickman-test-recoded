package backend.ui;

import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import backend.AchievementsLoader;

class AchievementsUI extends FlxGroup
{
	public function new()
	{
		super();

		var name = AchievementsLoader.currentAchievement;
		var data = AchievementsLoader.achievements.get(name);
		var isUnlocked = AchievementsLoader.unlocked.get(name);

		// Background
		add(new FlxSprite(0, 0, "assets/images/menus/achievements/bg.png"));

		// Dark overlay
		var overlay = new FlxSprite()
			.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlay.alpha = 0.6;
		add(overlay);

		// Icon
		var iconPath = isUnlocked
			? 'assets/images/menus/achievements/icons/${data.icon}.png'
			: 'assets/images/menus/achievements/unknown_achievement.png';

		var icon = new FlxSprite(0, 0, iconPath);
		icon.screenCenter();
		add(icon);

		// Name
		var nameBG = new FlxSprite()
			.makeGraphic(400, 40, FlxColor.fromRGB(20, 40, 120));
		nameBG.screenCenter(FlxAxes.X);
		nameBG.y = icon.y - 55;
		add(nameBG);

		var nameText = new FlxText(
			nameBG.x,
			nameBG.y + 6,
			nameBG.width,
			isUnlocked ? name : "?"
		);
		nameText.setFormat("assets/fonts/VCR.ttf", 18, FlxColor.WHITE, CENTER);
		add(nameText);

		// Description
		var descBG = new FlxSprite()
			.makeGraphic(500, 60, FlxColor.RED);
		descBG.screenCenter(FlxAxes.X);
		descBG.y = icon.y + icon.height + 15;
		add(descBG);

		var descText = new FlxText(
			descBG.x + 10,
			descBG.y + 10,
			descBG.width - 20,
			isUnlocked ? data.description : "?"
		);
		descText.setFormat("assets/fonts/VCR.ttf", 16, FlxColor.WHITE, CENTER);
		add(descText);
	}
}
