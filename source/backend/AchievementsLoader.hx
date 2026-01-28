package backend;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxAxes;
import openfl.Assets;
import haxe.Json;
import haxe.ds.StringMap;

typedef AchievementData = {
	var icon:String;
	var description:String;
}

class AchievementsLoader extends FlxState
{
	public static var achievements:StringMap<AchievementData> = new StringMap();
	public static var unlocked:StringMap<Bool> = new StringMap();

	public static var currentAchievement:String;

	// Create Callback
	public static function unlockAchievement(name:String):Void
	{
		if (!unlocked.exists(name))
		{
			trace('[Achievements] Unknown achievement: ' + name);
			return;
		}

		unlocked.set(name, true);
		trace('[Achievements] Unlocked: ' + name);
	}

	override public function create():Void
	{
		super.create();

		loadAchievements();

		// pick first achievement if none selected
		if (currentAchievement == null)
			currentAchievement = achievements.keys().next();

		// Bg Image
		add(new FlxSprite(0, 0, "assets/images/menus/achievements/bg.png"));

		// Dark Overlay
		var overlay = new FlxSprite().makeGraphic(
			FlxG.width,
			FlxG.height,
			FlxColor.BLACK
		);
		overlay.alpha = 0.6;
		add(overlay);

		var isUnlocked = unlocked.get(currentAchievement);
		var data = achievements.get(currentAchievement);

		// Icon
		var iconPath:String = isUnlocked
			? 'assets/images/menus/achievements/icons/${data.icon}.png'
			: 'assets/images/menus/achievements/unknown_achievement.png';

		var icon = new FlxSprite(0, 0, iconPath);
		icon.screenCenter();
		add(icon);

		// Achievement Name
		var nameBG = new FlxSprite()
			.makeGraphic(400, 40, FlxColor.fromRGB(20, 40, 120));
		nameBG.screenCenter(FlxAxes.X);
		nameBG.y = icon.y - 55;
		add(nameBG);

		var nameText = new FlxText(
			nameBG.x,
			nameBG.y + 6,
			nameBG.width,
			isUnlocked ? currentAchievement : "?"
		);
		nameText.setFormat(
			"assets/fonts/VCR.ttf",
			18,
			FlxColor.WHITE,
			CENTER
		);
		add(nameText);

		// Description BG
		var descBG = new FlxSprite()
			.makeGraphic(500, 60, FlxColor.RED);
		descBG.screenCenter(FlxAxes.X);
		descBG.y = icon.y + icon.height + 15;
		add(descBG);

		// Description txt
		var descText = new FlxText(
			descBG.x + 10,
			descBG.y + 10,
			descBG.width - 20,
			isUnlocked ? data.description : "?"
		);
		descText.setFormat(
			"assets/fonts/VCR.ttf",
			16,
			FlxColor.WHITE,
			CENTER
		);
		add(descText);
	}

	// Loading the json file that contains the achievements
	static function loadAchievements():Void
	{
		if (!Assets.exists("assets/data/achievements.json"))
		{
			trace("[Achievements] achievements.json not found!");
			return;
		}

		var raw = Assets.getText("assets/data/achievements.json");
		var json:Dynamic = Json.parse(raw);

		for (name in Reflect.fields(json.achievements))
		{
			var entry = Reflect.field(json.achievements, name);

			achievements.set(name, {
				icon: entry.icon,
				description: entry.description
			});

			if (!unlocked.exists(name))
				unlocked.set(name, false);
		}
	}
}
