var text = "";

var setup = function() {
    Ajax("http://zonble.net/test.js",
         function(r) {
            eval(r);
         });
};

var onDraw = function() {
    SetFontSize(50);
    Text(text, 10, 10);
}