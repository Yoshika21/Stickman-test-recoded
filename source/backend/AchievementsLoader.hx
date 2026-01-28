package backend;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;

class AchievementsLoader extends FlxGroup
{
	public function new(achievementName:String)
	{
		super();

		loadAchievement(achievementName);
	}

	function loadAchievement(name:String):Void
	{
		if (!Assets.exists("assets/data/achievements.json"))
		{
			trace("Achievements JSON not found!");
			return;
		}

		var raw:String = Assets.getText("assets/data/achievements.json");
		var data:Dynamic = Json.parse(raw);

		if (data.achievements == null || !Reflect.hasField(data.achievements, name))
		{
			trace('Achievement "$name" not found!');
			return;
		}

		var entry = Reflect.field(data.achievements, name);
		var iconName:String = entry.icon;
		var desc:String = entry.description;

		// -----------------------------
		// ICON
		// -----------------------------
		var icon = new FlxSprite();
		icon.loadGraphic('assets/menus/achievements/$iconName.png');
		icon.scale.set(1.5, 1.5);
		icon.updateHitbox();
		icon.screenCenter();
		add(icon);

		// -----------------------------
		// TITLE (above icon)
		// -----------------------------
		var title = new FlxText(0, 0, FlxG.width, name, 32);
		title.setFormat(
			"assets/fonts/VCR.ttf",
			32,
			FlxColor.WHITE,
			CENTER,
			FlxTextBorderStyle.OUTLINE,
			FlxColor.BLUE
		);
		title.borderSize = 2;
		title.y = icon.y - title.height - 10;
		add(title);

		// -----------------------------
		// DESCRIPTION (below icon)
		// -----------------------------
		var description = new FlxText(0, 0, FlxG.width * 0.9, desc, 20);
		description.setFormat(
			"assets/fonts/VCR.ttf",
			20,
			FlxColor.WHITE,
			CENTER,
			FlxTextBorderStyle.OUTLINE,
			FlxColor.RED
		);
		description.borderSize = 2;
		description.screenCenter(X);
		description.y = icon.y + icon.height + 10;
		add(description);
	}
}
