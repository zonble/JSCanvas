var offset = 0;

var randromColor = function() {
    var r = Math.random() * 255;
    var g = Math.random() * 255;
    var b = Math.random() * 255;
    SetStrokeColor(r, g, b, 128);
}

var onDraw = function() {
    offset += 10;
    if (offset > 320) {
        offset = 0;
    }
    SetLineWidth(10);
    randromColor()
    Line(0, offset, offset, 320);
    randromColor()
    Line(0, 320 - offset, 320 - offset, 320);
    randromColor()
    Line(offset, 0, 0, 320 - offset);
    randromColor()
    Line(0, 320 - offset, 0, 320 - offset);
};