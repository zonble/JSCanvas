var count = 0;

var onDraw = function() {
    SetFontName("HelveticaNeue");
    SetFontSize(17);
    Text("Tap to start counting", 10, 320);

    SetFontName("HelveticaNeue-UltraLight");
    SetFontSize(48);
    Text(count, 10, 10);
};

var onTap = function(location) {
    count++;
};
