package;

import haxe.Json;
import openfl.Assets;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

typedef AnimLoading =
{
	var prefix:String;
	var anim:String;
	var x:Float;
	var y:Float;
	var looped:Bool;
	var fps:Int;
	var indices:Array<Int>;
}

typedef CharacterLoading =
{
	var image:String;
	var flipX:Bool;
	var flipY:Bool;
	var charPos:Array<Float>;
	var charCamPos:Array<Float>;
	var iconName:String;
	var deathCharacter:String;
	var iconColor:String;
	var hasWinningIcon:Bool;
	var anims:Array<AnimLoading>;
}

class Character extends FlxSprite
{
	// Global character properties.
	public var LOOP_ANIM_ON_HOLD:Bool = true; // Determines whether hold notes will loop the sing animation. Default is true.
	public var USE_IDLE_END:Bool = true; // Determines whether you will go back to the start of the idle or the end of the idle when letting go of a note. Default is true for FPS Plus, false for base game.

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	public var stepsUntilRelease:Float = 4;

	public var canAutoAnim:Bool = true;
	public var danceLockout:Bool = false;
	public var animSet:String = "";

	public var deathCharacter:String = "bf";
	public var iconName:String;
	public var characterColor:Null<FlxColor> = null;
	public var charJson:CharacterLoading;

	public var facesLeft:Bool = false;
	public var hasWinningIcons:Bool = true;

	public var camX:Float;
	public var camY:Float;
	public var charX:Float;
	public var charY:Float;

	var script:HScript;

	public function new(x:Float, y:Float, ?character:String = "bf", ?_isPlayer:Bool = false, ?_enableDebug:Bool = false)
	{
		debugMode = _enableDebug;
		animOffsets = new Map<String, Array<Dynamic>>();

		super(x, y);

		curCharacter = character;
		isPlayer = _isPlayer;
		antialiasing = true;

		var character = this;

		#if sys
		script = new HScript('characters/$curCharacter');
		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = this;
			script.setValue('character', character);
			script.interp.execute(script.expr);
		}
		else
		{
			loadByJson('dad');
		}

		script.callFunction('create');
		#else
		loadByJson('dad');
		#end

		if (iconName == null)
			iconName = curCharacter;

		dance();

		if (((facesLeft && !isPlayer) || (!facesLeft && isPlayer)))
		{
			flipX = true;

			// var animArray
			var oldRight = animation.getByName("singRIGHT").frames;
			var oldRightOffset = animOffsets.get("singRIGHT");
			animation.getByName("singRIGHT").frames = animation.getByName("singLEFT").frames;
			animOffsets.set("singRIGHT", animOffsets.get("singLEFT"));
			animation.getByName('singLEFT').frames = oldRight;
			animOffsets.set("singLEFT", oldRightOffset);

			// IF THEY HAVE MISS ANIMATIONS??
			if (animation.getByName('singRIGHTmiss') != null)
			{
				var oldMiss = animation.getByName("singRIGHTmiss").frames;
				var oldMissOffset = animOffsets.get("singRIGHTmiss");
				animation.getByName("singRIGHTmiss").frames = animation.getByName("singLEFTmiss").frames;
				animOffsets.set("singRIGHTmiss", animOffsets.get("singLEFTmiss"));
				animation.getByName('singLEFTmiss').frames = oldMiss;
				animOffsets.set("singLEFTmiss", oldMissOffset);
			}
		}

		animation.finishCallback = function(anim)
		{
			danceLockout = false;
		};

		if (characterColor == null)
		{
			characterColor = (isPlayer) ? 0xFF66FF33 : 0xFFFF0000;
		}
	}

	override function update(elapsed:Float)
	{
		#if sys
		script.callFunction('update', [elapsed]);
		#end

		if (!debugMode)
		{
			if (!isPlayer)
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}

				if (holdTimer >= Conductor.stepCrochet * stepsUntilRelease * 0.001 && canAutoAnim)
				{
					if (USE_IDLE_END)
					{
						idleEnd();
					}
					else
					{
						dance();
						danceLockout = true;
					}
					holdTimer = 0;
				}
			}
			else
			{
				if (animation.curAnim.name.startsWith('sing'))
				{
					holdTimer += elapsed;
				}
				else
				{
					holdTimer = 0;
				}

				if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && canAutoAnim)
				{
					if (USE_IDLE_END)
					{
						idleEnd();
					}
					else
					{
						dance();
						danceLockout = true;
					}
				}
			}

			switch (curCharacter)
			{
				case 'gf':
					if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
						playAnim('danceRight');
			}
		}

		super.update(elapsed);
		changeOffsets();
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?ignoreDebug:Bool = false)
	{
		#if sys
		script.callFunction('dance');
		#end

		if (!debugMode || ignoreDebug)
		{
			if (danceLockout)
			{
				danceLockout = false;
				return;
			}

			playAnim('idle', true);
		}
	}

	public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "spooky" | "gf-tankmen":
					playAnim('danceRight', true, false, animation.getByName('danceRight').numFrames - 1);
				case "pico-speaker":
					playAnim(animation.curAnim.name, true, false, animation.getByName(animation.curAnim.name).numFrames - 1);
				default:
					playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animSet != "")
		{
			if (animation.exists(AnimName + "-" + animSet))
			{
				AnimName = AnimName + "-" + animSet;
			}
			else
			{
				trace(AnimName + "-" + animSet + " not found. Reverting to " + AnimName);
			}
		}

		animation.play(AnimName, Force, Reversed, Frame);
		changeOffsets();
	}

	function changeOffsets()
	{
		if (animation.curAnim != null && animation.curAnim.name != null && animOffsets.exists(animation.curAnim.name))
		{
			var animOffset = animOffsets.get(animation.curAnim.name);
			var xOffsetAdjust:Float = animOffset[0];
			if (flipX == true)
			{
				xOffsetAdjust *= -1;
				xOffsetAdjust += frameWidth;
				xOffsetAdjust -= width;
			}
			offset.set(xOffsetAdjust, animOffset[1]);
		}
		else
		{
			offset.set(0, 0);
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function loadByJson(char:String)
	{
		if (!Assets.exists(Paths.json(char, 'characters')))
			charJson = Json.parse(Assets.getText(Paths.json('dad', 'characters')));
		else
			charJson = Json.parse(Assets.getText(Paths.json(char, 'characters')));

		frames = Paths.getSparrowAtlas(charJson.image);

		for (anim in charJson.anims)
		{
			if (anim.fps < 0)
				anim.fps = 24;
			if (anim.looped != true && anim.looped != false)
				anim.looped = false;

			if (anim.indices != null)
				animation.addByIndices(anim.anim, anim.prefix, anim.indices, "", anim.fps, anim.looped);
			else
				animation.addByPrefix(anim.anim, anim.prefix, anim.fps, anim.looped);

			addOffset(anim.anim, anim.x, anim.y);
		}

		stepsUntilRelease = 6.1;

		if (charJson.iconName != null)
			iconName = charJson.iconName;
		if (charJson.iconColor != null)
			characterColor = FlxColor.fromString(charJson.iconColor);
		if (charJson.deathCharacter != null)
			deathCharacter = charJson.deathCharacter;
		hasWinningIcons = charJson.hasWinningIcon;
		facesLeft = charJson.flipX;
		flipY = charJson.flipY;
		camX = charJson.charCamPos[0];
		camY = charJson.charCamPos[1];
		charX = charJson.charPos[0];
		charY = charJson.charPos[1];
	}
}
