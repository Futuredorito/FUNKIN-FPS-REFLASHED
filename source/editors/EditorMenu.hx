package editors;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class EditorMenu extends MusicBeatState{
    var editorText:FlxTypedGroup<FlxText>;
	var selected:Int = 0;

    override public function create(){
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuDesat'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFF5C6CA5;
		add(bg);
    }
}