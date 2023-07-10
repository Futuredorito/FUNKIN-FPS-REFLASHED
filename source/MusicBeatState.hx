package;

import flixel.FlxG;
import Conductor.BPMChangeEvent;

class MusicBeatState extends UIStateExt
{
	public var lastBeat:Float = 0;
	public var lastStep:Float = 0;

	public var totalBeats:Int = 0;
	public var totalSteps:Int = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		everyStep();

		updateCurStep();
		// Needs to be ROUNED, rather than ceil or floor
		updateBeat();

		super.update(elapsed);
	}

	function updateBeat():Void
	{
		curBeat = Math.round(curStep / 4);
	}

	/**
	 * CHECKS EVERY FRAME
	 */
	function everyStep():Void
	{
		if (Conductor.songPosition > lastStep + Conductor.stepCrochet - Conductor.safeZoneOffset
			|| Conductor.songPosition < lastStep + Conductor.safeZoneOffset)
		{
			if (Conductor.songPosition > lastStep + Conductor.stepCrochet)
			{
				stepHit();
			}
		}
	}

	function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		totalSteps += 1;
		lastStep += Conductor.stepCrochet;

		// If the song is at least 3 steps behind
		if (Conductor.songPosition > lastStep + (Conductor.stepCrochet * 3))
		{
			lastStep = Conductor.songPosition;
			totalSteps = Math.ceil(lastStep / Conductor.stepCrochet);
		}

		if (totalSteps % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		lastBeat += Conductor.crochet;
		totalBeats += 1;
	}
}
