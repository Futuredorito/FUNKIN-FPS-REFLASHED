import flixel.sound.FlxSound;

var light:FlxSprite;
var lightColors:Array<Int> = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFD4531, 0xFFFBA633];
var phillyTrain:FlxSprite;
var trainSound:FlxSound;

function create()
{
	var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('week3/philly/sky'));
	bg.scrollFactor.set(0.1, 0.1);
	add(bg);

	var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('week3/philly/city'));
	city.scrollFactor.set(0.3, 0.3);
	city.setGraphicSize(Std.int(city.width * 0.85));
	city.updateHitbox();
	add(city);

	light = new FlxSprite(city.x).loadGraphic(Paths.image('week3/philly/window'));
	light.antialiasing = false;
	light.scrollFactor.set(0.3, 0.3);
	light.setGraphicSize(Std.int(light.width * 0.85));
	light.updateHitbox();
	light.color = lightColors[FlxG.random.int(0, lightColors.length - 1)];
	add(light);

	var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('week3/philly/behindTrain'));
	add(streetBehind);

	phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('week3/philly/train'));
	add(phillyTrain);

	trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
	FlxG.sound.list.add(trainSound);

	var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('week3/philly/street'));
	add(street);
}

function update(elapsed)
{
	if (trainMoving)
	{
		trainFrameTiming += elapsed;

		if (trainFrameTiming >= 1 / 24)
		{
			updateTrainPos();
			trainFrameTiming = 0;
		}
	}
}

function beatHit()
{
	if (PlayState.instance.totalBeats % 4 == 0)
	{
		light.color = lightColors[FlxG.random.int(0, lightColors.length - 1)];
	}

	if (!trainMoving)
		trainCooldown += 1;

	if (totalBeats % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
	{
		trainCooldown = FlxG.random.int(-4, 0);
		trainStart();
	}
}

var trainMoving:Bool = false;
var trainFrameTiming:Float = 0;
var trainCars:Int = 8;
var trainFinishing:Bool = false;
var trainCooldown:Int = 0;

function trainStart():Void
{
	trainMoving = true;
	if (!trainSound.playing)
		trainSound.play(true);
}

var startedMoving:Bool = false;

function updateTrainPos():Void
{
	if (trainSound.time >= 4700)
	{
		startedMoving = true;
		gf.playAnim('hairBlow');
	}

	if (startedMoving)
	{
		phillyTrain.x -= 400;

		if (phillyTrain.x < -2000 && !trainFinishing)
		{
			phillyTrain.x = -1150;
			trainCars -= 1;

			if (trainCars <= 0)
				trainFinishing = true;
		}

		if (phillyTrain.x < -4000 && trainFinishing)
			trainReset();
	}
}

function trainReset():Void
{
	gf.playAnim('hairFall');
	phillyTrain.x = FlxG.width + 200;
	trainMoving = false;
	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
}
