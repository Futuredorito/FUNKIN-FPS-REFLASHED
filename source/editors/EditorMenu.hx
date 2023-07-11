package editors;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class EditorMenu extends MusicBeatState
{
	var editorText:FlxTypedGroup<FlxText>;
	var editors:Array<String> = ['Chart Editor', 'Character Editor'];
	var selected:Int = 0;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuDesat'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFF5C6CA5;
		add(bg);

		editorText = new FlxTypedGroup<FlxText>();
		add(editorText);

		for (i => editor in editors)
		{
			var text:FlxText = new FlxText(0, 210 + i * 25, 0, editor, 38);
			text.setFormat(Paths.font("Funkin-Bold", "otf"), text.textField.defaultTextFormat.size, FlxColor.WHITE, FlxTextAlign.CENTER,
				FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 3;
			text.borderQuality = 1;
			text.screenCenter(X);
			editorText.add(text);
		}

		changeSelection();
	}

	override public function update(elapsed:Float) {
		if (controls.ACCEPT) {
			switch (editors[selected]) {
				case 'Chart Editor':
					FlxG.switchState(new ChartEditor());
				
				case 'Character Editor':
					FlxG.switchState(new CharEditor('bf', 'editors'));
			}
		}
	}

	function changeSelection(int:Int = 0)
	{
		editorText.members[selected].setFormat(Paths.font("Funkin-Bold", "otf"), editorText.members[selected].textField.defaultTextFormat.size,
			FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		editorText.members[selected].borderSize = 3;
		editorText.members[selected].borderQuality = 1;

		selected += int;

		if (selected > editors.length - 1)
			selected = 0;
		if (selected < 0)
			selected = editors.length - 1;

		editorText.members[selected].setFormat(Paths.font("Funkin-Bold", "otf"), editorText.members[selected].textField.defaultTextFormat.size,
			FlxColor.YELLOW, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		editorText.members[selected].borderSize = 3;
		editorText.members[selected].borderQuality = 1;
	}
}
