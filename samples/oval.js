var onDraw = function() {
    for (var i = 6; i >= 0; i--) {
        if (i % 2 == 0) {
             SetFillColor(255, 0, 0, 255);
        }
        else {
             SetFillColor(255, 255, 255, 255);
        }
        SetStrokeColor(0, 0, 0, 255);
        FillOval(160 - 25*i, 160 - 25*i, 50*i, 50*i)
        StrokeOval(160 - 25*i, 160 - 25*i, 50*i, 50*i)
    }
};