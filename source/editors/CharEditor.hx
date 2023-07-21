package editors;

import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import haxe.Json;
import openfl.net.FileReference;
import Character.AnimLoading;
import flixel.ui.FlxButton;
import openfl.desktop.ClipboardFormats;
import openfl.desktop.Clipboard;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

using StringTools;

/**
	*DEBUG MODE
 */
class CharEditor extends FlxState
{
	var char:Character;
	var charBG:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var UI_box:FlxUITabMenu;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var ischar:Bool = true;
	var daAnim:String = 'dad';
	var switchBack:String = 'PlayState';

	var camFollow:FlxObject;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	public function new(daAnim:String = 'dad', switchBack:String = 'PlayState')
	{
		super();
		this.daAnim = daAnim;
		this.switchBack = switchBack;
	}

	override function create()
	{
		openfl.Lib.current.stage.frameRate = 144;

		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		FlxG.sound.music.stop();

		var stage = new Stage('stage', this);
		add(stage);

		if (daAnim.contains('player') || daAnim.contains('bf'))
			charBG = new Character(0, 0, daAnim, true, true);
		else
			charBG = new Character(0, 0, daAnim, false, true);
		charBG.screenCenter();
		charBG.alpha = 0.75;
		charBG.color = 0xFF000000;
		charBG.playAnim('idle');
		add(charBG);

		if (daAnim.contains('player') || daAnim.contains('bf'))
			char = new Character(0, 0, daAnim, true, true);
		else
			char = new Character(0, 0, daAnim, false, true);
		char.screenCenter();
		char.playAnim('idle');
		add(char);

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.scrollFactor.set(0);
		textAnim.cameras = [camHUD];
		add(textAnim);

		var tabs = [
			{name: "Character", label: 'Character'},
			{name: "Animations", label: "Animations"}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(300, 300);
		UI_box.x = 870;
		UI_box.y = 320;
		UI_box.cameras = [camHUD];
		add(UI_box);

		addShitIntoTheTabs();
		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);

		super.create();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.setFormat(Paths.font('vcr'), 15, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
			text.scrollFactor.set(0, 0);
			text.cameras = [camHUD];
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		textAnim.text = char.animation.curAnim.name;

		if (FlxG.keys.pressed.E)
			FlxG.camera.zoom += 0.0025;
		if (FlxG.keys.pressed.Q)
			FlxG.camera.zoom -= 0.0025;

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -150;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 150;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -150;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 150;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim], true);

			charBG.dance();

			updateTexts();
			genBoyOffsets(false);
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			switch (switchBack)
			{
				case 'editors':
					FlxG.switchState(new MainMenuState());

				case 'PlayState':
					FlxG.switchState(new PlayState());
			}
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			// updateTexts();
			if (upP)
			{
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
				charBG.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			}

			if (downP)
			{
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
				charBG.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			}

			if (leftP)
			{
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
				charBG.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			}

			if (rightP)
			{
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
				charBG.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;
			}

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim], true);
		}

		super.update(elapsed);
	}

	function copyOffsetToClipboard()
	{
		var r = "";

		for (x in animList)
		{
			r += "addOffset(\"" + x + "\", " + char.animOffsets.get(x)[0] + ", " + char.animOffsets.get(x)[1] + ");\n";
		}

		Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, r);
	}

	function saveChar()
	{
		var char = {
			"image": char.charJson.image,
			"anims": char.charJson.anims,
			"iconName": char.charJson.iconName,
			"flipX": char.charJson.flipX,
			"flipY": char.charJson.flipY,
			"y": char.charJson.y,
			"x": char.charJson.x,
			"iconColor": char.charJson.iconColor,
			"deathCharacter": char.charJson.deathCharacter,
			"hasWinningIcon": char.charJson.hasWinningIcon
		};

		for (animOffset in animList)
		{
			for (anim in char.anims)
			{
				if (anim.anim == animOffset)
				{
					anim.x = this.char.animOffsets.get(animOffset)[0];
					anim.y = this.char.animOffsets.get(animOffset)[1];
				}
			}
		}

		if (char.flipX != true && char.flipX != false)
			char.flipX = false;
		if (char.flipY != true && char.flipY != false)
			char.flipY = false;
		if (char.iconName == null)
			char.iconName = daAnim;
		if (char.deathCharacter == null)
			char.deathCharacter = 'bf';
		if (char.hasWinningIcon != true && char.hasWinningIcon != false)
			char.hasWinningIcon = true;

		var data:String = haxe.Json.stringify(char);

		if ((data != null) && (data.length > 0))
		{
			var file = new FileReference();

			file.save(data, daAnim + '.json');
		}
	}

	function addShitIntoTheTabs()
	{
		var charUI = new FlxUI(null, UI_box);
		charUI.name = 'Character';

		var saveChar = new FlxButton(10, 30, 'Save Character', function()
		{
			saveChar();
		});
		saveChar.cameras = [camHUD];
		charUI.add(saveChar);

		var is_Player = new FlxUICheckBox(saveChar.x, saveChar.y - 20, null, null, 'is Player');
		is_Player.checked = daAnim.contains('player') || daAnim.contains('bf');
		is_Player.callback = function()
		{
			charBG.kill();
			char.kill();

			charBG = new Character(0, 0, daAnim, is_Player.checked, true);
			charBG.screenCenter();
			charBG.alpha = 0.75;
			charBG.color = 0xFF000000;
			charBG.playAnim('idle');
			add(charBG);

			char = new Character(0, 0, daAnim, is_Player.checked, true);
			char.screenCenter();
			char.charJson.flipX = is_Player.checked;
			char.playAnim('idle');
			add(char);

			updateTexts();
			genBoyOffsets(false);
		};
		charUI.add(is_Player);

		var hpBar = new FlxSprite(is_Player.x - 110, is_Player.y + 210).loadGraphic(Paths.image('ui/healthBar'));
		hpBar.scale.x = 0.3;
		charUI.add(hpBar);

		var hpBarFill = new FlxSprite(hpBar.x + 211.64, hpBar.y + 5).makeGraphic(177, 9, char.characterColor);
		charUI.add(hpBarFill);

		var icon = new HealthIcon(char.iconName, true, char.hasWinningIcons);
		icon.x = hpBarFill.x - 40;
		icon.y = hpBarFill.y - 70;
		charUI.add(icon);
		
		UI_box.addGroup(charUI);
	}
}
