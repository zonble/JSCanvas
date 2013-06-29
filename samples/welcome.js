// Tap on the "Run" button to run the script.

var contents = [
{title:'Welcome!',
 body:'Powered by JavaScriptCore, one of the most advanced technologies of Apple, JSCanvas helps to build your own tools, on your own device!'},
{title:'Draw Something',
 body:'Implement "onDraw" to do drawing.\n\nvar onDraw = function() {\n	// Set Color\n	SetFillColor(255, 255, 0, 255);\n	// Fill\n	FillRect(10, 10, 100, 100)\n}\n'},
{title:'Play with It',
 body:'Implement event handler such as "onTap" and so on to do interaction with your JavaScript code.'},
{title:'Say Something',
 body:'Simply call "Say".\n\nvar onTap = function() {\n    Say("Hi!");\n};'},
{title:'Have Fun!',
 body:'Happy hacking! :)'}
];

var count = 0;

var onDraw = function() {
    SetFontName("HelveticaNeue-UltraLight");
    SetFontSize(48);
    TextBox(contents[count].title, 20, 20, 260, 200);

    SetFontName("HelveticaNeue");
    SetFontSize(15);
    TextBox(contents[count].body, 40, 150, 260, 300);

};

var onTap = function(location) {
	if (count < contents.length - 1) count++;
	else count = 0;
};
