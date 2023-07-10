package config;

import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class ModSelectState extends MusicBeatState
{
	var modText:FlxTypedGroup<FlxText>;
	var selected:Int = 0;
	var mods:Array<String> = [];
	var forbiddenMods:Array<String> = [
		'global', 'Global', '.txt', '.json', '.git', '.hx', '.hxs', '.html', '.xml', '.yml', '.zip'
	];

	public static var idk:Bool;

	override public function create()
	{
		#if sys
		if (FileSystem.exists('./mods') && FileSystem.readDirectory('./mods').length > 0)
			mods = FileSystem.readDirectory('./mods');
		else
			mods = ['no mods are detected'];
		#else
		mods = ['this wont work because you arent on a supported platform'];
		#end

		for (shit in mods)
		{
			for (no in forbiddenMods)
			{
				if (shit.contains(no))
					mods.remove(shit);
			}
		}

		super.create();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuDesat'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFF5C6CA5;
		add(bg);

		var tex = Paths.getSparrowAtlas('menu/options/mods');
		var holyShitModsFnf:FlxSprite = new FlxSprite(0, 55);
		holyShitModsFnf.frames = tex;
		holyShitModsFnf.animation.addByPrefix('selected', "mods white", 24);
		holyShitModsFnf.animation.play('selected');
		holyShitModsFnf.scrollFactor.set();
		holyShitModsFnf.antialiasing = true;
		holyShitModsFnf.updateHitbox();
		holyShitModsFnf.screenCenter(X);
		add(holyShitModsFnf);

		modText = new FlxTypedGroup<FlxText>();
		add(modText);

		for (i => mod in mods)
		{
			var modrel:FlxText = new FlxText(0, 210 + i * 25, 0, mod, 38);
			modrel.setFormat(Paths.font("Funkin-Bold", "otf"), modrel.textField.defaultTextFormat.size, FlxColor.WHITE, FlxTextAlign.CENTER,
				FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			modrel.borderSize = 3;
			modrel.borderQuality = 1;
			modrel.screenCenter(X);
			modText.add(modrel);
		}

		changeSelection();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			FlxG.switchState(new ConfigMenu());
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.ACCEPT)
			acceptShi(mods[selected]);
	}

	function changeSelection(int:Int = 0)
	{
		modText.members[selected].setFormat(Paths.font("Funkin-Bold", "otf"), modText.members[selected].textField.defaultTextFormat.size, FlxColor.WHITE,
			FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		selected += int;

		if (selected > mods.length - 1)
			selected = 0;
		if (selected < 0)
			selected = mods.length - 1;

		modText.members[selected].setFormat(Paths.font("Funkin-Bold", "otf"), modText.members[selected].textField.defaultTextFormat.size, FlxColor.YELLOW,
			FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	}

	function acceptShi(modString:String)
	{
		#if sys
		File.saveBytes('./' + Paths.text('modSelected'), haxe.io.Bytes.ofString(modString));
		#end

		idk = true;

		FlxG.switchState(new title.TitleIntroText());
	}
}
