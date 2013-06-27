var setup = function() {
};

var randromColor = function() {
    var r = Math.random() * 255;
    var g = Math.random() * 255;
    var b = Math.random() * 255;
    SetFillColor(r, g, b, 128);
}

var onDraw = function() {
    for (var i = 6; i >= 0; i--) {
        if (i % 2 == 0) {
             randromColor();
        }
        else {
             SetFillColor(255, 255, 255, 255);
        }
        SetStrokeColor(0, 0, 0, 255);
        FillOval(160 - 25*i, 160 - 25*i, 50*i, 50*i)
        StrokeOval(160 - 25*i, 160 - 25*i, 50*i, 50*i)
    }
};