import Note;

var colors:Array<String> = ['purple', 'blue', 'green', 'red'];

function createPost()
{
	for (i in unspawnNotes)
	{
		if (i.isSustainNote)
		{
			i.loadGraphic(Paths.image('week6/weeb/pixelUI/arrowEnds'), true, 7, 6);

			i.animation.add('purpleholdend', [4]);
			i.animation.add('greenholdend', [6]);
			i.animation.add('redholdend', [7]);
			i.animation.add('blueholdend', [5]);

			i.animation.add('purplehold', [0]);
			i.animation.add('greenhold', [2]);
			i.animation.add('redhold', [3]);
			i.animation.add('bluehold', [1]);

			if (i.isSustainNote && i.prevNote != null)
			{
				i.alpha = 0.6;
				i.flipY = Config.downscroll;
				i.animation.play(colors[i.noteData] + 'holdend');
				if (i.prevNote.isSustainNote)
				{
					i.prevNote.animation.play(colors[i.noteData] + 'hold');
					i.prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
					i.prevNote.updateHitbox();
				}
			}
		}
		else
		{
			i.loadGraphic(Paths.image('week6/weeb/pixelUI/arrows-pixels'), true, 19, 19);

			i.animation.add('greenScroll', [6]);
			i.animation.add('redScroll', [7]);
			i.animation.add('blueScroll', [5]);
			i.animation.add('purpleScroll', [4]);

			i.animation.play(colors[i.noteData] + 'Scroll');
		}

		i.setGraphicSize(Std.int(i.width * PlayState.daPixelZoom));
		i.updateHitbox();
		i.antialiasing = false;
	}
}

function generateStaticArrows(player, note, babyArrow)
{
	babyArrow.loadGraphic(Paths.image('week6/weeb/pixelUI/arrows-pixels'), true, 19, 19);
	babyArrow.animation.add('green', [6]);
	babyArrow.animation.add('red', [7]);
	babyArrow.animation.add('blue', [5]);
	babyArrow.animation.add('purplel', [4]);

	babyArrow.setGraphicSize(Std.int(babyArrow.width * PlayState.daPixelZoom));
	babyArrow.updateHitbox();
	babyArrow.antialiasing = false;

	switch (note)
	{
		case 2:
			// babyArrow.x += Note.swagWidth * 2;
			babyArrow.animation.add('static', [2]);
			babyArrow.animation.add('pressed', [26, 10], 12, false);
			babyArrow.animation.add('confirm', [30, 14, 18], 24, false);
		case 3:
			// babyArrow.x += Note.swagWidth * 3;
			babyArrow.animation.add('static', [3]);
			babyArrow.animation.add('pressed', [27, 11], 12, false);
			babyArrow.animation.add('confirm', [31, 15, 19], 24, false);
		case 1:
			// babyArrow.x += Note.swagWidth * 1;
			babyArrow.animation.add('static', [1]);
			babyArrow.animation.add('pressed', [25, 9], 12, false);
			babyArrow.animation.add('confirm', [29, 13, 17], 24, false);
		case 0:
			// babyArrow.x += Note.swagWidth * 0;
			babyArrow.animation.add('static', [0]);
			babyArrow.animation.add('pressed', [24, 8], 12, false);
			babyArrow.animation.add('confirm', [28, 12, 16], 24, false);
	}
}

function updatePost(elapsed)
{
	for (strum in enemyStrums)
	{
		strum.centerOffsets();
	}

	for (strum in playerStrums)
	{
		strum.centerOffsets();
	}
}
