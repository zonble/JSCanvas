# JSCanvas API Reference

## Drawing Functions

### `SetColor` Funtion

Sets both fill and stroke color.

#### Parameters

* *red* - 0 to 255
* *green* - 0 to 255
* *blue* - 0 to 255
* *alpha* - 0 to 255

### `SetFillColor` Funtion

Sets fill color.

#### Parameters

* *red* - 0 to 255
* *green* - 0 to 255
* *blue* - 0 to 255
* *alpha* - 0 to 255

### `SetStokeColor` Funtion

Sets stroke color.

#### Parameters

* *red* - 0 to 255
* *green* - 0 to 255
* *blue* - 0 to 255
* *alpha* - 0 to 255

### `FillRect` Function

Draws a filled rectangle.

#### Parameters

* *x* - the x-coordinate of the upper-left corner of the rectangle.
* *y* - the y-coordinate of the upper-left corner of the rectangle.
* *width* - width of the rectangle, in pixels.
* *height* - height of the rectangle, in pixels.

### `StrokeRect` Function

Draws a stroked rectangle.

#### Parameters

* *x* - the x-coordinate of the upper-left corner of the rectangle.
* *y* - the y-coordinate of the upper-left corner of the rectangle.
* *width* - width of the rectangle, in pixels.
* *height* - height of the rectangle, in pixels.

### `FillOval` Function

Draws a filled oval which fits into the given rectangle.

#### Parameters

* *x* - the x-coordinate of the upper-left corner of the rectangle.
* *y* - the y-coordinate of the upper-left corner of the rectangle.
* *width* - width of the rectangle, in pixels.
* *height* - height of the rectangle, in pixels.

### `StrokeOval` Function

Draws a stroked oval which fits into the given rectangle.

#### Parameters

* *x* - the x-coordinate of the upper-left corner of the rectangle.
* *y* - the y-coordinate of the upper-left corner of the rectangle.
* *width* - width of the rectangle, in pixels.
* *height* - height of the rectangle, in pixels.

### `Line` Function

Draw a line connecting two points.

#### Parameters

* *fromX* - the x-coordinate of the first point.
* *fromY* - The y-coordinate of the first point.
* *toX* - the x-coordinate of the second point.
* *toY* - the x-coordinate of the second point.

### `SetLineWidth` Function

Sets line width.

#### Parameters

* *width* - the width of lines, in pixels.

### `SetFontName` Function

Sets the font for drawing texts by giving specified font name.

#### Parameters

* *font_name* - name of the font, such as "Helvetica".

### `SetFontSize` Function

Sets the size of the specified font for drawing texts.

#### Parameters

* *size* - size of the font, in points.

### `Text` Function

Draws a text at a specified point.

#### Parameters

* *text* - the text.
* *x* - the x-coordinate of the specified point.
* *y* - the y-coordinate of the specified point.

### `TextBox` Function

Draw a text within a specified rectangle.

#### Parameters

* *text* - the text.
* *x* - the x-coordinate of the upper-left corner of the rectangle.
* *y* - the y-coordinate of the upper-left corner of the rectangle.
* *width* - width of the rectangle, in pixels.
* *height* - height of the rectangle, in pixels.

## Alert Messages

### `Alert` Function

Displays an alert box with a specified message and an OK button.

#### Parameters

* *title* - message contained in the alert box.

### `Confirm` Function

Displays a dialog box with a specified message, along with a Yes and a
NO button. You need to set a callback function to get the value
returned.

#### Parameters

* *title* - message contained in the alert box.
* *callback* - the callback function, such as
   `function(result){}`. The result is `1` if the Yes button is tapped,
   otherwise `0`.

### `Prompt` Function

Displays a dialog box that prompts the users for input, along with an
OK and a Cancel button.

#### Parameters

* *title* - message contained in the alert box.
* *callback* - the callback function, such as `function(text){}`. The
   function is called only when the OK button is tapped.

## Internet

### `Ajax` Function

Fetches the content of an Internet resource by giving a specified URL.

#### Parameters

* *url* - the URL.
* *callback* - the callback function, such as `function(text){}`. The
   function is called when the contents are fetched.

## Speech Synthesis

### `Say` Function

Makes your device to say something.

#### Parameters

* *text* - the text.

## Miscellaneous

### `Log` Function

Prints a text message to standard output.

#### Parameters

* *text* - the text message
