package;

import fps.Text;
import title.TitleIntroText;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{

	public static var fpsDisplay:Text;

	public static var novid:Bool = false;
	public static var flippymode:Bool = false;

	public function new()
	{
		super();

		#if sys
		novid = Sys.args().contains("-novid");
		flippymode = Sys.args().contains("-flippymode");
		#end

		addChild(new FlxGame(0, 0, TitleIntroText, 144, 144, true));

		#if !mobile
		fpsDisplay = new Text(10, 3, 0xFFFFFF);
		fpsDisplay.visible = true;
		addChild(fpsDisplay);
		#end

		#if web
		VideoHandler.MAX_FPS = 30;
		#end

		trace("-=Args=-");
		trace("novid: " + novid);
		trace("flippymode: " + flippymode);
	}
}
