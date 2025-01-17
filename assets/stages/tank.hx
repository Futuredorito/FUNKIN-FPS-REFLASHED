import flixel.math.FlxAngle;

var tankmanRun:Array<TankmenBG>;
// var gfCutsceneLayer:FlxGroup;
// var bfTankCutsceneLayer:FlxGroup;
var tankWatchtower:BGSprite;
var tankGround:BGSprite;
var tankResetShit:Bool = false;
var tankMoving:Bool = false;
var tankAngle:Float = FlxG.random.int(-90, 45);
var tankSpeed:Float = FlxG.random.float(5, 7);
var tankX:Float = 400;

function create()
{
	curStage = 'tank';
	defaultCamZoom = 0.90;

	var bg:BGSprite = new BGSprite('week7/stage/tankSky', -400, -400, 0, 0);
	add(bg);

	var tankSky:BGSprite = new BGSprite('week7/stage/tankClouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 0.1, 0.1);
	tankSky.active = true;
	tankSky.velocity.x = FlxG.random.float(5, 15);
	add(tankSky);

	var tankMountains:BGSprite = new BGSprite('week7/stage/tankMountains', -300, -20, 0.2, 0.2);
	tankMountains.setGraphicSize(Std.int(tankMountains.width * 1.2));
	tankMountains.updateHitbox();
	add(tankMountains);

	var tankBuildings:BGSprite = new BGSprite('week7/stage/tankBuildings', -200, 0, 0.30, 0.30);
	tankBuildings.setGraphicSize(Std.int(tankBuildings.width * 1.1));
	tankBuildings.updateHitbox();
	add(tankBuildings);

	var tankRuins:BGSprite = new BGSprite('week7/stage/tankRuins', -200, 0, 0.35, 0.35);
	tankRuins.setGraphicSize(Std.int(tankRuins.width * 1.1));
	tankRuins.updateHitbox();
	add(tankRuins);

	var smokeLeft:BGSprite = new BGSprite('week7/stage/smokeLeft', -200, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
	add(smokeLeft);

	var smokeRight:BGSprite = new BGSprite('week7/stage/smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
	add(smokeRight);

	tankWatchtower = new BGSprite('week7/stage/tankWatchtower', 100, 50, 0.5, 0.5, ['watchtower gradient color']);
	add(tankWatchtower);

	tankGround = new BGSprite('week7/stage/tankRolling', 300, 300, 0.5, 0.5, ['BG tank w lighting'], true);
	add(tankGround);

	tankmanRun = [];
	add(tankmanRun);

	var tankGround:BGSprite = new BGSprite('week7/stage/tankGround', -420, -150);
	tankGround.setGraphicSize(Std.int(tankGround.width * 1.15));
	tankGround.updateHitbox();
	add(tankGround);

	moveTank();

	// smokeLeft.screenCenter();

	var fgTank0:BGSprite = new BGSprite('week7/stage/tank0', -500, 650, 1.7, 1.5, ['fg']);
	foregroundSprites.add(fgTank0);

	var fgTank1:BGSprite = new BGSprite('week7/stage/tank1', -300, 750, 2, 0.2, ['fg']);
	foregroundSprites.add(fgTank1);

	// just called 'foreground' just cuz small inconsistency no bbiggei
	var fgTank2:BGSprite = new BGSprite('week7/stage/tank2', 450, 940, 1.5, 1.5, ['foreground']);
	foregroundSprites.add(fgTank2);

	var fgTank4:BGSprite = new BGSprite('week7/stage/tank4', 1300, 900, 1.5, 1.5, ['fg']);
	foregroundSprites.add(fgTank4);

	var fgTank5:BGSprite = new BGSprite('week7/stage/tank5', 1620, 700, 1.5, 1.5, ['fg']);
	foregroundSprites.add(fgTank5);

	var fgTank3:BGSprite = new BGSprite('week7/stage/tank3', 1300, 1200, 3.5, 2.5, ['fg']);
	foregroundSprites.add(fgTank3);
}

function createPost()
{
	gf.y += 10;
	gf.x -= 30;
	boyfriend.x += 40;
	dad.y += 60;
	dad.x -= 80;
	gf.x -= 170;
	gf.y -= 75;

	if (gf.curCharacter == "pico-speaker")
	{
		TankmenBG.loadMappedAnims("picospeaker", PlayState.SONG.song.toLowerCase());

		var tempTankman:TankmenBG = new TankmenBG(20, 500, true);
		tempTankman.strumTime = 10;
		tempTankman.resetShit(20, 600, true);
		add(tempTankman);
		tankmanRun.push(tempTankman);

		for (i in 0...TankmenBG.animationNotes.length)
		{
			if (FlxG.random.bool(16))
			{
				var tankman:TankmenBG = tempTankman;
				tankman.strumTime = TankmenBG.animationNotes[i][0];
				tankman.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
				add(tankman);
				tankmanRun.push(tankman);
			}
		}
	}
}

function update(elapsed)
{
	moveTank();
}

function moveTank():Void
{
	if (!inCutscene)
	{
		var daAngleOffset:Float = 1;
		tankAngle += FlxG.elapsed * tankSpeed;
		tankGround.angle = tankAngle - 90 + 15;

		tankGround.x = tankX + Math.cos(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1500;
		tankGround.y = 1300 + Math.sin(FlxAngle.asRadians((tankAngle * daAngleOffset) + 180)) * 1100;
	}
}