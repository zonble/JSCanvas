var text = "";

var setup = function() {
    Ajax("http://apple.com",
         function(response) {
            text = response;
         });
}

var onDraw = function() {
    TextBox(text, 10, 10, 300, 300);
};
