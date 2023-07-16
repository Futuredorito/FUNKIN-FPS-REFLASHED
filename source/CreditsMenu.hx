package;

import lime.utils.Assets;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import title.TitleScreen;

typedef CreditsJson = {
	var credits:Array<String>;
}

class CreditsMenu extends MusicBeatState
{
	private var grpCredits:FlxTypedGroup<Alphabet>;
	var creditsShit:Array<String> = [];

    override public function create()
    {
		openfl.Lib.current.stage.frameRate = 144;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
		add(bg);

        FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);

		var creds:CreditsJson = Json.parse(Assets.getText(Paths.json('baseCredits')));

		for (cred in creds.credits)
			creditsShit.push(cred);

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
        if (controls.BACK) {
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			switchState(new MainMenuState());
        }

        super.update(elapsed);
    }
}