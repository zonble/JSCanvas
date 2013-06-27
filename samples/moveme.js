var x = 160;
var y = 320;

var onDraw = function() {
	SetFillColor(255, 0, 0, 100);
	FillOval(x - 25, y - 50, 50, 50);
	SetStrokeColor(0, 0, 0, 100);
	Line(0, y, 320, y);
};

var onTap = function(location) {
	if (location.x < 160) {
		x -= 10;
		if (x < 0) x = 0;
	}
	else if (location.x > 160) {
		x += 10;
		if (x > 320) x = 320;
	}

};
