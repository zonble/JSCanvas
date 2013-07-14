@import Foundation;
@import UIKit;
@import JavaScriptCore;

/*! An object which manages our JavaScript context. It loads and
 *  evaluate JavaScript code, and provides the drawing function to be
 *  called by views. */
@interface ZBCanvasManager : NSObject

/*! Load code in JavaScript language and evaluate it. The script shall
 *  contain a function object whose name is "onDraw".
 * \param script The script */
- (void)loadJavaScript:(NSString *)script;

/*! Run the "onDraw" function from the JavaScript code loaded
 *  before. The method is expected to be called within the "drawRect:"
 *  method of a UIView subclass. */
- (void)runJavaScriptDrawingFunction;
- (void)runJavaScriptTapFunctionWithLocation:(CGPoint)inLocation;
- (void)runJavaScriptSwipeFunctionWithDirection:(UISwipeGestureRecognizerDirection)inDirection;

@end

