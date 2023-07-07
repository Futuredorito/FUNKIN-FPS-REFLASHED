function create()
{
	character.frames = Paths.getPackerAtlas("week6/spirit");
	character.animation.addByPrefix('idle', "idle spirit_", 24, false);
	character.animation.addByPrefix('singUP', "up_", 24, false);
	character.animation.addByPrefix('singRIGHT', "right_", 24, false);
	character.animation.addByPrefix('singLEFT', "left_", 24, false);
	character.animation.addByPrefix('singDOWN', "spirit down_", 24, false);

	character.addOffset('idle', -220, -280);
	character.addOffset('singUP', -220, -238);
	character.addOffset("singRIGHT", -220, -280);
	character.addOffset("singLEFT", -202, -280);
	character.addOffset("singDOWN", 170, 110);

	character.setGraphicSize(Std.int(character.width * 6));
	character.updateHitbox();

	character.playAnim('idle');

	character.antialiasing = false;

    character.characterColor = 0xFFFF3C6E;
}