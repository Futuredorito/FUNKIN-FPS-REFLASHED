function beatHit() {
    if (curBeat >= 168 && curBeat <= 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			uiBop(0.015, 0.03);
		}

		if (curBeat == 168)
		{
			dadBeats = [0, 1, 2, 3];
			bfBeats = [0, 1, 2, 3];
		}

		if (curBeat == 200)
		{
			dadBeats = [0, 2];
			bfBeats = [1, 3];
		}
}