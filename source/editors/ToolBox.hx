package editors;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.ui.FlxUITabMenu;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;

class ToolBox extends MusicBeatSubstate
{
	var selected:Int = 0;
	var optionText:FlxTypedGroup<FlxText>;
	var options:Array<String> = ['Character Editor', 'Chart Editor'];

	override public function create()
	{
		FlxG.mouse.enabled = true;
		FlxG.mouse.visible = true;

		var bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set(0, 0);
		bg.screenCenter();
		add(bg);

		optionText = new FlxTypedGroup<FlxText>();
		add(optionText);

		for (i => option in options)
		{
			var optionrel:FlxText = new FlxText(0, 210 + i * 25, 0, option, 38);
			optionrel.setFormat(Paths.font("Funkin-Bold", "otf"), optionrel.textField.defaultTextFormat.size, FlxColor.WHITE, FlxTextAlign.CENTER,
				FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			optionrel.borderSize = 3;
			optionrel.borderQuality = 1;
			optionrel.scrollFactor.set(0, 0);
			optionrel.screenCenter(X);
			optionText.add(optionrel);
		}

		changeSelection();
	}

	override public function update(elapsed:Float)
	{
		if (controls.BACK)
			close();

		if (controls.ACCEPT)
		{
			switch (options[selected])
			{
				case 'Character Editor':
					FlxG.switchState(new CharEditor('bf', 'editors'));
				
				case 'Chart Editor':
					FlxG.switchState(new ChartEditor());
			}
		}

		if (controls.UP_P)
			changeSelection(-1);
		
		if (controls.DOWN_P)
			changeSelection(1);
	}

	function changeSelection(int:Int = 0)
	{
		optionText.members[selected].setFormat(Paths.font("Funkin-Bold", "otf"), optionText.members[selected].textField.defaultTextFormat.size,
			FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		optionText.members[selected].borderSize = 3;
		optionText.members[selected].borderQuality = 1;

		selected += int;

		if (selected > options.length - 1)
			selected = 0;
		if (selected < 0)
			selected = options.length - 1;

		optionText.members[selected].setFormat(Paths.font("Funkin-Bold", "otf"), optionText.members[selected].textField.defaultTextFormat.size,
			FlxColor.YELLOW, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		optionText.members[selected].borderSize = 3;
		optionText.members[selected].borderQuality = 1;
	}
}
