package;

import lime.app.Application;
import flixel.util.FlxStringUtil;
import flixel.math.FlxAngle;
import flixel.group.FlxGroup;
#if sys
import sys.FileSystem;
#end
import config.*;
import title.*;
import transition.data.*;
import lime.utils.Assets;
import flixel.math.FlxRect;
import openfl.system.System;
import flixel.input.keyboard.FlxKey;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Section.SwagSection;
import Song.SwagSong;
import Song.SongEvents;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var EVENTS:SongEvents;
	public static var loadEvents:Bool = true;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:String = 'normal';

	public static var returnLocation:String = "main";
	public static var returnSong:Int = 0;

	public var canHit:Bool = false;
	public var noMissCount:Int = 0;

	public static final spookySongs = ["spookeez", "south", "monster"];
	public static final phillySongs = ["pico", "philly", "blammed"];
	public static final limoSongs = ["satin-panties", "high", "milf"];
	public static final mallSongs = ["cocoa", "eggnog"];
	public static final evilMallSongs = ["winter-horrorland"];
	public static final schoolSongs = ["senpai", "roses"];
	public static final schoolScared = ["roses"];
	public static final evilSchoolSongs = ["thorns"];
	public static final pixelSongs = ["senpai", "roses", "thorns"];
	public static final tankSongs = ["ugh", "guns", "stress"];

	public var camFocus:String = "";
	public var camFollow:FlxObject;
	public var autoCam:Bool = true;
	public var autoZoom:Bool = true;
	public var autoUi:Bool = true;

	public var bopSpeed:Int = 1;

	public var sectionHasOppNotes:Bool = false;
	public var sectionHasBFNotes:Bool = false;
	public var sectionHaveNotes:Array<Array<Bool>> = [];

	public var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	// Wacky input stuff=========================
	public var skipListener:Bool = false;

	public var upTime:Int = 0;
	public var downTime:Int = 0;
	public var leftTime:Int = 0;
	public var rightTime:Int = 0;

	public var upPress:Bool = false;
	public var downPress:Bool = false;
	public var leftPress:Bool = false;
	public var rightPress:Bool = false;

	public var upRelease:Bool = false;
	public var downRelease:Bool = false;
	public var leftRelease:Bool = false;
	public var rightRelease:Bool = false;

	public var upHold:Bool = false;
	public var downHold:Bool = false;
	public var leftHold:Bool = false;
	public var rightHold:Bool = false;

	// End of wacky input stuff===================
	public var autoplay:Bool = false;
	public var usedAutoplay:Bool = false;

	public var invuln:Bool = false;
	public var invulnCount:Int = 0;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	public var curSection:Int = 0;

	public var strumLineNotes:FlxTypedGroup<FlxSprite>;
	public var playerStrums:FlxTypedGroup<FlxSprite>;
	public var enemyStrums:FlxTypedGroup<FlxSprite>;

	public var camZooming:Bool = true;
	public var curSong:String = "";

	public var health:Float = 1;

	public var combo:Int = 0;
	public var misses:Int = 0;
	public var accuracy:Float = 0.00;
	public var totalNotesHit:Float = 0;
	public var totalPlayed:Int = 0;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	public var timeBarBG:FlxSprite;

	public static var timeBar:FlxBar;

	var timeTxt:FlxText;

	public var timeBarTime:Float = 0;

	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOverlay:FlxCamera;

	public var eventList:Array<Dynamic> = [];

	public var comboUI:ComboPopup;

	public static final minCombo:Int = 10;

	var dialogue:Array<String> = [':bf:strange code', ':dad:>:]'];

	var foregroundSprites:FlxTypedGroup<BGSprite>;

	var talking:Bool = true;
	var songScore:Int = 0;
	var scoreTxt:FlxText;

	public static var campaignScore:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	var inCutscene:Bool = false;

	public static var sectionStart:Bool = false;
	public static var sectionStartPoint:Int = 0;
	public static var sectionStartTime:Float = 0;

	public var meta:SongMetaTags;

	var scripts:Array<HScript>;
	var stage:Stage;

	public static var ratingPsych:Array<Dynamic> = [
		['You Suck!', 0.2], // From 0% to 19%
		['Shit', 0.4], // From 20% to 39%
		['Bad', 0.5], // From 40% to 49%
		['Bruh', 0.6], // From 50% to 59%
		['Meh', 0.69], // From 60% to 68%
		['Nice', 0.7], // 69%
		['Good', 0.8], // From 70% to 79%
		['Great', 0.9], // From 80% to 89%
		['Sick!', 1], // From 90% to 99%
		['Perfect!!', 1] // The value on this one isn't used actually, since Perfect is always "1"
	];

	public static var sicks:Int = 0;
	public static var goods:Int = 0;
	public static var bads:Int = 0;
	public static var shits:Int = 0;

	var scoreTween:Bool = false;

	var dads:FlxTypedGroup<Character>;
	var bfs:FlxTypedGroup<Character>;

	public var maxHealth:Float = 2;

	public var maxNotes:Int = 0;
	public var notesHit:Int;

	public var canAutoEndSong:Bool = true;

	override public function create()
	{
		super.create();

		instance = this;
		FlxG.mouse.visible = false;
		PlayerSettings.gameControls();

		customTransIn = new ScreenWipeIn(1.2);
		customTransOut = new ScreenWipeOut(0.6);

		if (loadEvents)
		{
			if (Assets.exists("assets/data/" + SONG.song.toLowerCase() + "/events.json"))
			{
				trace("loaded events");
				trace(Paths.json(SONG.song.toLowerCase() + "/events"));
				EVENTS = Song.parseEventJSON(Assets.getText(Paths.json(SONG.song.toLowerCase() + "/events")));
			}
			else
			{
				trace("No events found");
				EVENTS = {
					events: []
				};
			}
		}

		for (i in EVENTS.events)
		{
			eventList.push([i[1], i[3]]);
		}

		eventList.sort(sortByEventStuff);

		if (Assets.exists(Paths.inst(SONG.song, 'Inst' + '-' + storyDifficulty)))
			FlxG.sound.cache(Paths.inst(SONG.song, 'Inst' + '-' + storyDifficulty));
		else
			FlxG.sound.cache(Paths.inst(SONG.song));

		if (Assets.exists(Paths.voices(SONG.song, 'Voices' + '-' + storyDifficulty)))
			FlxG.sound.cache(Paths.voices(SONG.song, 'Voices' + '-' + storyDifficulty));
		else
			FlxG.sound.cache(Paths.voices(SONG.song));

		for (i in 0...SONG.notes.length)
		{
			var array = [false, false];

			array[0] = sectionContainsBfNotes(i);
			array[1] = sectionContainsOppNotes(i);

			sectionHaveNotes.push(array);
		}

		canHit = !(Config.ghostTapType > 0);
		noMissCount = 0;
		invulnCount = 0;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOverlay = new FlxCamera();
		camOverlay.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camOverlay);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.changeBPM(SONG.bpm);
		Conductor.mapBPMChanges(SONG);

		foregroundSprites = new FlxTypedGroup<BGSprite>();

		if (Assets.exists(Paths.text(SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "Dialogue")))
		{
			try
			{
				dialogue = CoolUtil.coolTextFile(Paths.text(SONG.song.toLowerCase() + "/" + SONG.song.toLowerCase() + "Dialogue"));
			}
			catch (e)
			{
			}
		}

		curStage = '';

		var gfCheck:String = 'gf';

		if (SONG.gf == null)
		{
			switch (storyWeek)
			{
				case 4:
					gfCheck = 'gf-car';
				case 5:
					gfCheck = 'gf-christmas';
				case 6:
					gfCheck = 'gf-pixel';
				case 7:
					if (SONG.song.toLowerCase() == "stress")
					{
						gfCheck = 'pico-speaker';
					}
					else
					{
						gfCheck = 'gf-tankmen';
					}
			}

			SONG.gf = gfCheck;
		}

		gfCheck = SONG.gf;

		gf = new Character(400, 130, gfCheck);
		gf.scrollFactor.set(0.95, 0.95);

		var dadChar = SONG.player2;

		dad = new Character(100, 100, dadChar);

		var bfChar = SONG.player1;

		boyfriend = new Character(770, 450, bfChar, true);

		var stageCheck:String = 'stage';
		if (SONG.stage == null)
		{
			if (spookySongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'spooky';
			}
			else if (phillySongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'philly';
			}
			else if (limoSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'limo';
			}
			else if (mallSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'mall';
			}
			else if (evilMallSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'mallEvil';
			}
			else if (schoolSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'school';
			}
			else if (evilSchoolSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'schoolEvil';
			}
			else if (tankSongs.contains(SONG.song.toLowerCase()))
			{
				stageCheck = 'tank';
			}

			SONG.stage = stageCheck;
		}
		else
		{
			stageCheck = SONG.stage;
		}

		stage = new Stage(stageCheck, instance);
		add(stage);

		#if sys
		scripts = new Array<HScript>();

		for (allowed in HScript.allowedExtensions)
		{
			if (FileSystem.exists('./assets/data/${SONG.song.toLowerCase()}'))
				{
					for (i in FileSystem.readDirectory('./assets/data/${SONG.song.toLowerCase()}'))
					{
						if (i.contains(allowed))
						{
							var scriptrel:Array<String> = i.split('.');
	
							scriptrel.remove(allowed);
	
							var script:HScript = new HScript('data/' + SONG.song.toLowerCase() + '/' + scriptrel[0]);
	
							if (!script.isBlank && script.expr != null)
							{
								script.interp.scriptObject = this;
								script.setValue('add', add);
								script.interp.execute(script.expr);
							}
	
							scripts.push(script);
						}
					}
				}
	
			if (FileSystem.exists('./mods/${Assets.getText(Paths.text('modSelected'))}/data/${SONG.song}'))
			{
				for (i in FileSystem.readDirectory('./mods/${Assets.getText(Paths.text('modSelected'))}/data/${SONG.song}'))
				{
					if (i.contains(allowed))
					{
						var scriptrel:Array<String> = i.split('.');

						scriptrel.remove(allowed);

						var script:HScript = new HScript('data/' + SONG.song + '/' + scriptrel[0]);

						if (!script.isBlank && script.expr != null)
						{
							script.interp.scriptObject = this;
							script.setValue('add', add);
							script.interp.execute(script.expr);
						}

						scripts.push(script);
					}
				}
			}

			if (FileSystem.exists('./mods/${Assets.getText(Paths.text('modSelected'))}/scripts'))
			{
				for (i in FileSystem.readDirectory('./mods/${Assets.getText(Paths.text('modSelected'))}/scripts'))
				{
					if (i.contains(allowed))
					{
						var scriptrel:Array<String> = i.split('.');

						scriptrel.remove(allowed);

						var script:HScript = new HScript('scripts/${scriptrel[0]}');

						if (!script.isBlank && script.expr != null)
						{
							script.interp.scriptObject = this;
							script.setValue('add', add);
							script.interp.execute(script.expr);
						}

						if (!scripts.contains(script))
							scripts.push(script);
					}
				}
			}

			if (FileSystem.exists('./mods/Global/data/${SONG.song}'))
			{
				for (i in FileSystem.readDirectory('./mods/Global/data/${SONG.song}'))
				{
					if (i.contains(allowed))
					{
						var scriptrel:Array<String> = i.split('.');

						scriptrel.remove(allowed);

						var script:HScript = new HScript('data/' + SONG.song + '/' + scriptrel[0]);

						if (!script.isBlank && script.expr != null)
						{
							script.interp.scriptObject = this;
							script.setValue('add', add);
							script.interp.execute(script.expr);
						}

						if (!scripts.contains(script))
							scripts.push(script);
					}
				}
			}

			if (FileSystem.exists('./mods/Global/scripts'))
			{
				for (i in FileSystem.readDirectory('./mods/Global/scripts'))
				{
					if (i.contains(allowed))
					{
						var scriptrel:Array<String> = i.split('.');

						scriptrel.remove(allowed);

						var script:HScript = new HScript('scripts/${scriptrel[0]}');

						if (!script.isBlank && script.expr != null)
						{
							script.interp.scriptObject = this;
							script.setValue('add', add);
							script.interp.execute(script.expr);
						}

						if (!scripts.contains(script))
							scripts.push(script);
					}
				}
			}
		}

		for (i in scripts)
			i.callFunction('create');
		#end

		add(gf);

		dads = new FlxTypedGroup();
		add(dads);

		bfs = new FlxTypedGroup();
		add(bfs);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
				}
		}

		dads.add(dad);
		bfs.add(boyfriend);

		add(foregroundSprites);

		if (!pixelSongs.contains(SONG.song.toLowerCase()))
		{
			comboUI = new ComboPopup(boyfriend.x - 250, boyfriend.y - 75, [Paths.image("ui/ratings"), 403, 163, true],
				[Paths.image("ui/numbers"), 100, 120, true], [Paths.image("ui/comboBreak"), 348, 211, true]);
			NoteSplash.splashPath = "ui/noteSplashes";
		}
		else
		{
			comboUI = new ComboPopup(boyfriend.x - 250, boyfriend.y - 75, [Paths.image("week6/weeb/pixelUI/ratings-pixel"), 51, 20, false],
				[Paths.image("week6/weeb/pixelUI/numbers-pixel"), 11, 12, false], [Paths.image("week6/weeb/pixelUI/comboBreak-pixel"), 53, 32, false],
				[daPixelZoom * 0.7, daPixelZoom * 0.8, daPixelZoom * 0.7]);
			comboUI.numberPosition[0] -= 120;
			NoteSplash.splashPath = "week6/weeb/pixelUI/noteSplashes-pixel";
		}

		if (Config.comboType == 1)
		{
			comboUI.cameras = [camHUD];
			comboUI.setPosition(0, 0);
			comboUI.scrollFactor.set(0, 0);
			comboUI.setScales([comboUI.ratingScale * 0.8, comboUI.numberScale, comboUI.breakScale * 0.8]);
			comboUI.accelScale = 0.2;
			comboUI.velocityScale = 0.2;

			if (!Config.downscroll)
			{
				comboUI.ratingPosition = [700, 510];
				comboUI.numberPosition = [320, 480];
				comboUI.breakPosition = [690, 465];
			}
			else
			{
				comboUI.ratingPosition = [700, 80];
				comboUI.numberPosition = [320, 100];
				comboUI.breakPosition = [690, 85];
			}

			if (pixelSongs.contains(SONG.song.toLowerCase()))
			{
				comboUI.numberPosition[0] -= 120;
				comboUI.setPosition(160, 60);
			}
		}

		if (Config.comboType < 2)
		{
			add(comboUI);
		}

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		if (Config.downscroll)
		{
			strumLine = new FlxSprite(0, 570).makeGraphic(FlxG.width, 10);
		}
		else
		{
			strumLine = new FlxSprite(0, 30).makeGraphic(FlxG.width, 10);
		}
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		enemyStrums = new FlxTypedGroup<FlxSprite>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / Main.fpsDisplay.currentFPS));

		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (Assets.exists(Paths.text(SONG.song.toLowerCase() + "/meta")))
		{
			meta = new SongMetaTags(0, 144, SONG.song.toLowerCase());
			meta.cameras = [camHUD];
			add(meta);
		}

		healthBarBG = new FlxSprite(0, Config.downscroll ? FlxG.height * 0.1 : FlxG.height * 0.875).loadGraphic(Paths.image("ui/healthBar"));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, maxHealth);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.characterColor, boyfriend.characterColor);
		healthBar.antialiasing = true;
		add(healthBar);

		iconP1 = new HealthIcon(boyfriend.iconName, true, boyfriend.hasWinningIcons);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(dad.iconName, false, dad.hasWinningIcons);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		scoreTxt = new FlxText(0, (FlxG.height * 0.9) + 12, FlxG.width, "", 22);
		scoreTxt.setFormat(Paths.font("vcr"), 22, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		scoreTxt.screenCenter(X);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		var watermarkTxt = new FlxText(0, scoreTxt.y
			+ 30, FlxG.width,
			SONG.song.replace('-', ' ')
			+ ' - '
			+ storyDifficulty.toUpperCase()
			+ ' - FPS REFLASHED V:'
			+ Application.current.meta.get('version').split('|')[2],
			18);
		if (FreeplayState.speed != 1)
			watermarkTxt.text = SONG.song.replace('-', ' ') + 'X' + FreeplayState.speed + ' - ' + storyDifficulty.toUpperCase() + ' - FPS REFLASHED V:'
				+ Application.current.meta.get('version').split('|')[2];
		watermarkTxt.setFormat(Paths.font("vcr"), 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		watermarkTxt.scrollFactor.set();
		add(watermarkTxt);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		watermarkTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		startingSong = true;

		if (isStoryMode)
		{
			switch (curSong.toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);

				case "ugh":
					camHUD.visible = false;
					videoCutscene(Paths.video("week7/ughCutsceneFade"), function()
					{
						FlxG.camera.zoom = defaultCamZoom * 1.2;
						camFocusOpponent();
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
						camHUD.visible = true;
					});

				case "guns":
					camHUD.visible = false;

					videoCutscene(Paths.video("week7/gunsCutsceneFade"), function()
					{
						FlxG.camera.zoom = defaultCamZoom * 1.2;
						camFocusOpponent();
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
						camHUD.visible = true;
					});

				case "stress":
					camHUD.visible = false;

					videoCutscene(Paths.video("week7/stressCutsceneFade"), function()
					{
						FlxG.camera.zoom = defaultCamZoom * 1.2;
						camFocusOpponent();
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, ((Conductor.crochet / 1000) * 5) - 0.1, {ease: FlxEase.quadOut});
						camHUD.visible = true;
					});

				default:
					startCountdown();
			}
		}
		else
			startCountdown();

		var bgDim = new FlxSprite(1280 / -2, 720 / -2).makeGraphic(1280 * 2, 720 * 2, FlxColor.BLACK);
		bgDim.cameras = [camOverlay];
		bgDim.alpha = Config.bgDim / 10;
		add(bgDim);

		for (note in unspawnNotes)
		{
			if (!note.isSustainNote && note.mustPress)
				maxNotes++;
		}

		#if sys
		for (i in scripts)
			i.callFunction('createPost');
		#end

		if (stage != null)
		{
			stage.createPost();
		}
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
		if (accuracy >= 100)
		{
			accuracy = 100;
		}

		#if sys
		for (i in scripts)
			i.callFunction('updateAccuracy');
		#end
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('week6/weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 5.5));
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		// senpaiEvil.x -= 120;
		senpaiEvil.y -= 115;

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function videoCutscene(path:String, ?endFunc:Void->Void, ?startFunc:Void->Void)
	{
		inCutscene = true;

		var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.screenCenter();
		blackShit.scrollFactor.set();
		add(blackShit);

		var video = new VideoHandler();
		video.scrollFactor.set();
		video.antialiasing = true;

		FlxG.camera.zoom = 1;

		video.playMP4(path, function()
		{
			FlxTween.tween(blackShit, {alpha: 0}, 0.4, {
				ease: FlxEase.quadInOut,
				onComplete: function(t)
				{
					remove(blackShit);
				}
			});

			remove(video);

			FlxG.camera.zoom = defaultCamZoom;

			if (endFunc != null)
			{
				endFunc();
			}

			startCountdown();
		}, false, true);

		add(video);

		if (startFunc != null)
		{
			startFunc();
		}
	}

	var startTimer:FlxTimer;

	function startCountdown():Void
	{
		inCutscene = false;

		#if sys
		for (i in scripts)
			i.callFunction('startCountdown');
		#end

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;

		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);
		introAssets.set('school', [
			'week6/weeb/pixelUI/ready-pixel',
			'week6/weeb/pixelUI/set-pixel',
			'week6/weeb/pixelUI/date-pixel'
		]);
		introAssets.set('schoolEvil', [
			'week6/weeb/pixelUI/ready-pixel',
			'week6/weeb/pixelUI/set-pixel',
			'week6/weeb/pixelUI/date-pixel'
		]);

		var introAlts:Array<String> = introAssets.get('default');
		var altSuffix:String = "";

		for (value in introAssets.keys())
		{
			if (value == curStage)
			{
				introAlts = introAssets.get(value);
				altSuffix = '-pixel';
			}
		}

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
					if (meta != null)
					{
						meta.start();
					}
				case 1:
					for (dad in dads)
						dad.dance();

					for (boyfriend in bfs)
						boyfriend.dance();

					gf.dance();

					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.antialiasing = !curStage.startsWith('school');

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom * 0.8));
					else
						ready.setGraphicSize(Std.int(ready.width * 0.5));

					ready.updateHitbox();

					ready.screenCenter();
					ready.y -= 120;
					ready.cameras = [camHUD];
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();
					set.antialiasing = !curStage.startsWith('school');

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom * 0.8));
					else
						set.setGraphicSize(Std.int(set.width * 0.5));

					set.updateHitbox();

					set.screenCenter();
					set.y -= 120;
					set.cameras = [camHUD];
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					for (dad in dads)
						dad.dance();

					for (boyfriend in bfs)
						boyfriend.dance();

					gf.dance();

					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();
					go.antialiasing = !curStage.startsWith('school');

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom * 0.8));
					else
						go.setGraphicSize(Std.int(go.width * 0.8));

					go.updateHitbox();

					go.screenCenter();
					go.y -= 120;
					go.cameras = [camHUD];
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
					beatHit();
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			if (Assets.exists(Paths.inst(SONG.song, 'Inst' + '-' + storyDifficulty)))
				FlxG.sound.playMusic(Paths.inst(SONG.song, 'Inst' + '-' + storyDifficulty), 1, false);
			else
				FlxG.sound.playMusic(Paths.inst(SONG.song), 1, false);
		}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		if (!isStoryMode)
		{
			FlxG.sound.music.pitch = FreeplayState.speed;
			vocals.pitch = FreeplayState.speed;
		}

		if (sectionStart)
		{
			FlxG.sound.music.time = sectionStartTime;
			Conductor.songPosition = sectionStartTime;
			vocals.time = sectionStartTime;
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			if (!paused)
				resyncVocals();
		});
	}

	public function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
		{
			if (Assets.exists(Paths.voices(SONG.song, 'Voices' + '-' + storyDifficulty)))
				vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song, 'Voices' + '-' + storyDifficulty));
			else
				vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song));
		}
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		// for (section in noteData)
		for (section in noteData)
		{
			if (sectionStart && daBeats < sectionStartPoint)
			{
				daBeats++;
				continue;
			}

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var daNoteType:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, daNoteType, false, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.round(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, daNoteType, false,
						oldNote, true);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else
				{
				}
			}
			daBeats++;
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;

		if (Config.uiType != 'BASE')
		{
			timeBarBG = new FlxSprite(0, Config.downscroll ? FlxG.height * 0.875 : FlxG.height * 0.1).loadGraphic(Paths.image("ui/healthBar"));
			timeBarBG.y -= 65.3;
			if (Config.uiType == 'PSYCH')
			{
				timeBarBG.scale.set(0.6, 1.03);
				timeBarBG.scale.x += 0.092;
			}
			else if (Config.uiType != 'KADE')
			{
				timeBarBG.scale.set(0.7, 0.79);
			}
			timeBarBG.screenCenter(X);
			timeBarBG.scrollFactor.set();
			timeBarBG.antialiasing = true;
			add(timeBarBG);

			timeBar = new FlxBar(0, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this, 'timeBarTime', 0,
				((FlxG.sound.music.length) / 1000));
			if (Config.uiType != 'KADE')
				timeBar.scale.set(timeBarBG.scale.x, timeBarBG.scale.y);
			timeBar.numDivisions = 600;
			timeBar.screenCenter(X);
			timeBar.scrollFactor.set();
			if (Config.uiType == 'PSYCH')
				timeBar.createFilledBar(FlxColor.BLACK, FlxColor.WHITE);
			else if (Config.uiType == 'KADE')
				timeBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			else
				timeBar.createFilledBar(FlxColor.BLACK, FlxColor.MAGENTA);
			timeBar.antialiasing = true;
			add(timeBar);

			timeTxt = new FlxText(0, timeBar.y - 7, FlxG.width);
			timeTxt.setFormat(Paths.font("vcr"), 22, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			if (Config.uiType == 'PSYCH')
			{
				timeTxt.text = '0:00';
				timeTxt.size = 25;
				timeTxt.scale.y += 0.24;
				timeTxt.scale.x += 0.10;
			}
			if (Config.uiType == 'KADE')
				timeTxt.text = SONG.song;
			else
				timeTxt.text = '0:00 / ' + FlxStringUtil.formatTime(((FlxG.sound.music.length) / 1000));
			timeTxt.screenCenter(X);
			timeTxt.scrollFactor.set();
			add(timeTxt);

			timeBarBG.cameras = [camHUD];
			timeBar.cameras = [camHUD];
			timeTxt.cameras = [camHUD];
		}
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByEventStuff(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
	}

	var note:Int = -1;

	public function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			note++;
			if (note > 3)
				note = 0;
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(50, strumLine.y);

			switch (curStage)
			{
				default:
					babyArrow.frames = Paths.getSparrowAtlas('ui/NOTE_assets');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
					}
			}

			#if sys
			for (i in scripts)
				i.callFunction('generateStaticArrows', [player, note, babyArrow]);
			#end

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
				babyArrow.animation.finishCallback = function(name:String)
				{
					if (autoplay)
					{
						if (name == "confirm")
						{
							babyArrow.animation.play('static', true);
							babyArrow.centerOffsets();
						}
					}
				}
			}
			else
			{
				enemyStrums.add(babyArrow);
				babyArrow.animation.finishCallback = function(name:String)
				{
					if (name == "confirm")
					{
						babyArrow.animation.play('static', true);
						babyArrow.centerOffsets();
					}
				}
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		PlayerSettings.gameControls();

		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		setBoyfriendInvuln(1 / 60);

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;

	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		#if sys
		for (i in scripts)
			i.callFunction('update', [elapsed]);
		#end

		if (camZooming && autoZoom)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		if (generatedMusic)
		{
			timeBarTime = (Conductor.songPosition - ((FlxG.sound.music.length) / 1000)) / 1000;

			if (Config.uiType == 'PSYCH')
				timeTxt.text = FlxStringUtil.formatTime(((FlxG.sound.music.length) / 1000) - timeBarTime);
			else if (Config.uiType == 'REFLASHED')
				timeTxt.text = FlxStringUtil.formatTime(timeBarTime) + ' / ' + FlxStringUtil.formatTime(((FlxG.sound.music.length) / 1000));
		}

		keyCheck();

		if (!inCutscene)
		{
			if (!autoplay)
			{
				keyShit();
			}
			else
			{
				keyShitAuto();
			}
		}

		if (FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.TAB && !isStoryMode)
		{
			autoplay = !autoplay;
			usedAutoplay = true;
		}

		if (!startingSong)
		{
			for (i in eventList)
			{
				if (i[0] > Conductor.songPosition)
				{
					break;
				}
				else
				{
					executeEvent(i[1]);
					eventList.remove(i);
				}
			}
		}

		super.update(elapsed);

		timeBarTime = (Conductor.songPosition) / 1000;

		switch Config.uiType
		{
			case "REFLASHED":
				scoreTxt.text = "Score:" + songScore + " | Misses:" + misses + " | Combo:" + combo + " | Notes Hit:" + notesHit + " / " + maxNotes
					+ " | Acc:" + truncateFloat(accuracy, 2) + "%";
			case 'KADE':
				scoreTxt.text = "Score:" + songScore + " | Combo Breaks:" + misses + " | Accuracy:" + truncateFloat(accuracy, 2) + " %";
			case 'PSYCH':
				var ratingAccuracy:Float = 0.00;
				var ratingName:String = '?';
				var fcRatingThing:String = null; // dont you love this

				ratingAccuracy = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));

				// Rating Name
				if (ratingAccuracy >= 1)
				{
					ratingName = ratingPsych[ratingPsych.length - 1][0]; // Uses last string
				}
				else
				{
					for (i in 0...ratingPsych.length - 1)
					{
						if (ratingAccuracy < ratingPsych[i][1])
						{
							ratingName = ratingPsych[i][0];
							break;
						}
					}
				}

				// Rating FC
				fcRatingThing = "?";
				if (sicks > 0)
					fcRatingThing = "SFC";
				if (goods > 0)
					fcRatingThing = "GFC";
				if (bads > 0 || shits > 0)
					fcRatingThing = "FC";
				if (misses > 0 && misses < 10)
					fcRatingThing = "SDCB";
				else if (misses >= 10)
					fcRatingThing = "Clear";

				var rating:String = null;

				if (totalNotesHit > 0)
					rating = ratingName + " (" + truncateFloat(accuracy, 2) + "%) - " + fcRatingThing;
				else
					rating = '?';

				scoreTxt.text = "Score: " + songScore + " | Misses: " + misses + " | Rating: " + rating;
			default:
				scoreTxt.text = "Score:" + songScore;
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			PlayerSettings.menuControls();

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			PlayerSettings.menuControls();
			switchState(new editors.ChartEditor());
			sectionStart = false;
		}

		if (Config.debug)
		{
			if (FlxG.keys.justPressed.EIGHT)
			{
				PlayerSettings.menuControls();
				sectionStart = false;

				switchState(new editors.CharEditor(dad.curCharacter));
			}

			if (FlxG.keys.justPressed.NINE)
			{
				PlayerSettings.menuControls();
				sectionStart = false;

				switchState(new editors.CharEditor(gf.curCharacter));
			}

			if (FlxG.keys.justPressed.ZERO)
			{
				PlayerSettings.menuControls();
				sectionStart = false;

				switchState(new editors.CharEditor(boyfriend.curCharacter));
			}
		}

		if (paused)
			DiscordClient.changePresence('Paused in ${SONG.song} - ${storyDifficulty.toUpperCase()}',
				'Details: Score: $songScore, Misses: $misses, Accuracy: ${truncateFloat(accuracy, 2)}%');
		else
			DiscordClient.changePresence('Playing in ${SONG.song} - ${storyDifficulty.toUpperCase()} with ${FlxStringUtil.formatTime(((FlxG.sound.music.length) / 1000) - timeBarTime)} time left.',
				'Details: Score: $songScore, Misses: $misses, Accuracy: ${truncateFloat(accuracy, 2)}%');

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > maxHealth)
		{
			health = maxHealth;
		}

		// Health Icons
		if (healthBar.percent < 20)
		{
			if (iconP2.hasWinning != false)
				iconP2.animation.curAnim.curFrame = 2;

			iconP1.animation.curAnim.curFrame = 1;
		}
		else if (healthBar.percent > 80)
		{
			if (iconP1.hasWinning != false)
				iconP1.animation.curAnim.curFrame = 2;

			iconP2.animation.curAnim.curFrame = 1;
		}
		else
		{
			iconP1.animation.curAnim.curFrame = 0;
			iconP2.animation.curAnim.curFrame = 0;
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (camFocus != "dad" && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && autoCam)
			{
				camFocusOpponent();
			}

			if (camFocus != "bf" && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && autoCam)
			{
				camFocusBF();
			}
		}

		FlxG.watch.addQuick("totalBeats: ", totalBeats);

		// RESET = Quick Game Over Screen
		if (controls.RESET && !startingSong)
		{
			health = 0;
			// trace("RESET = True");
		}

		if (health <= 0)
		{
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			PlayerSettings.menuControls();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, camFollow.getScreenPosition().x,
				camFollow.getScreenPosition().y, boyfriend.deathCharacter));

			sectionStart = false;
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3000)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			updateNote();
			opponentNoteCheck();
		}

		leftPress = false;
		leftRelease = false;
		downPress = false;
		downRelease = false;
		upPress = false;
		upRelease = false;
		rightPress = false;
		rightRelease = false;

		#if sys
		for (i in scripts)
			i.callFunction('updatePost', [elapsed]);
		#end
	}

	function updateNote()
	{
		notes.forEachAlive(function(daNote:Note)
		{
			var targetY:Float;
			var targetX:Float;

			if (daNote.mustPress)
			{
				targetY = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y;
				targetX = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
			}
			else
			{
				targetY = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].y;
				targetX = enemyStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
			}

			if (Config.downscroll)
			{
				daNote.y = (strumLine.y + (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				if (daNote.isSustainNote)
				{
					daNote.y -= daNote.height;
					daNote.y += 125;

					if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
						&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
					{
						// Clip to strumline
						var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
						swagRect.height = (targetY + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.y = daNote.frameHeight - swagRect.height;

						daNote.clipRect = swagRect;
					}
				}
			}
			else
			{
				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
				if (daNote.isSustainNote)
				{
					if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit)
						&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
					{
						// Clip to strumline
						var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
						swagRect.y = (targetY + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
						swagRect.height -= swagRect.y;

						daNote.clipRect = swagRect;
					}
				}
			}

			daNote.x = targetX + daNote.xOffset;

			if (daNote.tooLate)
			{
				if (daNote.alpha > 0.3)
				{
					noteMiss(daNote.noteData, 0.055, false, true);
					vocals.volume = 0;
					daNote.alpha = 0.3;
				}
			}

			if (Config.downscroll ? (daNote.y > strumLine.y + daNote.height + 50) : (daNote.y < strumLine.y - daNote.height - 50))
			{
				if (daNote.tooLate || daNote.wasGoodHit)
				{
					daNote.active = false;
					daNote.visible = false;
					daNote.destroy();
				}
			}
		});
	}

	function opponentNoteCheck()
	{
		notes.forEachAlive(function(daNote:Note)
		{
			if (!daNote.mustPress && daNote.canBeHit && !daNote.wasGoodHit)
			{
				daNote.wasGoodHit = true;

				#if sys
				for (i in scripts)
					i.callFunction('dadNoteHit', [daNote]);

				daNote.script.setValue('character', dad);
				daNote.script.callFunction('dadNoteHit', [daNote]);
				#end

				for (dad in dads)
				{
					if (dad.canAutoAnim && (dad.LOOP_ANIM_ON_HOLD ? true : !daNote.isSustainNote) && daNote.canAutoAnim)
					{
						switch (Math.abs(daNote.noteData))
						{
							case 2:
								dad.playAnim('singUP', true);
							case 3:
								dad.playAnim('singRIGHT', true);
							case 1:
								dad.playAnim('singDOWN', true);
							case 0:
								dad.playAnim('singLEFT', true);
						}
					}
				}

				enemyStrums.forEach(function(spr:FlxSprite)
				{
					if (Math.abs(daNote.noteData) == spr.ID)
					{
						spr.animation.play('confirm', true);
						if (spr.animation.curAnim.name == 'confirm')
						{
							spr.centerOffsets();
							spr.offset.x -= 14;
							spr.offset.y -= 14;
						}
						else
							spr.centerOffsets();
					}
				});

				for (dad in dads)
					dad.holdTimer = 0;

				if (SONG.needsVoices)
					vocals.volume = 1;

				if (!daNote.isSustainNote)
				{
					daNote.destroy();
				}
			}
		});
	}

	public function endSong():Void
	{
		#if sys
		for (i in scripts)
			i.callFunction('endSong');
		#end

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		if (canAutoEndSong)
		{
			canPause = false;
			if (SONG.validScore && !usedAutoplay)
			{
				#if !switch
				Highscore.saveScore(SONG.song, songScore, storyDifficulty);
				#end
			}

			if (isStoryMode)
			{
				campaignScore += songScore;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);

					PlayerSettings.menuControls();
					// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
					// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyUp);

					switchState(new StoryMenuState());
					sectionStart = false;

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					// trace('LOADING NEXT SONG');
					// trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

					if (SONG.song.toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					if (SONG.song.toLowerCase() == 'senpai')
					{
						transIn = null;
						transOut = null;
					}

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + "-" + storyDifficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					switchState(new PlayState());

					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
				}
			}
			else
			{
				PlayerSettings.menuControls();
				sectionStart = false;
				// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				// FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyUp);

				switchState(new FreeplayState());
			}
		}

		openfl.system.System.gc();
	}

	var endingSong:Bool = false;

	public function popUpScore(note:Note):Void
	{
		var strumtime = note.strumTime;

		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);

		var score:Int = 350;

		var daRating:String = "sick";

		#if sys
		for (i in scripts)
			i.callFunction('popUpScore', [note]);
		#end

		if (noteDiff > Conductor.safeZoneOffset * Conductor.shitZone)
		{
			daRating = 'shit';
			totalNotesHit += 1 - Conductor.shitZone;
			score = 50;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * Conductor.badZone)
		{
			daRating = 'bad';
			score = 100;
			totalNotesHit += 1 - Conductor.badZone;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * Conductor.goodZone)
		{
			daRating = 'good';
			totalNotesHit += 1 - Conductor.goodZone;
			score = 200;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}

		if (Config.noteSplashType == 2 || daRating == 'sick')
		{
			createNoteSplash(note);
		}

		songScore += score;

		comboUI.ratingPopup(daRating);

		if (combo >= minCombo)
			comboUI.comboPopup(combo);
	}

	public function createNoteSplash(note:Note)
	{
		var splashySplash = new NoteSplash(note.x, strumLine.y, note.noteData);
		splashySplash.cameras = [camHUD];
		add(splashySplash);
	}

	function keyDown(evt:KeyboardEvent):Void
	{
		if (skipListener)
		{
			return;
		}

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));

		var binds:Array<String> = [
			FlxG.save.data.leftBind,
			FlxG.save.data.downBind,
			FlxG.save.data.upBind,
			FlxG.save.data.rightBind
		];

		var data = -1;

		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		switch (data)
		{
			case 0:
				if (leftHold)
				{
					return;
				}
				leftPress = true;
				leftHold = true;
			case 1:
				if (downHold)
				{
					return;
				}
				downPress = true;
				downHold = true;
			case 2:
				if (upHold)
				{
					return;
				}
				upPress = true;
				upHold = true;
			case 3:
				if (rightHold)
				{
					return;
				}
				rightPress = true;
				rightHold = true;
		}
	}

	public function keyUp(evt:KeyboardEvent):Void
	{
		if (skipListener)
		{
			return;
		}

		@:privateAccess
		var key = FlxKey.toStringMap.get(Keyboard.__convertKeyCode(evt.keyCode));

		var binds:Array<String> = [
			FlxG.save.data.leftBind,
			FlxG.save.data.downBind,
			FlxG.save.data.upBind,
			FlxG.save.data.rightBind
		];

		var data = -1;

		switch (evt.keyCode) // arrow keys
		{
			case 37:
				data = 0;
			case 40:
				data = 1;
			case 38:
				data = 2;
			case 39:
				data = 3;
		}

		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		switch (data)
		{
			case 0:
				leftRelease = true;
				leftHold = false;
			case 1:
				downRelease = true;
				downHold = false;
			case 2:
				upRelease = true;
				upHold = false;
			case 3:
				rightRelease = true;
				rightHold = false;
		}
	}

	public function keyCheck():Void
	{
		upTime = controls.UP ? upTime + 1 : 0;
		downTime = controls.DOWN ? downTime + 1 : 0;
		leftTime = controls.LEFT ? leftTime + 1 : 0;
		rightTime = controls.RIGHT ? rightTime + 1 : 0;

		upPress = upTime == 1;
		downPress = downTime == 1;
		leftPress = leftTime == 1;
		rightPress = rightTime == 1;

		upRelease = upHold && upTime == 0;
		downRelease = downHold && downTime == 0;
		leftRelease = leftHold && leftTime == 0;
		rightRelease = rightHold && rightTime == 0;

		upHold = upTime > 0;
		downHold = downTime > 0;
		leftHold = leftTime > 0;
		rightHold = rightTime > 0;
	}

	public function keyShit():Void
	{
		var controlArray:Array<Bool> = [leftPress, downPress, upPress, rightPress];

		if ((upPress || rightPress || downPress || leftPress) && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteData);

					if (Config.ghostTapType == 1)
						setCanMiss();
				}
			});

			var directionsAccounted = [false, false, false, false];

			if (possibleNotes.length > 0)
			{
				for (note in possibleNotes)
				{
					if (controlArray[note.noteData] && !directionsAccounted[note.noteData])
					{
						goodNoteHit(note);
						directionsAccounted[note.noteData] = true;
					}
				}
				for (i in 0...4)
				{
					if (!ignoreList.contains(i) && controlArray[i])
					{
						badNoteCheck(i);
					}
				}
			}
			else
			{
				badNoteCheck();
			}
		}

		notes.forEachAlive(function(daNote:Note)
		{
			if ((upHold || rightHold || downHold || leftHold) && generatedMusic)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					boyfriend.holdTimer = 0;

					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (upHold)
								goodNoteHit(daNote);
						case 3:
							if (rightHold)
								goodNoteHit(daNote);
						case 1:
							if (downHold)
								goodNoteHit(daNote);
						case 0:
							if (leftHold)
								goodNoteHit(daNote);
					}
				}
			}

			// Guitar Hero Type Held Notes
			if (daNote.isSustainNote && daNote.mustPress)
			{
				// This is for all subsequent released notes.
				if (daNote.prevNote.tooLate && !daNote.prevNote.wasGoodHit)
				{
					daNote.tooLate = true;
					daNote.destroy();
					updateAccuracy();
					noteMiss(daNote.noteData, 0.035, false, true, false);
				}

				// This is for the first released note.
				if (daNote.prevNote.wasGoodHit && !daNote.wasGoodHit)
				{
					var doTheMiss:Bool = false;

					switch (daNote.noteData)
					{
						case 0:
							doTheMiss = leftRelease;
						case 1:
							doTheMiss = downRelease;
						case 2:
							doTheMiss = upRelease;
						case 3:
							doTheMiss = rightRelease;
					}

					if (doTheMiss)
					{
						noteMiss(daNote.noteData, 0.055, true, true, false);
						vocals.volume = 0;
						daNote.tooLate = true;
						daNote.destroy();
						boyfriend.holdTimer = 0;
						updateAccuracy();
					}
				}
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * boyfriend.stepsUntilRelease * 0.001
			&& !upHold
			&& !downHold
			&& !rightHold
			&& !leftHold)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing'))
			{
				if (boyfriend.USE_IDLE_END)
				{
					boyfriend.idleEnd();
				}
				else
				{
					boyfriend.dance();
					boyfriend.danceLockout = true;
				}
			}
		}

		playerStrums.forEach(function(spr:FlxSprite)
		{
			switch (spr.ID)
			{
				case 2:
					if (upPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!upHold)
						spr.animation.play('static');
				case 3:
					if (rightPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!rightHold)
						spr.animation.play('static');
				case 1:
					if (downPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!downHold)
						spr.animation.play('static');
				case 0:
					if (leftPress && spr.animation.curAnim.name != 'confirm')
						spr.animation.play('pressed');
					if (!leftHold)
						spr.animation.play('static');
			}

			switch (spr.animation.curAnim.name)
			{
				case "confirm":
					// spr.alpha = 1;
					spr.centerOffsets();

					spr.offset.x -= 14;
					spr.offset.y -= 14;
				default:
					// spr.alpha = 1;
					spr.centerOffsets();
			}
		});
	}

	public function keyShitAuto():Void
	{
		var hitNotes:Array<Note> = [];

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.mustPress
				&& daNote.strumTime < Conductor.songPosition +
					Conductor.safeZoneOffset * (!daNote.isSustainNote ? 0.125 : (daNote.prevNote.wasGoodHit ? 1 : 0)))
			{
				hitNotes.push(daNote);
			}
		});

		if (boyfriend.holdTimer > Conductor.stepCrochet * boyfriend.stepsUntilRelease * 0.001
			&& !upHold
			&& !downHold
			&& !rightHold
			&& !leftHold)
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing'))
			{
				if (boyfriend.USE_IDLE_END)
				{
					boyfriend.idleEnd();
				}
				else
				{
					boyfriend.dance();
					boyfriend.danceLockout = true;
				}
			}
		}

		for (x in hitNotes)
		{
			boyfriend.holdTimer = 0;

			goodNoteHit(x);

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(x.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
					if (spr.animation.curAnim.name == 'confirm')
					{
						spr.centerOffsets();
						spr.offset.x -= 14;
						spr.offset.y -= 14;
					}
					else
						spr.centerOffsets();
				}
			});
		}
	}

	function noteMiss(direction:Int = 1, ?healthLoss:Float = 0.04, ?playAudio:Bool = true, ?skipInvCheck:Bool = false, ?countMiss:Bool = true,
			?dropCombo:Bool = true, ?invulnTime:Int = 5, ?scoreAdjust:Int = 100):Void
	{
		if (!startingSong && (!invuln || skipInvCheck))
		{
			health -= healthLoss * Config.healthDrainMultiplier;

			if (dropCombo)
			{
				if (combo > minCombo)
				{
					gf.playAnim('sad');
					comboUI.breakPopup();
				}
				combo = 0;
			}

			if (countMiss)
			{
				misses += 1;
			}

			songScore -= scoreAdjust;

			if (playAudio)
			{
				FlxG.sound.play(Paths.sound('missnote' + FlxG.random.int(1, 3)), FlxG.random.float(0.1, 0.2));
			}

			setBoyfriendInvuln(invulnTime / 60);

			for (boyfriend in bfs)
			{
				if (boyfriend.canAutoAnim)
				{
					switch (direction)
					{
						case 2:
							boyfriend.playAnim('singUPmiss', true);
						case 3:
							boyfriend.playAnim('singRIGHTmiss', true);
						case 1:
							boyfriend.playAnim('singDOWNmiss', true);
						case 0:
							boyfriend.playAnim('singLEFTmiss', true);
					}
				}
			}

			updateAccuracy();
		}

		if (Main.flippymode)
		{
			System.exit(0);
		}

		#if sys
		for (script in scripts)
			script.callFunction('onMiss');
		#end
	}

	inline function noteMissWrongPress(direction:Int = 1, ?healthLoss:Float = 0.0475):Void
	{
		noteMiss(direction, healthLoss, true, false, false, false, 4, 25);
	}

	function badNoteCheck(direction:Int = -1)
	{
		if (Config.ghostTapType > 0 && !canHit)
		{
		}
		else
		{
			if (leftPress && (direction == -1 || direction == 0))
				noteMissWrongPress(0);
			if (upPress && (direction == -1 || direction == 2))
				noteMissWrongPress(2);
			if (rightPress && (direction == -1 || direction == 3))
				noteMissWrongPress(3);
			if (downPress && (direction == -1 || direction == 1))
				noteMissWrongPress(1);
		}
	}

	function setBoyfriendInvuln(time:Float = 5 / 60)
	{
		invulnCount++;
		var invulnCheck = invulnCount;

		invuln = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			if (invulnCount == invulnCheck)
			{
				invuln = false;
			}
		});
	}

	function setCanMiss(time:Float = 10 / 60)
	{
		noMissCount++;
		var noMissCheck = noMissCount;

		canHit = true;

		new FlxTimer().start(time, function(tmr:FlxTimer)
		{
			if (noMissCheck == noMissCount)
			{
				canHit = false;
			}
		});
	}

	function goodNoteHit(daNote:Note):Void
	{
		#if sys
		for (i in scripts)
			i.callFunction('bfNoteHit', [daNote]);

		daNote.script.setValue('character', boyfriend);
		daNote.script.callFunction('bfNoteHit', [daNote]);
		#end

		// Guitar Hero Styled Hold Notes
		// This is to make sure that if hold notes are hit out of order they are destroyed. Should not be possible though.
		if (daNote.isSustainNote && !daNote.prevNote.wasGoodHit)
		{
			noteMiss(daNote.noteData, 0.055, true, true, false);
			vocals.volume = 0;
			daNote.prevNote.tooLate = true;
			daNote.prevNote.destroy();
			boyfriend.holdTimer = 0;
			updateAccuracy();
		}
		else if (!daNote.wasGoodHit)
		{
			if (!daNote.isSustainNote)
			{
				popUpScore(daNote);
				combo += 1;
				if (Config.uiType == 'PSYCH' && !scoreTween)
				{
					scoreTween = true;
					scoreTxt.scale.set(1.075, 1.075);
					FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
						onComplete: function(tween)
						{
							scoreTween = false;
						}
					});
				}
			}
			else
				totalNotesHit += 1;

			if (daNote.noteData >= 0)
			{
				health += 0.015 * Config.healthMultiplier;
			}
			else
			{
				health += 0.0015 * Config.healthMultiplier;
			}

			for (boyfriend in bfs)
			{
				if (boyfriend.canAutoAnim && (boyfriend.LOOP_ANIM_ON_HOLD ? true : !daNote.isSustainNote) && daNote.canAutoAnim)
				{
					switch (daNote.noteData)
					{
						case 2:
							boyfriend.playAnim('singUP', true);
						case 3:
							boyfriend.playAnim('singRIGHT', true);
						case 1:
							boyfriend.playAnim('singDOWN', true);
						case 0:
							boyfriend.playAnim('singLEFT', true);
					}
				}
			}

			if (!daNote.isSustainNote)
			{
				setBoyfriendInvuln(2.5 / 60);
			}

			playerStrums.forEach(function(spr:FlxSprite)
			{
				if (Math.abs(daNote.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			daNote.wasGoodHit = true;
			vocals.volume = 1;

			if (!daNote.isSustainNote)
			{
				notesHit++;
				daNote.destroy();
			}

			updateAccuracy();
		}
	}

	override function stepHit()
	{
		#if sys
		for (i in scripts)
			i.callFunction('stepHit');
		#end

		if (stage != null)
			stage.stepHit();

		if (SONG.needsVoices)
		{
			if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20)
			{
				resyncVocals();
			}
		}

		super.stepHit();
	}

	override function beatHit()
	{
		#if sys
		for (i in scripts)
			i.callFunction('beatHit');
		#end

		if (stage != null)
			stage.beatHit();

		// wiggleShit.update(Conductor.crochet);
		super.beatHit();

		if (curBeat % 4 == 0)
		{
			var sec = Math.floor(curBeat / 4);
			if (sec >= sectionHaveNotes.length)
			{
				sec = -1;
			}

			sectionHasBFNotes = sec >= 0 ? sectionHaveNotes[sec][0] : false;
			sectionHasOppNotes = sec >= 0 ? sectionHaveNotes[sec][1] : false;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (camZooming && autoZoom && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}

			if (curBeat % bopSpeed == 0)
			{
				iconP1.iconScale = iconP1.defualtIconScale * 1.25;
				iconP2.iconScale = iconP2.defualtIconScale * 1.25;

				iconP1.tweenToDefaultScale(0.4, FlxEase.quintOut);
				iconP2.tweenToDefaultScale(0.4, FlxEase.quintOut);

				gf.dance();
			}

			for (dad in dads)
			{
				if (dad.holdTimer == 0 && dad.animation.curAnim.finished && curBeat % 2 == 0 && dad.canAutoAnim)
					dad.dance();
			}

			for (boyfriend in bfs)
			{
				if (curBeat % 2 == 0 && !boyfriend.animation.curAnim.name.startsWith('sing') && boyfriend.canAutoAnim)
				{
					boyfriend.dance();
				}
			}

			if (curBeat % 8 == 7 && curSong == 'Bopeebo')
			{
				for (boyfriend in bfs)
					boyfriend.playAnim('hey', true);
			}

			foregroundSprites.forEach(function(spr:BGSprite)
			{
				spr.dance();
			});
		}
	}

	public function executeEvent(tag:String):Void
	{
		#if sys
		var script = new HScript('events/${tag.split(";")[1]}');
		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = this;
			script.setValue('add', add);
			script.interp.execute(script.expr);
		}

		for (i in scripts)
			i.callFunction('executeEvent', [tag]);
		#end

		if (tag.startsWith("playAnim;"))
		{
			var tagSplit = tag.split(";");
			trace(tagSplit);

			switch (tagSplit[1])
			{
				case "dad":
					for (dad in dads)
						dad.playAnim(tagSplit[2]);

				case "gf":
					gf.playAnim(tagSplit[2]);

				default:
					for (boyfriend in bfs)
						boyfriend.playAnim(tagSplit[2]);
			}
		}
		else if (tag.startsWith("changeChar;"))
		{
			var tagSplit = tag.split(";");
			trace(tagSplit);

			switch (tagSplit[1])
			{
				case "dad":
					var newChar = new Character(dad.x, dad.y, tagSplit[2]);
					dads.members[0].kill();
					dads.remove(dads.members[0]);
					dads.add(newChar);

				case "gf":
					var newChar = new Character(gf.x, gf.y, tagSplit[2]);
					gf.kill();
					gf = newChar;
					add(gf);

				default:
					var newChar = new Character(bfs.members[0].x, bfs.members[0].y, tagSplit[2]);
					bfs.members[0].kill();
					bfs.remove(bfs.members[0]);
					bfs.add(newChar);
			}
		}
		else
		{
			switch (tag)
			{
				case "dadAnimLockToggle":
					dad.canAutoAnim = !dad.canAutoAnim;

				case "bfAnimLockToggle":
					boyfriend.canAutoAnim = !boyfriend.canAutoAnim;

				case "gfAnimLockToggle":
					gf.canAutoAnim = !gf.canAutoAnim;

				default:
					trace(tag);
			}
		}
		return;
	}

	var curLight:Int = 0;

	function sectionContainsBfNotes(section:Int):Bool
	{
		var notes = SONG.notes[section].sectionNotes;
		var mustHit = SONG.notes[section].mustHitSection;

		for (x in notes)
		{
			if (mustHit)
			{
				if (x[1] < 4)
				{
					return true;
				}
			}
			else
			{
				if (x[1] > 3)
				{
					return true;
				}
			}
		}

		return false;
	}

	function sectionContainsOppNotes(section:Int):Bool
	{
		var notes = SONG.notes[section].sectionNotes;
		var mustHit = SONG.notes[section].mustHitSection;

		for (x in notes)
		{
			if (mustHit)
			{
				if (x[1] > 3)
				{
					return true;
				}
			}
			else
			{
				if (x[1] < 4)
				{
					return true;
				}
			}
		}

		return false;
	}

	function camFocusOpponent()
	{
		camFocus = 'dad';
		
		var followX = dads.members[0].getMidpoint().x + 150 + dads.members[0].camX;
		var followY = dads.members[0].getMidpoint().y - 100 + dads.members[0].camY;

		switch (dad.curCharacter)
		{
			case "spooky":
				followY = dads.members[0].getMidpoint().y - 30 + dads.members[0].camY;
			case "pico":
				followX += 280;
			case "mom" | "mom-car":
				followY = dads.members[0].getMidpoint().y + dads.members[0].camY;
			case 'senpai':
				followY = dads.members[0].getMidpoint().y - 430;
				followX = dads.members[0].getMidpoint().x - 100 + dads.members[0].camX;
			case 'senpai-angry':
				followY = dads.members[0].getMidpoint().y - 430;
				followX = dads.members[0].getMidpoint().x - 100 + dads.members[0].camX;
			case 'spirit':
				followY = dads.members[0].getMidpoint().y + dads.members[0].camY;
		}

		#if sys
		for (script in scripts)
			script.callFunction('camFocusDad', [[followX], [followY]]);
		#end

		if (camFollow.x != followX && camFollow.y != followY)
			camFollow.setPosition(followX, followY);
	}

	function camFocusBF()
	{
		camFocus = 'bf';

		var followX = bfs.members[0].getMidpoint().x - 100 + bfs.members[0].camX;
		var followY = bfs.members[0].getMidpoint().y - 100 + bfs.members[0].camY;

		switch (curStage)
		{
			case 'spooky':
				followY = bfs.members[0].getMidpoint().y - 125 + bfs.members[0].camY;
			case 'mall':
				followY = bfs.members[0].getMidpoint().y - 200 + bfs.members[0].camY;
			case 'school':
				followX = bfs.members[0].getMidpoint().x - 200 + bfs.members[0].camX;
				followY = bfs.members[0].getMidpoint().y - 225 + bfs.members[0].camY;
			case 'schoolEvil':
				followX = bfs.members[0].getMidpoint().x - 200 + bfs.members[0].camX;
				followY = bfs.members[0].getMidpoint().y - 225 + bfs.members[0].camY;
		}

		#if sys
		for (script in scripts)
			script.callFunction('camFocusBf', [followX, followY]);
		#end

		if (camFollow.x != followX && camFollow.y != followY)
			camFollow.setPosition(followX, followY);
	}

	override public function onFocus()
	{
		super.onFocus();
	}

	function inRange(a:Float, b:Float, tolerance:Float)
	{
		return (a <= b + tolerance && a >= b - tolerance);
	}
}
