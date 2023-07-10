function beatHit() {
    if (curBeat >= 168 && curBeat <= 200 && FlxG.camera.zoom < 1.35)
		{
			mlifBop(0.015, 0.03);
		}
}

function mlifBop(zoom:Float, zoom2:Float){
	camGame.zoom += zoom;
	camHUD.zoom += zoom2;
}