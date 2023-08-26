package;

#if sys
import sys.FileSystem;
#end
import lime.app.Application;
import config.*;
import title.TitleScreen;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options', 'credits'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var script:HScript;

	override function create()
	{
		DiscordClient.changePresence('In the menus.', '');

		#if sys
		if (FileSystem.exists('./mods'))
		{
			for (i => mods in FileSystem.readDirectory('./mods'))
				if (i > 0 && !optionShit.contains('mods'))
					optionShit.insert(2, 'mods');
		}
		#end

		script = new HScript('states/MainMenuState');

		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = this;
			script.setValue('add', add);
			script.interp.execute(script.expr);
		}

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), 1);
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuBGMagenta'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.18));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);

		#if sys
		script.callFunction('create');
		#end

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 80 + (i * 160));
			menuItem.frames = Paths.getSparrowAtlas('menu/options/' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			if (menuItem.animation.exists('idle'))
				menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set(0, 0.95);
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.004);

		var versionText = new FlxText(5, FlxG.height - 65, 0, '', 16);

		for (i => version in Application.current.meta.get('version').split('|'))
		{
			if (i == 2)
				versionText.text += '\n' + 'FPS REFLASHED V:' + Application.current.meta.get('version').split('|')[2];
			else
				versionText.text += '\n' + version;
		}

		versionText.scrollFactor.set();
		versionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);

		changeItem();

		// Offset Stuff
		Config.reload();

		if (Config.noFpsCap)
		{
			FlxG.stage.frameRate = 999;
			FlxG.drawFramerate = 999;
			// FlxG.updateFramerate = 999;
			// FlxG.fixedTimestep = false;
			trace('shit');
		}

		#if sys
		script.callFunction('createPost');
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		#if sys
		script.callFunction('update', [elapsed]);
		#end

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (FlxG.keys.justPressed.BACKSPACE)
			{
				KeyBinds.resetBinds();
				switchState(new MainMenuState());
			}

			if (controls.BACK)
			{
				switchState(new TitleScreen());
			}

			if (FlxG.keys.justPressed.SEVEN && Config.debug)
				openSubState(new editors.ToolBox());

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				var daChoice:String = optionShit[curSelected];

				#if sys
				script.callFunction('select', [daChoice]);
				#end

				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							spr.visible = true;

							switch (daChoice)
							{
								case 'story mode':
									switchState(new StoryMenuState());

								case 'freeplay':
									if (FreeplayState.startingSelection < 0)
										FreeplayState.startingSelection = 0;

									switchState(new FreeplayState());

								case 'mods':
									switchState(new ModSelectState());

								case 'options':
									switchState(new ConfigMenu());

								case 'credits':
									switchState(new CreditsMenu());
							}
						});
					}
				});
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});

		#if sys
		script.callFunction('updatePost', [elapsed]);
		#end
	}

	function changeItem(huh:Int = 0)
	{
		#if sys
		script.callFunction('changeItem', [huh]);
		#end

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});

		#if sys
		script.callFunction('changeItemPost', [huh]);
		#end
	}
}
