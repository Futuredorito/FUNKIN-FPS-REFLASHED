var halloweenBG:FlxSprite;

function create()
{
	halloweenBG = new FlxSprite(-200, -100);
	halloweenBG.frames = Paths.getSparrowAtlas("week2/halloween_bg");
	halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	halloweenBG.animation.play('idle');
	halloweenBG.antialiasing = true;
	add(halloweenBG);
}

function lightningStrikeShit():Void
{
	FlxG.sound.play(Paths.sound('thunder_' + FlxG.random.int(1, 2)));
	halloweenBG.animation.play('lightning');

	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);

	for (boyfriend in bfs)
		boyfriend.playAnim('scared', true);

	gf.playAnim('scared', true);
}

var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function beatHit()
{
	if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
	{
		lightningStrikeShit();
	}
}
