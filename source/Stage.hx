package;

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class Stage extends FlxTypedGroup<FlxBasic>
{
	var script:HScript;

	override public function new(stage:String, state:PlayState)
	{
		super();

		#if sys
		script = new HScript('assets/stages/$stage');

		if (!script.isBlank && script.expr != null)
		{
			script.interp.scriptObject = state;
			script.setValue("yooo", true);
            script.setValue("add", add);
			script.setValue("insert", insert);
			script.setValue("remove", remove);
			script.interp.execute(script.expr);
		}
		else
		{
			state.defaultCamZoom = 0.9;
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image("week1/stageback"));
			// bg.setGraphicSize(Std.int(bg.width * 2.5));
			// bg.updateHitbox();
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

			var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image("week1/stagefront"));
			stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
			stageFront.updateHitbox();
			stageFront.antialiasing = true;
			stageFront.scrollFactor.set(0.9, 0.9);
			stageFront.active = false;
			add(stageFront);

			var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image("week1/stagecurtains"));
			stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
			stageCurtains.updateHitbox();
			stageCurtains.antialiasing = true;
			stageCurtains.scrollFactor.set(1.3, 1.3);
			stageCurtains.active = false;

			add(stageCurtains);
		}

		script.callFunction("create");
		#else
		PlayState.defaultCamZoom = 0.9;
		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image("week1/stageback"));
		// bg.setGraphicSize(Std.int(bg.width * 2.5));
		// bg.updateHitbox();
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg);

		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image("week1/stagefront"));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image("week1/stagecurtains"));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;

		add(stageCurtains);
		#end
	}

    override public function update(elapsed:Float) {
        super.update(elapsed);

        #if sys
        script.callFunction('update', [update]);
        #end
    }

    public function stepHit()
        script.callFunction('stepHit');

    public function beatHit()
        script.callFunction('beatHit');
}
