package;

import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var id:Int;

	public var defualtIconScale:Float = 1;
	public var iconScale:Float = 1;
	public var iconSize:Float;
	public var isPlayer:Bool = false;
	public var character:String = "face";

	private var tween:FlxTween;

	private static final pixelIcons:Array<String> = ["bf-pixel", "senpai", "senpai-angry", "spirit"];

	public function new(_character:String = 'face', _isPlayer:Bool = false)
	{
		super();

		isPlayer = _isPlayer;

		character = _character;

		setIconCharacter(character);

		iconSize = width;
		
		scrollFactor.set();

		tween = FlxTween.tween(this, {}, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		setGraphicSize(Std.int(iconSize * iconScale));
		updateHitbox();

		if (sprTracker != null){
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
		}
	}

	public function tweenToDefaultScale(_time:Float, _ease:Null<flixel.tweens.EaseFunction>){

		tween.cancel();
		tween = FlxTween.tween(this, {iconScale: this.defualtIconScale}, _time, {ease: _ease});
	}

	public function setIconCharacter(character:String){
		if (openfl.Assets.exists(Paths.image("ui/heathIcons/" + character)))
			loadGraphic(Paths.image("ui/heathIcons/" + character), true, 150, 150);
		else if (openfl.Assets.exists(Paths.image("icons/" + character)))
			loadGraphic(Paths.image("icons/" + character), true, 150, 150);
		else if (openfl.Assets.exists(Paths.image("icons/icon-" + character)))
			loadGraphic(Paths.image(Paths.image("icons/icon-" + character)), true, 150, 150);
		else
			loadGraphic(Paths.image("ui/heathIcons/face"), true, 150, 150);

		animation.add("icon", [0, 1, 2], 0, false, isPlayer);
		animation.play("icon");

		antialiasing = !pixelIcons.contains(character);
	}
}
