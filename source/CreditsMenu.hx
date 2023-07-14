package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import title.TitleScreen;

class CreditsMenu extends MusicBeatState
{
	private var grpCredits:FlxTypedGroup<Alphabet>;
	var credits:Array<String> = ['504brandon', 'Bam'];
    override public function create():Void
    {
		openfl.Lib.current.stage.frameRate = 144;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
		add(bg);
        FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);
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