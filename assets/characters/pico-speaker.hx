import TankmenBG;

function create()
{
	character.frames = Paths.getSparrowAtlas('week7/picoSpeaker');

	character.animation.addByPrefix('shoot1', "Pico shoot 1", 24, false);
	character.animation.addByPrefix('shoot2', "Pico shoot 2", 24, false);
	character.animation.addByPrefix('shoot3', "Pico shoot 3", 24, false);
	character.animation.addByPrefix('shoot4', "Pico shoot 4", 24, false);

	// here for now, will be replaced later for less copypaste
	character.addOffset("shoot3", 413, -64);
	character.addOffset("shoot1", 0, 0);
	character.addOffset("shoot4", 440, -19);
	character.addOffset("shoot2", 0, -128);

	character.playAnim('shoot1');

	character.iconName = "pico";

	character.x += 120;
	character.y -= 140;
}

function update(elapsed)
{
	if (TankmenBG.animationNotes.length > 0)
	{
		if (Conductor.songPosition > TankmenBG.animationNotes[0][0])
		{
			// trace('played shoot anim' + TankmenBG.animationNotes[0][1]);

			var shootAnim:Int = 1;

			if (TankmenBG.animationNotes[0][1] >= 2)
				shootAnim = 3;

			shootAnim += FlxG.random.int(0, 1);

			character.playAnim('shoot' + shootAnim, true);
			TankmenBG.animationNotes.shift();
		}
	}
}

function dance()
{
	character.playAnim('shoot1');
}