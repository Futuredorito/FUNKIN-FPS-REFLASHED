var black;

function create() {
    black = new FlxSprite().makeGraphic(FlxG.width * 10, FlxG.height * 10, 0xff070707);
    black.screenCenter();
    add(black);
    black.visible = false;
}

function update(elapsed) {
    switch (curStep){
        case 495:
            FlxTween.tween(FlxG.camera, {alpha: 0}, 0.3);
            black.visible = true;

        case 511:
            FlxTween.tween(FlxG.camera, {alpha: 1}, 0.015);

        case 770:
            FlxTween.tween(FlxG.camera, {alpha: 0}, 0.3, {onComplete: function(tween) {
                FlxTween.tween(FlxG.camera, {alpha: 1}, 0.015);
                black.visible = false;    
            }});
    }
}

function beatHit() {
    if (curStep > 511 && curStep < 770 && curBeat % 2 == 0){
        camHUD.zoom += 0.15;
        FlxG.camera.zoom += 0.10;
    }
}