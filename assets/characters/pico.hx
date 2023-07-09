function create()
{
	character.frames = Paths.getSparrowAtlas("week3/Pico_FNF_assetss");
	character.animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
	character.animation.addByPrefix('singUP', 'pico Up note0', 24, false);
	character.animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
	character.animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
	character.animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
	character.animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
	character.animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
	character.animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

	character.addOffset("singRIGHTmiss", -40, 49);
	character.addOffset("singDOWN", 92, -77);
	character.addOffset("singLEFTmiss", 82, 27);
	character.addOffset("singUP", 20, 29);
	character.addOffset("idle", 0, 0);
	character.addOffset("singDOWNmiss", 86, -37);
	character.addOffset("singRIGHT", -46, 1);
	character.addOffset("singLEFT", 86, -11);
	character.addOffset("singUPmiss", 26, 67);

	character.playAnim('idle');

	character.facesLeft = true;

    character.characterColor = 0xFFB7D855;
}
