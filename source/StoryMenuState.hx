package;

import haxe.Json;
import openfl.Assets;
import title.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

using StringTools;

typedef StoryWeekShit =
{
	var songs:Array<String>;
	var chars:Array<String>;
	var diffs:Array<String>;
	var week:Int;
	var weekName:String;
	var image:String;
	var locked:Bool;
}

typedef StoryJsonShit =
{
	var weeks:Array<StoryWeekShit>;
	var baseGameSongs:Bool;
}

class StoryMenuState extends MusicBeatState
{
	public static var weekData:Array<Dynamic> = [];
	public static var weekCharacters:Array<Dynamic> = [];
	public static var weekDiffs:Array<Dynamic> = [];
	public static var weekNames:Array<String> = [];
	public static var weekUnlocked:Array<Bool> = [];
	public static var weekImages:Array<String> = [];

	var scoreText:FlxText;
	var txtWeekTitle:FlxText;
	var txtTracklist:FlxText;

	var curDifficulty:Int = 1;
	var curWeek:Int = 0;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var ui_tex:FlxAtlasFrames;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var storyJson:StoryJsonShit;

	override function create()
	{
		if (Assets.exists(Paths.json('songList')))
		{
			storyJson = Json.parse(Assets.getText(Paths.json('songList')));

			if (storyJson.baseGameSongs)
			{
				var baseStoryJson:StoryJsonShit = Json.parse(Assets.getText(Paths.json('baseSongList')));

				for (week in baseStoryJson.weeks)
				{
					weekData.push(week.songs);
					weekCharacters.push(week.chars);

					if (week.diffs == null || week.diffs == [null])
						week.diffs = ['easy', 'normal', 'hard'];

					weekDiffs.push(week.diffs);

					if (week.locked != true && week.locked != false)
						week.locked = true;

					weekUnlocked.push(week.locked);
					weekNames.push(week.weekName);

					if (week.image == null)
						week.image = 'week' + week.week;

					weekImages.push(week.image);
				}
			}

			for (week in storyJson.weeks)
			{
				weekData.push(week.songs);
				weekCharacters.push(week.chars);

				if (week.diffs == null || week.diffs == [null])
					week.diffs = ['easy', 'normal', 'hard'];

				weekDiffs.push(week.diffs);

				if (week.locked != true && week.locked != false)
					week.locked = true;

				weekUnlocked.push(week.locked);
				weekNames.push(week.weekName);

				if (week.image == null)
					week.image = 'week' + week.week;

				weekImages.push(week.image);
			}
		}
		else
		{
			storyJson = Json.parse(Assets.getText(Paths.json('baseSongList')));

			for (week in storyJson.weeks)
			{
				weekData.push(week.songs);
				weekCharacters.push(week.chars);

				if (week.diffs == null || week.diffs == [null])
					week.diffs = ['easy', 'normal', 'hard'];

				weekDiffs.push(week.diffs);

				if (week.locked != true && week.locked != false)
					week.locked = true;

				weekUnlocked.push(week.locked);
				weekNames.push(week.weekName);

				if (week.image == null)
					week.image = 'week' + week.week;

				weekImages.push(week.image);
			}
		}

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);
		}
		persistentUpdate = persistentDraw = true;
		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);
		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;
		var rankText:FlxText = new FlxText(0, 10);

		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);
		ui_tex = Paths.getSparrowAtlas('menu/story/campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);
		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);

		add(blackBarThingie);
		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, weekImages[i]);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();
			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, weekCharacters[curWeek][char]);
			weekCharacterThing.y += 70;
			weekCharacterThing.antialiasing = true;
			switch (weekCharacterThing.character)
			{
				case 'dad':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'bf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
					weekCharacterThing.x -= 80;
				case 'gf':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.5));
					weekCharacterThing.updateHitbox();
				case 'pico':
					weekCharacterThing.flipX = true;
				case 'parents-christmas':
					weekCharacterThing.setGraphicSize(Std.int(weekCharacterThing.width * 0.9));
					weekCharacterThing.updateHitbox();
			}
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);
		
		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y).loadGraphic(Paths.image('menu/story/difficulties/easy'));
		difficultySelectors.add(sprDifficulty);

		changeDifficulty();

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		trace("Line 150");
		add(yellowBG);
		add(grpWeekCharacters);
		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		updateText();
		trace("Line 165");
		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;
			PlayState.storyDifficulty = weekDiffs[curWeek][curDifficulty];
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-' + weekDiffs[curWeek][curDifficulty],
				PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.returnLocation = "main";
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				PlayState.loadEvents = true;
				switchState(new PlayState());
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Std.int(weekDiffs[curWeek].length - 1);
		if (curDifficulty > Std.int(weekDiffs[curWeek].length - 1))
			curDifficulty = 0;

		sprDifficulty.kill();

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y).loadGraphic(Paths.image('menu/story/difficulties/' + weekDiffs[curWeek][curDifficulty]));
		difficultySelectors.add(sprDifficulty);

		sprDifficulty.offset.x = 0;
		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, weekDiffs[curWeek][curDifficulty]);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, weekDiffs[curWeek][curDifficulty]);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		changeDifficulty();

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].animation.play(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].animation.play(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].animation.play(weekCharacters[curWeek][2]);

		if (grpWeekCharacters.members[0].animation.curAnim != null)
		{
			switch (grpWeekCharacters.members[0].animation.curAnim.name)
			{
				case 'parents-christmas':
					grpWeekCharacters.members[0].offset.set(200, 200);
					grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 0.99));

				case 'senpai':
					grpWeekCharacters.members[0].offset.set(130, 0);
					grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1.4));

				case 'mom':
					grpWeekCharacters.members[0].offset.set(100, 200);
					grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

				case 'dad':
					grpWeekCharacters.members[0].offset.set(120, 200);
					grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

				case 'tankman':
					grpWeekCharacters.members[0].offset.set(60, -20);
					grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));

				default:
					grpWeekCharacters.members[0].offset.set(100, 100);
					grpWeekCharacters.members[0].setGraphicSize(Std.int(grpWeekCharacters.members[0].width * 1));
			}
		}

		txtTracklist.text = "Tracks\n";

		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text += "\n";

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, weekDiffs[curWeek][curDifficulty]);
		#end
	}
}
