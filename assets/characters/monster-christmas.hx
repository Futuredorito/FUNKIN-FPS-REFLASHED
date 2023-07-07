function create()
{
	character.frames = Paths.getSparrowAtlas("week5/monsterChristmas");
	character.animation.addByPrefix('idle', 'monster idle', 24, false);
	character.animation.addByPrefix('singUP', 'monster up note', 24, false);
	character.animation.addByPrefix('singDOWN', 'monster down', 24, false);
	character.animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", -21, 53);
	character.addOffset("singRIGHT", -51, 10);
	character.addOffset("singLEFT", -30, 7);
	character.addOffset("singDOWN", -52, -91);
	character.playAnim('idle');

	character.iconName = "monster";
    character.characterColor = 0xFFF3FF6E;
}