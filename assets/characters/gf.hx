function create()
{
	character.frames = Paths.getSparrowAtlas("GF_assets");
	character.animation.addByPrefix('cheer', 'GF Cheer', 24, false);
	character.animation.addByPrefix('singLEFT', 'GF left note', 24, false);
	character.animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
	character.animation.addByPrefix('singUP', 'GF Up Note', 24, false);
	character.animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
	character.animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
	character.animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
	character.animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
	character.animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
	character.animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
	character.animation.addByPrefix('scared', 'GF FEAR', 24);

	character.addOffset('cheer');
	character.addOffset('sad', -2, -21);
	character.addOffset('danceLeft', 0, -9);
	character.addOffset('danceRight', 0, -9);
	character.addOffset("singUP", 0, 4);
	character.addOffset("singRIGHT", 0, -20);
	character.addOffset("singLEFT", 0, -19);
	character.addOffset("singDOWN", 0, -20);
	character.addOffset('hairBlow', 45, -8);
	character.addOffset('hairFall', 0, -9);
	character.addOffset('scared', -2, -17);
	character.playAnim('danceRight');

	character.characterColor = 0xFFA5004D;
}

var danced = false;

function dance()
{
	danced = !danced;

	if (danced)
		character.playAnim('danceRight', true);
	else
		character.playAnim('danceLeft', true);
}