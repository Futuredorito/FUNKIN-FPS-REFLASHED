package;

import openfl.Assets;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

typedef FreeplaySongShit =
{
	var songs:Array<String>;
	var icons:Array<String>;
	var diffs:Array<String>;
	var colors:Array<FlxColor>;
	var week:Int;
}

typedef FreeplayJsonShit =
{
	var weeks:Array<FreeplaySongShit>;
	var baseGameSongs:Bool;
}

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	public static var startingSelection:Int = 0;

	var selector:FlxText;

	public static var curSelected:Int = 0;
	static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	public static var songParseShit:FreeplayJsonShit;
	public static var speed:Float = 1;

	override function create()
	{
		openfl.Lib.current.stage.frameRate = 144;

		curSelected = 0;

		if (Assets.exists(Paths.json('songList')))
		{
			songParseShit = Json.parse(Assets.getText(Paths.json('songList')));

			if (songParseShit.baseGameSongs)
			{
				var baseSongParseShit:FreeplayJsonShit = Json.parse(Assets.getText(Paths.json('baseSongList')));

				for (songs in baseSongParseShit.weeks)
					for (i => song in songs.songs)
						addSong(song, songs.week, songs.icons[i], FlxColor.BLACK, songs.diffs);
			}

			for (songs in songParseShit.weeks)
				for (i => song in songs.songs)
					addSong(song, songs.week, songs.icons[i], FlxColor.BLACK, songs.diffs);
		}
		else
		{
			songParseShit = Json.parse(Assets.getText(Paths.json('baseSongList')));

			for (songs in songParseShit.weeks)
				for (i => song in songs.songs)
					addSong(song, songs.week, songs.icons[i], FlxColor.BLACK, songs.diffs);
		}

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection(startingSelection);
		FlxG.sound.music.pitch = speed;

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor, songDiffs:Array<String>)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, songColor, songDiffs));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore + "\nSPEED:" + speed;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (FlxG.mouse.wheel > 0 || FlxG.mouse.wheel < 0)
			changeSelection(-FlxG.mouse.wheel);

		if (!FlxG.keys.pressed.SHIFT)
		{
			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);
		}

		if (FlxG.keys.pressed.SHIFT)
		{
			if (controls.LEFT_P)
			{
				speed -= 0.5;

				if (speed < 0.5)
					speed = 0.5;

				FlxG.sound.music.pitch = speed;
			}
			if (controls.RIGHT_P)
			{
				speed += 0.5;

				if (speed > 10)
					speed = 10;

				FlxG.sound.music.pitch = speed;
			}
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('cancelMenu'));
			switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), songs[curSelected].songDiffs[curDifficulty]);
			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = songs[curSelected].songDiffs[curDifficulty];
			PlayState.loadEvents = true;
			startingSelection = curSelected;
			PlayState.returnLocation = "freeplay";
			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		changeDiff();

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, songs[curSelected].songDiffs[curDifficulty]);
		#end

		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.8);
		FlxG.sound.music.pitch = speed;

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
			iconArray[i].animation.curAnim.curFrame = 0;
		}

		iconArray[curSelected].alpha = 1;
		iconArray[curSelected].animation.curAnim.curFrame = 2;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = songs[curSelected].songDiffs.length - 1;
		if (curDifficulty > songs[curSelected].songDiffs.length - 1)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, songs[curSelected].songDiffs[curDifficulty]);
		#end

		diffText.text = songs[curSelected].songDiffs[curDifficulty].toUpperCase();
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songColor:FlxColor;
	public var songDiffs:Array<String>;

	public function new(song:String, week:Int, songCharacter:String, songColor:FlxColor, songDiffs:Array<String>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songColor = songColor;
		this.songDiffs = songDiffs;
	}
}
