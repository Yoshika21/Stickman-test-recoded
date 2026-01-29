package backend;

import openfl.Assets;
import haxe.Json;
import haxe.ds.StringMap;

typedef AchievementData = {
	var icon:String;
	var description:String;
}

class AchievementsLoader
{
	public static var achievements:StringMap<AchievementData> = new StringMap();
	public static var unlocked:StringMap<Bool> = new StringMap();

	public static var currentAchievement:String;

	// -------------------------
	// Load achievements JSON
	// -------------------------
	public static function loadAchievements():Void
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

		// default selection
		if (currentAchievement == null && achievements.keys().hasNext())
			currentAchievement = achievements.keys().next();
	}

	// -------------------------
	// Unlock callback
	// -------------------------
	public static function unlockAchievement(name:String):Void
	{
		if (!unlocked.exists(name))
		{
			trace('[Achievements] Unknown achievement: ' + name);
			return;
		}

		if (unlocked.get(name))
			return;

		unlocked.set(name, true);
		currentAchievement = name;

		trace('[Achievements] Unlocked: ' + name);
	}
}
