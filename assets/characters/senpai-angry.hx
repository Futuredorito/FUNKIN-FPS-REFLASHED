function create()
{
	character.frames = Paths.getSparrowAtlas("week6/senpai");
	character.animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
	character.animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
	character.animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
	character.animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", 6, 36);
	character.addOffset("singRIGHT");
	character.addOffset("singLEFT", 24, 6);
	character.addOffset("singDOWN", 6, 6);
	character.playAnim('idle');

	character.setGraphicSize(Std.int(character.width * 6));
	character.updateHitbox();

	character.antialiasing = false;

    character.characterColor = 0xFFFFAA6F;

	character.x += 150;
	character.y += 360;
}