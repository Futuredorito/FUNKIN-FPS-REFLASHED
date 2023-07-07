function create()
{
	character.frames = Paths.getSparrowAtlas('week7/bfAndGF');
	character.animation.addByPrefix('idle', 'BF idle dance', 24, false);
	character.animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
	character.animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
	character.animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
	character.animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);

	character.animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
	character.animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
	character.animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
	character.animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
	character.animation.addByPrefix('bfCatch', 'BF catches GF', 24, false);

	character.addOffset("idle", 0, 0);
	character.addOffset("singUP", -29, 10);
	character.addOffset("singRIGHT", -41, 23);
	character.addOffset("singLEFT", 12, 7);
	character.addOffset("singDOWN", -10, -10);
	character.addOffset("singUPmiss", -29, 10);
	character.addOffset("singRIGHTmiss", -41, 23);
	character.addOffset("singLEFTmiss", 12, 7);
	character.addOffset("singDOWNmiss", -10, -10);
	character.addOffset("bfCatch", 0, 0);

	character.playAnim('idle');

	character.facesLeft = true;

	character.deathCharacter = "bf-holding-gf-dead";
	character.iconName = "bf";
	character.characterColor = 0xFF31B0D1;
}