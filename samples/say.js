var setup = function() {
};

var onDraw = function() {
    SetFontName("HelveticaNeue-UltraLight");
    SetFontSize(48);
    Text("Tap to speak", 10, 100);
};

var onTap = function(location) {
	Say("Welcome to JSCanvas!");
};