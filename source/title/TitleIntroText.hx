package title;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import openfl.Assets;

using StringTools;

class TitleIntroText extends MusicBeatState
{
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		useDefaultTransIn = false;
		useDefaultTransOut = false;

		UIStateExt.defaultTransIn = transition.data.ScreenWipeIn;
		UIStateExt.defaultTransInArgs = [1.2];
		UIStateExt.defaultTransOut = transition.data.ScreenWipeOut;
		UIStateExt.defaultTransOutArgs = [0.6];

		FlxG.mouse.visible = false;
		FlxG.sound.muteKeys = null;

		FlxG.save.bind('data');
		Highscore.load();
		config.KeyBinds.keyCheck();
		PlayerSettings.init();

		PlayerSettings.player1.controls.loadKeyBinds();
		config.Config.configCheck();

		#if sys
		polymod.Polymod.init({
			modRoot: "mods",
			dirs: sys.FileSystem.readDirectory('./mods'),
			errorCallback: (e) ->
			{
				trace(e.message);
			},
			frameworkParams: {
				assetLibraryPaths: [
					"songs" => "assets/songs",
					"images" => "assets/images",
					"data" => "assets/data",
					"fonts" => "assets/fonts",
					"sounds" => "assets/sounds",
					"music" => "assets/music",
				]
			}
		});
		#end

		#if sys
		HScript.parser = new hscript.Parser();
		HScript.parser.allowJSON = true;
		HScript.parser.allowMetadata = true;
		HScript.parser.allowTypes = true;
		HScript.parser.preprocesorValues = [
			"desktop" => #if (desktop) true #else false #end,
			"windows" => #if (windows) true #else false #end,
			"mac" => #if (mac) true #else false #end,
			"linux" => #if (linux) true #else false #end,
			"debugBuild" => #if (debug) true #else false #end
		];
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		Conductor.changeBPM(102);
		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.8);
		TitleScreen.titleMusic = "freakyMenu";

		var http = new haxe.Http("https://raw.githubusercontent.com/504brandon/FUNKIN-FPS-REFLASHED/master/update.txt?token=GHSAT0AAAAAACC42UPSDIM2Z6J56PIUVOUSZEJR6GA");

		http.onData = function(data:String)
		{
			trace(data.split('\n')[0].trim());
		}

		http.onError = function(error)
		{
			trace('error: $error');
		}

		http.request();
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.text("introText"));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		switch (curBeat)
		{
			case 1:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er', 'Rozebud']);
			case 3:
				deleteCoolText();
				addMoreText('present');
			case 5:
				deleteCoolText();
				addMoreText('In association');
			case 6:
				addMoreText('with');
			case 7:
				addMoreText('newgrounds');
				ngSpr.visible = true;
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			case 9:
				createCoolText([curWacky[0]]);
			case 11:
				addMoreText(curWacky[1]);
			case 12:
				deleteCoolText();
				addMoreText('Friday');
			case 13:
				addMoreText('Night');
			case 14:
				addMoreText('Funkin');
			case 15:
				addMoreText('FPS PLUS');
			case 16:
				skipIntro();
		}
	}

	function skipIntro():Void
	{
		switchState(new TitleScreen());
	}
}
