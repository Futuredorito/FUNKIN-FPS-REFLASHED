function create()
{
	character.frames = Paths.getSparrowAtlas("week2/Monster_Assets");
	character.animation.addByPrefix('idle', 'monster idle', 24, false);
	character.animation.addByPrefix('singUP', 'monster up note', 24, false);
	character.animation.addByPrefix('singDOWN', 'monster down', 24, false);
	character.animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", -23, 87);
	character.addOffset("singRIGHT", -51, 15);
	character.addOffset("singLEFT", -31, 4);
	character.addOffset("singDOWN", -63, -86);
	character.playAnim('idle');

    character.characterColor = 0xFFF3FF6E;

	character.y += 100;
}
