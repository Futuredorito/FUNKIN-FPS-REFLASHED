function create()
{
	character.frames = Paths.getSparrowAtlas('week7/bfHoldingGF-DEAD');
	character.animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
	character.animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
	character.animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);
	character.animation.play('firstDeath');

	character.addOffset('firstDeath', 37, 14);
	character.addOffset('deathLoop', 37, -3);
	character.addOffset('deathConfirm', 37, 28);
	character.playAnim('firstDeath');

	character.facesLeft = true;
}
