import flixel.util.FlxTimer;

var limo:FlxSprite;
var fastCar:FlxSprite;
var fastCarCanDrive:Bool = true;

function create()
{
	defaultCamZoom = 0.90;

	var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image("week4/limo/limoSunset"));
	skyBG.scrollFactor.set(0.1, 0.1);
	add(skyBG);

	var bgLimo:FlxSprite = new FlxSprite(-200, 480);
	bgLimo.frames = Paths.getSparrowAtlas("week4/limo/bgLimo");
	bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
	bgLimo.animation.play('drive');
	bgLimo.scrollFactor.set(0.4, 0.4);
	add(bgLimo);

	for (i in 0...5)
	{
		var dancer = new FlxSprite((370 * i) + 130, bgLimo.y - 400);
		dancer.scrollFactor.set(0.4, 0.4);
		dancer.frames = Paths.getSparrowAtlas("week4/limo/limoDancer");
		dancer.animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		dancer.animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		dancer.animation.play('danceLeft');
		dancer.antialiasing = true;
	    add(dancer);
	}

	limo = new FlxSprite(-120, 550);
	limo.frames = Paths.getSparrowAtlas("week4/limo/limoDrive");
	limo.animation.addByPrefix('drive', "Limo stage", 24);
	limo.animation.play('drive');
	limo.antialiasing = true;

	fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image("week4/limo/fastCarLol"));

    boyfriend.y -= 220;
	boyfriend.x += 260;
}

function createPost(){
    add(limo);
    add(fastCar);
    resetFastCar();
}

function beatHit(){
    if (FlxG.random.bool(10) && fastCarCanDrive)
        fastCarDrive();
}


function resetFastCar()
{
    fastCar.x = -12600;
    fastCar.y = FlxG.random.int(140, 250);
    fastCar.velocity.x = 0;
    fastCarCanDrive = true;
}

function fastCarDrive()
{
    FlxG.sound.play(Paths.sound('carPass' + FlxG.random.int(0, 1)), 0.7);

    fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
    fastCarCanDrive = false;
    new FlxTimer().start(2, function(tmr:FlxTimer)
    {
        resetFastCar();
    });
}