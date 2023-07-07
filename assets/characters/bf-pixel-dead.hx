function create()
{
	character.frames = Paths.getSparrowAtlas("week6/bfPixelsDEAD");
	character.animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
	character.animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
	character.animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
	character.animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
	character.animation.play('firstDeath');

	character.addOffset('firstDeath');
	character.addOffset('deathLoop', -36);
	character.addOffset('deathConfirm', -36);
	character.playAnim('firstDeath');
	// pixel bullshit
	character.setGraphicSize(Std.int(character.width * 6));
	character.updateHitbox();
	character.antialiasing = false;
	character.facesLeft = true;
}