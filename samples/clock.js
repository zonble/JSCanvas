var setup = function()  {
};

var onDraw = function() {
    SetColor(200, 200, 200, 255);
    SetFontName("Marker Felt");
    SetFontSize(32);
    Text("JSCanvas!", 100, 220);

    var d = new Date();
    var minute = d.getMinutes();
    var second = d.getSeconds();
    var hour = d.getHours() % 12 + minute / 60;

    SetFontSize(15);
    SetColor(0, 0, 0, 255);
    for (i = 0; i < 12; i ++) {
        var X = 140*Math.sin(i/12*Math.PI*2);
        var Y = 140*Math.cos(i/12*Math.PI*2)*-1;
        Text(i == 0 ? 12 : i + "", 160 + X - 2 , 160 + Y);
    }

    var sX = 120 * Math.sin(second/60*Math.PI*2);
    var sY = 120 * Math.cos(second/60*Math.PI*2) * -1;
    SetLineWidth(1);
    SetStrokeColor(255, 0, 0, 255);
    Line(160, 160, 160 + sX, 160 + sY);

    var mX = 110 * Math.sin(minute/60*Math.PI*2);
    var mY = 110 * Math.cos(minute/60*Math.PI*2) * -1;
    SetLineWidth(3);
    SetStrokeColor(50, 50, 50, 255);
    Line(160, 160, 160 + mX, 160 + mY);

    var hX = 90 * Math.sin(hour/12*Math.PI*2);
    var hY = 90 * Math.cos(hour/12*Math.PI*2)*-1;
    SetLineWidth(10);
    SetStrokeColor(0, 0, 0, 255);
    Line(160, 160, 160 + hX, 160 + hY);

    FillOval(150, 150, 20, 20);

    if (currentLocation && currentLocation != null) {
        SetFillColor(255, 0, 0, 100);
        FillOval(currentLocation.x - 25,
                 currentLocation.y - 25, 50, 50);
    }
};

var currentLocation = null;

var onTap = function(location) {
    currentLocation = location;
};