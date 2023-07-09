package;

import haxe.Json;
import openfl.Assets;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

typedef AnimLoader =
{
	var animations:Array<String>;
	var prefixes:Array<String>;
	var animToPlay:String;
	var fps:Int;
	var animOnBeat:Bool;
	var looped:Bool;
}

typedef ObjectLoader =
{
	var image:String;
	var animated:Bool;
	var animations:Array<AnimLoader>;
	var x:Float;
	var y:Float;
	var scrollX:Float;
	var scrollY:Float;
	var scaleX:Float;
	var scaleY:Float;
	var alpha:Float;
	var visible:Bool;
}

typedef StageLoader =
{
	var camZoom:Float;
	var objects:Array<ObjectLoader>;
	/*var dadPos:Array<Float>;
		var bfPos:Array<Float>;
		var gfPos:Array<Float>; */
}

class Stage extends FlxTypedGroup<FlxBasic>
{
	public static var script:HScript;

	public static var stage:StageLoader;

	public static var objects:FlxTypedGroup<FlxSprite>;

	override public function new(stageString:String, state:PlayState)
	{
		super();

		if (stageString == null)
			stageString = 'stage';

		objects = new FlxTypedGroup<FlxSprite>();
		add(objects);

		#if sys
		script = new HScript('stages/$stageString');
		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = state;
			script.setValue("objects", objects);
			script.setValue("add", add);
			script.setValue("remove", remove);
			script.interp.execute(script.expr);
		}
		script.callFunction("create");
		#end
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if sys
		script.callFunction('update', [update]);
		#end
	}

	public function stepHit()
	{
		#if sys
		script.callFunction('stepHit');
		#end
	}

	public function beatHit()
	{
		#if sys
		script.callFunction('beatHit');
		#end

		if (objects.length > 0 && objects != null && stage.objects != null && stage.objects != [null])
		{
			for (i => object in stage.objects)
			{
				if (object.animations != null && object.animations != [] && object.animations != [null])
					for (anims in object.animations)
					{
						if (anims.animOnBeat)
						{
							objects.members[i].animation.play(anims.animToPlay);
						}
					}
			}
		}
	}

	public static function loadByJson(stageJson:String)
	{
		if (Assets.exists(Paths.json(stageJson, 'stages')))
			stage = Json.parse(Assets.getText(Paths.json(stageJson, 'stages')));
		else
			stage = Json.parse(Assets.getText(Paths.json('stage', 'stages')));

		PlayState.instance.defaultCamZoom = stage.camZoom;

		for (sprite in stage.objects)
		{
			var object = new FlxSprite(sprite.x, sprite.y);
			if (sprite.animated)
			{
				object.frames = Paths.getSparrowAtlas(sprite.image);
				for (i => anim in sprite.animations)
				{
					if (anim.fps < 0)
					{
						anim.fps = 24;
					}

					object.animation.addByPrefix(anim.animations[i], anim.prefixes[i], anim.fps, anim.looped);
					if (!anim.animOnBeat)
						object.animation.play(anim.animToPlay, true);
				}
			}
			else
				object.loadGraphic(Paths.image(sprite.image));

			if (sprite.scrollX < 0)
				sprite.scrollX = 1;
			if (sprite.scrollY < 0)
				sprite.scrollX = 1;
			if (sprite.alpha < 0)
				sprite.alpha = 1;
			if (sprite.visible = false)
				object.alpha = sprite.alpha;
			object.scrollFactor.set(sprite.scrollX, sprite.scrollY);
			if (sprite.visible)
				object.visible = true;

			object.updateHitbox();
			objects.add(object);
		}
	}
}
