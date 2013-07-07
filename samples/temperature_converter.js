var celsius = 0;
var celsiusRect = Rect(10, 10, 300, 40);
var fahrenheit = 0;
var fahrenheitRect = Rect(10, 60,300, 40);

var celsiusToFahrenheit = function() {
    fahrenheit = celsius*9/5 + 32;
};

var fahrenheitToCelsius = function() {
    celsius = (fahrenheit - 32)*5/9;
}

var setup = function() {
    celsius = 20;
    celsiusToFahrenheit();
};

var onDraw = function() {
    SetFontSize(30);
    SetFillColor(0, 0, 0, 16);
    celsiusRect.Fill();
    fahrenheitRect.Fill();
    SetColor(0, 0, 0, 255);
    Text("Celsius:" + celsius.toFixed(2),
         celsiusRect.x, celsiusRect.y);
    Text("Fahrenheit:" + fahrenheit.toFixed(2),
         fahrenheitRect.x, fahrenheitRect.y);
};

var pointInRect = function(point, rect) {
    var inRect =  (point.x >= rect.x &&
        point.x <= rect.x + rect.width &&
        point.y >= rect.y &&
        point.y <= rect.y + rect.height);
    return inRect;
}

var onTap = function(location) {
    if (pointInRect(location, celsiusRect)) {
        Prompt("Celsius", function(text) {
            celsius = parseInt(text);
            celsiusToFahrenheit();
        });
    }
    else if (pointInRect(location, fahrenheitRect)) {
        Prompt("Fahrenheit", function(text) {
            fahrenheit = parseInt(text);
            fahrenheitToCelsius();
        });
    }
};
