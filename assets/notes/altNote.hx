function create() {
    note.canAutoAnim = false;
}

function dadNoteHit(daNote) {
    var anims = ['singLEFT', 'singUP', 'singDOWN', 'singRIGHT'];

    character.playAnim(anims[daNote.noteData] + '-alt');
}

function bfNoteHit(daNote) {
    var anims = ['singLEFT', 'singUP', 'singDOWN', 'singRIGHT'];

    character.playAnim(anims[daNote.noteData] + '-alt');
}