function create()
{
	character.frames = Paths.getSparrowAtlas("week4/Mom_Assets");
	character.animation.addByPrefix('idle', "Mom Idle", 24, false);
	character.animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
	character.animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
	character.animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
	// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
	// CUZ DAVE IS DUMB!
	character.animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

	character.addOffset('idle');
	character.addOffset("singUP", -1, 81);
	character.addOffset("singRIGHT", 21, -54);
	character.addOffset("singLEFT", 250, -23);
	character.addOffset("singDOWN", 20, -157);

	character.playAnim('idle');

    character.characterColor = 0xFFD8558E;
}
