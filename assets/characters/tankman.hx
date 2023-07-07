function create()
{
	character.frames = Paths.getSparrowAtlas("week7/tankmanCaptain");

	character.animation.addByPrefix('idle', "Tankman Idle Dance", 24, false);
	character.animation.addByPrefix('singUP', 'Tankman UP note ', 24, false);
	character.animation.addByPrefix('singDOWN', 'Tankman DOWN note ', 24, false);
	character.animation.addByPrefix('singRIGHT', 'Tankman Right Note ', 24, false);
	character.animation.addByPrefix('singLEFT', 'Tankman Note Left ', 24, false);

	character.animation.addByPrefix('prettyGood', 'PRETTY GOOD', 24, false);
	character.animation.addByPrefix('ugh', 'TANKMAN UGH', 24, false);

	character.addOffset("idle", 0, 0);
	character.addOffset("singLEFT", 91, -25);
	character.addOffset("singDOWN", 68, -106);
	character.addOffset("ugh", -14, -8);
	character.addOffset("singRIGHT", -23, -11);
	character.addOffset("singUP", 27, 58);
	character.addOffset("prettyGood", 101, 15);

	character.facesLeft = true;
	character.playAnim('idle');

    character.characterColor = 0xFF171717;
}