function create()
{
	curStage = 'schoolEvil';

	var posX = 400;
	var posY = 200;

	var bg:FlxSprite = new FlxSprite(posX, posY);
	bg.frames = Paths.getSparrowAtlas("week6/weeb/animatedEvilSchool");
	bg.animation.addByPrefix('idle', 'background 2', 24);
	bg.animation.play('idle');
	bg.scrollFactor.set(0.8, 0.9);
	bg.scale.set(6, 6);
	add(bg);
}

function createPost() {
    boyfriend.x += 200;
    boyfriend.y += 220;
    gf.x += 180;
    gf.y += 300;
}