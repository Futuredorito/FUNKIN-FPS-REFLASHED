function create()
{
	character.frames = Paths.getSparrowAtlas("week5/mom_dad_christmas_assets");
	character.animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
	character.animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
	character.animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
	character.animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

	character.animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

	character.animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
	character.animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
	character.animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", -47, 24);
	character.addOffset("singRIGHT", -1, -23);
	character.addOffset("singLEFT", -30, 16);
	character.addOffset("singDOWN", -31, -29);
	character.addOffset("singUP-alt", -47, 24);
	character.addOffset("singRIGHT-alt", -1, -24);
	character.addOffset("singLEFT-alt", -30, 15);
	character.addOffset("singDOWN-alt", -30, -27);

	character.playAnim('idle');

	character.iconName = "parents";
    character.characterColor = 0xFFAF66CE;

	character.x -= 500;
}
