package;

import flixel.math.FlxMath;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var id:Int;

	public var isPlayer:Bool = false;
	public var character:String = "face";

	public var pixelIcons:Array<String> = ["bf-pixel", "senpai", "senpai-angry", "spirit"];
	public var hasWinning:Bool;
	public var canAutoAnim = true;

	var scripts:Array<HScript>;

	var paths:Array<String> = ['ui/heathIcons/', 'icons/', 'icons/icon-'];

	public function new(_character:String = 'face', _isPlayer:Bool = false, _hasWinning:Bool)
	{
		super();

		scripts = new Array<HScript>();

		for (path in paths)
		{
			var script = new HScript('images/' + path + _character);

			if (!script.isBlank && script.expr != null)
			{
				script.interp.scriptObject = this;
				script.setValue('icon', this);
				script.interp.execute(script.expr);
			}

			scripts.push(script);
		}

		#if sys
		for (script in scripts)
			script.callFunction('create');
		#end

		isPlayer = _isPlayer;
		character = _character;

		hasWinning = _hasWinning;

		setIconCharacter(character);

		scrollFactor.set();

		#if sys
		for (script in scripts)
			script.callFunction('createPost');
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if sys
		for (script in scripts)
			script.callFunction('update', [elapsed]);
		#end

		updateHitbox();

		scale.x = FlxMath.lerp(0.95, scale.x, 0.96);
		scale.y = FlxMath.lerp(0.95, scale.y, 0.98);

		if (sprTracker != null)
		{
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
		}

		#if sys
		for (script in scripts)
			script.callFunction('updatePost', [elapsed]);
		#end
	}

	public function setIconCharacter(character:String)
	{
		#if sys
		for (script in scripts)
			script.callFunction('setIconCharacter', [character]);
		#end

		if (openfl.Assets.exists(Paths.image(paths[0] + character)))
			loadGraphic(Paths.image(paths[0] + character), true, 150, 150);
		else if (openfl.Assets.exists(Paths.image(paths[1] + character)))
			loadGraphic(Paths.image(paths[1] + character), true, 150, 150);
		else if (openfl.Assets.exists(Paths.image(paths[2] + character)))
			loadGraphic(Paths.image(Paths.image(paths[2] + character)), true, 150, 150);
		else
			loadGraphic(Paths.image("ui/heathIcons/face"), true, 150, 150);

		if (canAutoAnim)
		{
			if (!hasWinning)
				animation.add("icon", [0, 1], 0, false, isPlayer);
			else
				animation.add("icon", [0, 1, 2], 0, false, isPlayer);
			animation.play("icon");
		}

		antialiasing = !pixelIcons.contains(character);

		#if sys
		for (script in scripts)
			script.callFunction('setIconCharacterPost', [character]);
		#end
	}
}
