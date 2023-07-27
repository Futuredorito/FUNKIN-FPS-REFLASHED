function create()
{
	character.frames = Paths.getSparrowAtlas("week2/spooky_kids_assets");
	character.animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
	character.animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
	character.animation.addByPrefix('singLEFT', 'note sing left', 24, false);
	character.animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
	character.animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
	character.animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

	character.addOffset('danceLeft');
	character.addOffset('danceRight');

	character.addOffset("singUP", -18, 25);
	character.addOffset("singRIGHT", -130, -14);
	character.addOffset("singLEFT", 124, -13);
	character.addOffset("singDOWN", -46, -144);

	character.playAnim('danceRight');

	character.characterColor = 0xFFD57E00;

	character.y += 200;
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