function create()
{
	character.frames = Paths.getSparrowAtlas("week6/senpai");
	character.animation.addByPrefix('idle', 'Senpai Idle', 24, false);
	character.animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
	character.animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
	character.animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
	character.animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", 12, 36);
	character.addOffset("singRIGHT", 6);
	character.addOffset("singLEFT", 30);
	character.addOffset("singDOWN", 12);

	character.playAnim('idle');

	character.setGraphicSize(Std.int(character.width * 6));
	character.updateHitbox();

	character.antialiasing = false;

	character.characterColor = 0xFFFFAA6F;

	character.x += 150;
	character.y += 360;
}