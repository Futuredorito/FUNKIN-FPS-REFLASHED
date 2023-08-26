function create()
	{
		character.loadByJson('gf');
	}
	
	var danced = false;
	
	function dance()
	{
		danced = !danced;
	
		if (danced)
			character.playAnim('danceRight', true);
		else
			character.playAnim('danceLeft', true);
	}