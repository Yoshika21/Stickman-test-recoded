package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.sound.FlxSound;
import backend.Character;
import backend.Transition;
import objects.Gun;
import objects.Bullet;
import backend.AchievementsLoader; // Prevent possible bad error

#if android
import mobile.objects.buttons.Joystick;
import mobile.objects.buttons.Crouch;
import mobile.objects.buttons.GunButton;
#end

class PlayState extends FlxState
{
	// World
	var shrub:FlxSprite;

	// Characters
	var player:Character;
	var enemy:Character;

	// Objects
	var gun:Gun;

	#if android
	var joystick:Joystick;
	var crouchBtn:Crouch;
	var gunBtn:GunButton;
	#end

	// Game logic
	var enemyKilled:Bool = false;
	var finished:Bool = false;

	override public function create():Void
	{
		super.create();

		// Backgrounds
		add(bg("blue_sky")); // 1
		add(bg("clouds"));  // 2
		add(bg("ground"));  // 3

		shrub = bg("shrubs"); // 4
		add(shrub);

		// Characters
		player = new Character(-540, 21, "you", false);
		add(player);

		enemy = new Character(-540, 21, "enemy", true);
		add(enemy);

		// Gun
		gun = new Gun(player);
		add(gun);

		// Mobile controls
		#if android
		joystick = new Joystick(player);
		add(joystick);

		crouchBtn = new Crouch(player, shrub);
		add(crouchBtn);

        gunBtn = new GunButton(gun, player);
        add(gunBtn);
		#end

		Transition.fadeIn();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Enemy collision - Game Over
		player.checkEnemyCollision(enemy, shrub);

		// Bullet hit logic
		if (Bullet.instance != null && Bullet.instance.hitEnemy(enemy, shrub))
		{
			if (!enemyKilled)
			{
				enemyKilled = true;
				AchievementsLoader.unlockAchievement("Congrats 4 Killin'");
			}
		}

		// Win condition
		if (!finished && player.x > FlxG.width)
		{
			finished = true;
			onFinish();
		}
	}

	// Finish Game
	function onFinish():Void
	{
		AchievementsLoader.unlockAchievement("Thanks for playing");

		var congrats = new FlxSprite();
		congrats.loadGraphic("assets/images/congrats.png");
		congrats.screenCenter();
		add(congrats);

		FlxG.sound.play("assets/sounds/yay.ogg");

		FlxG.camera.fade(FlxColor.BLACK, 1.5, false, function()
		{
			Transition.switchState(new MainMenuState());
		});
	}

	// Helpers
	function bg(name:String):FlxSprite
	{
		var spr = new FlxSprite();
		spr.loadGraphic('assets/images/stages/main/$name.png');
		spr.scrollFactor.set();
		return spr;
	}
}
