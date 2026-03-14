JSCanvas
========

> **⚠️ This project is no longer maintained and has been archived.**

JSCanvas was an experiment to build a [Processing](https://processing.org/)-like
creative-coding environment for iOS, powered by the **JavaScriptCore** framework
that Apple made public in iOS 7.

- Weizhong Yang (a.k.a zonble)
- zonble at gmail dot com

## Background & Motivation

iOS 7 (released September 2013) was the first iOS version to expose the
`JavaScriptCore` framework as a public API. Previously the framework existed
only as a private, WebKit-internal implementation detail. The new public API
let any app create a `JSContext`, inject native Objective-C blocks into it as
JavaScript functions, and call JavaScript code — all without a web view.

The goal of JSCanvas was to explore what that meant for creative coding:
could you write a tiny JavaScript "sketch" and have it draw live, animated
graphics on an iOS device using the same kinds of drawing primitives that
[Processing](https://processing.org/) or
[p5.js](https://p5js.org/) offer? The answer turned out to be yes —
and the bridging overhead was low enough that simple animations ran smoothly.

## How It Worked

The app embedded a `JSContext` and exposed a set of global JavaScript
functions that mapped directly to UIKit / Core Graphics drawing calls.
A user-supplied script was expected to define an `onDraw` function that
the app called every frame (inside `drawRect:`), plus optional event
handlers:

| JavaScript function | What it does |
|---|---|
| `onDraw()` | Called every frame to redraw the canvas |
| `onTap(location)` | Called when the user taps the canvas |
| `onSwipeLeft/Right/Up/Down()` | Called on swipe gestures |

A minimal sketch looks like this:

```javascript
var onDraw = function() {
    SetColor(255, 0, 0, 255);
    FillOval(100, 100, 80, 80);
};
```

## Drawing API

The following global functions were available inside every script:

| Function | Description |
|---|---|
| `SetColor(r, g, b, a)` | Set fill and stroke color (0–255) |
| `SetFillColor(r, g, b, a)` | Set fill color only |
| `SetStrokeColor(r, g, b, a)` | Set stroke color only |
| `FillRect(x, y, w, h)` | Draw a filled rectangle |
| `StrokeRect(x, y, w, h)` | Draw a stroked rectangle |
| `FillOval(x, y, w, h)` | Draw a filled oval |
| `StrokeOval(x, y, w, h)` | Draw a stroked oval |
| `Line(x1, y1, x2, y2)` | Draw a line |
| `SetLineWidth(w)` | Set line width |
| `SetFontName(name)` | Set font by name (e.g. `"Helvetica"`) |
| `SetFontSize(size)` | Set font size in points |
| `Text(text, x, y)` | Draw text at a point |
| `TextBox(text, x, y, w, h)` | Draw text inside a rectangle |
| `Alert(title)` | Show an alert dialog |
| `Confirm(title, callback)` | Show a Yes/No dialog |
| `Prompt(title, callback)` | Show a text-input dialog |
| `Ajax(url, callback)` | Fetch a URL asynchronously |
| `Say(text)` | Speak text via AVSpeechSynthesizer |
| `Log(text)` | Print to the Xcode console |

See [API.md](API.md) for full parameter details.

## Bundled Samples

The `samples/` directory contains several ready-to-run sketches that
demonstrate the API:

| File | What it demonstrates |
|---|---|
| `clock.js` | Analog clock using `Line`, `Text`, and `Say` |
| `snake.js` | Playable Snake game with swipe controls |
| `counter.js` | Simple tap counter using `Text` and `onTap` |
| `lines.js` | Animated line drawing |
| `oval.js` | Bouncing oval animation |
| `moveme.js` | Shape that follows your tap |
| `temperature_converter.js` | `Prompt` / `Alert` UI pattern |
| `ajax.js` / `ajax2.js` | Fetching remote data with `Ajax` |
| `say.js` | Text-to-speech demo |

## Requirement

- iOS 7
- Xcode 5
