package;

import lime.utils.Assets;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import title.TitleScreen;

typedef CreditsArray =
{
	var credit:String;
	var link:String;
}

typedef CreditsJson =
{
	var credits:Array<CreditsArray>;
}

class CreditsMenu extends MusicBeatState
{
	private var grpCredits:FlxTypedGroup<Alphabet>;
	var credits:Array<String> = [];
	var creditsLink:Array<String> = [];
	var curSelected:Int = 0;
	var creds:CreditsJson;

	override public function create()
	{
		creds = Json.parse(Assets.getText(Paths.json('baseCredits')));

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
		add(bg);

		FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);

		for (cred in creds.credits)
		{
			credits.push(cred.credit);
			creditsLink.push(cred.link);
		}

		grpCredits = new FlxTypedGroup<Alphabet>();
		add(grpCredits);

		for (i in 0...credits.length)
		{
			var credText:Alphabet = new Alphabet(0, (70 * i) + 30, credits[i], true, false);
			credText.isMenuItem = true;
			credText.targetY = i;
			grpCredits.add(credText);
		}
		FlxG.sound.music.pitch = 0.7;

		changeSelection();

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}
		if (accepted)
		{
			FlxG.openURL(creditsLink[curSelected]);
		}
		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = credits.length - 1;
		if (curSelected >= credits.length)
			curSelected = 0;

		var bullShit:Int = 0;
		for (item in grpCredits.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}