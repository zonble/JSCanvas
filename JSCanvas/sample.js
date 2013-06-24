// Please write your own drawing code within in "onDraw" function.

onDraw = function () {
	var d = new Date();
	var sec = d.getSeconds();
	var minute = d.getMinutes();
	var w = sec / 60 * 300;
	SetLineWidth(2);
	SetFillColor(255, 255, 0, 255);
	FillRect(10, 30, 300, 80);
	SetFillColor(0, 0, 0, 255);
	FillRect(10, 30, w, 80);
	SetStrokeColor(0, 0, 0, 255);
	StrokeRect(10, 30, 300, 80);

	SetLineWidth(4);
	Line(10, 150, 310, 150);

	SetFontName("Marker Felt");
	SetFontSize(72);
	Text(minute + ":" + sec, 10, 160);
};