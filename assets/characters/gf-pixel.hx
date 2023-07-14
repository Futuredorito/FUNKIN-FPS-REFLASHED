function create()
{
	character.frames = Paths.getSparrowAtlas("week6/gfPixel");

	//dance animations
	character.animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
	character.animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

	//misc animations
	character.animation.addByPrefix('sad', 'GF CRYING', 24, false);
	character.animation.addByPrefix('hairBlow', 'GF HAIRWAVES', 24, false);
	character.animation.addByPrefix('hairFall', 'GF HAIRDOWN', 24, false);
	character.animation.addByPrefix('scared', 'GF SPOOK', 24, false);

	character.addOffset('danceLeft', 0);
	character.addOffset('danceRight', 0);
	character.addOffset('sad', 0);
	character.addOffset('hairBlow', 0);
	character.addOffset('hairFall', 0);
	character.addOffset('scared', 0);

	character.playAnim('danceRight');

	character.setGraphicSize(Std.int(character.width * PlayState.daPixelZoom));
	character.updateHitbox();
	character.antialiasing = false; 
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