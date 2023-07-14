function create()
{
	character.frames = Paths.getSparrowAtlas("week6/bfPixel");
	character.animation.addByPrefix('idle', 'BF IDLE', 24, false);
	character.animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
	character.animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
	character.animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
	character.animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
	character.animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
	character.animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
	character.animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
	character.animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);
	character.animation.addByPrefix('scared', 'BF SPOOK', 24, false);
	character.animation.addByPrefix('hey', 'BF HEY!!', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", -6);
	character.addOffset("singRIGHT");
	character.addOffset("singLEFT", -12);
	character.addOffset("singDOWN");
	character.addOffset("singUPmiss", -6);
	character.addOffset("singRIGHTmiss");
	character.addOffset("singLEFTmiss", -12);
	character.addOffset("singDOWNmiss");

	character.setGraphicSize(Std.int(character.width * 6));
	character.updateHitbox();

	character.playAnim('idle');

	character.width -= 100;
	character.height -= 100;

	character.antialiasing = false;

	character.deathCharacter = "bf-pixel-dead";

	character.facesLeft = true;

    character.characterColor = 0xFF7BD6F6;
}
