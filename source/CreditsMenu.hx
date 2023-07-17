package;

import lime.utils.Assets;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import title.TitleScreen;

typedef CreditsJson = {
	var credits:Array<String>;
	var links:Array<String>;
}

class CreditsMenu extends MusicBeatState
{
	private var grpCredits:FlxTypedGroup<Alphabet>;
	var creditsShit:Array<String> = [];
	var creditsLinks:Array<String> = [];
	public static var curSelected:Int = 0;

    override public function create()
    {
		openfl.Lib.current.stage.frameRate = 144;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
		add(bg);

        FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);

		var creds:CreditsJson = Json.parse(Assets.getText(Paths.json('baseCredits')));

		for (cred in creds.credits)
			creditsShit.push(cred);

		for (credLink in creds.links)
			creditsLinks.push(credLink);

		grpCredits = new FlxTypedGroup<Alphabet>();
		add(grpCredits);

        for (i in 0...creditsShit.length)
		{
			var credText:Alphabet = new Alphabet(0, (70 * i) + 30, creditsShit[i], true, false);
			credText.isMenuItem = true;
			credText.targetY = i;
			grpCredits.add(credText);
		}
		FlxG.sound.music.pitch = 0.7;
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
		if (accepted) {
			trace(creditsShit[curSelected]);
		}
        if (controls.BACK) {
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
			curSelected = creditsShit.length - 1;
		if (curSelected >= creditsShit.length)
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