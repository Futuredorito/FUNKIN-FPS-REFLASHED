function create()
{
	character.frames = Paths.getSparrowAtlas("alphamouse_assets");
	character.animation.addByPrefix('idle', 'Idle', 24, false);
	character.animation.addByPrefix('singUP', 'Up', 24, false);
	character.animation.addByPrefix('singLEFT', 'Left', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Right', 24, false);
	character.animation.addByPrefix('singDOWN', 'Down', 24, false);

	character.addOffset('idle', -101,70);
	character.addOffset("singUP", 17,74);
	character.addOffset("singRIGHT", 1, 430);
	character.addOffset("singLEFT", 250, 89);
	character.addOffset("singDOWN", -21,-58);
	character.playAnim('idle');

	character.facesLeft = true;

	character.iconName = "face";
    character.characterColor = 0xFF31B0D1;
}
