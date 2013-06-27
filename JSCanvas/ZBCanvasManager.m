#import "ZBCanvasManager.h"

@interface ZBCanvasManager()
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NSString *fontName;
@property (assign, nonatomic) CGFloat fontSize;
@end

@implementation ZBCanvasManager
{
	JSContext *javaScriptContext;
}

- (UIColor *)_colorWithR:(NSNumber *)r G:(NSNumber *)g B:(NSNumber *)b A:(NSNumber *)a
{
	CGFloat red = [r integerValue] / 255.0;
	CGFloat green = [g integerValue] / 255.0;
	CGFloat blue = [b integerValue] / 255.0;
	CGFloat alpha = [a integerValue] / 255.0;
	red = red <= 1.0 ? red : 1.0;
	green = green <= 1.0 ? green : 1.0;
	blue = blue <= 1.0 ? blue : 1.0;
	alpha = alpha <= 1.0 ? alpha : 1.0;
	red = red >= 0.0 ? red : 0.0;
	green = green >= 0.0 ? green : 0.0;
	blue = blue >= 0.0 ? blue : 0.0;
	alpha = alpha >= 0.0 ? alpha : 0.0;
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)_initJavaScriptObjects
{
	self.color = [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.0 alpha:1.0];
	self.lineWidth = 1.0;
	self.fontName = @"Helvetica";
	self.fontSize = 13.0;
	__block ZBCanvasManager *this = self;

	javaScriptContext[@"SetColor"] = ^(NSNumber *r, NSNumber *g, NSNumber *b, NSNumber *a) {
		UIColor *color = [this _colorWithR:r G:g B:b A:a];
		this.color = color;
		[color set];
	};
	javaScriptContext[@"SetFillColor"] = ^(NSNumber *r, NSNumber *g, NSNumber *b, NSNumber *a) {
		UIColor *color = [this _colorWithR:r G:g B:b A:a];
		[color setFill];
	};
	javaScriptContext[@"SetStrokeColor"] = ^(NSNumber *r, NSNumber *g, NSNumber *b, NSNumber *a) {
		UIColor *color = [this _colorWithR:r G:g B:b A:a];
		[color setStroke];
	};
	javaScriptContext[@"FillRect"] = ^(NSNumber *x, NSNumber *y, NSNumber *w, NSNumber *h) {
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake([x doubleValue], [y doubleValue], [w doubleValue], [h doubleValue])];
		[bezierPath setLineWidth:this.lineWidth];
		[bezierPath fill];
	};
	javaScriptContext[@"StrokeRect"] = ^(NSNumber *x, NSNumber *y, NSNumber *w, NSNumber *h) {
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake([x doubleValue], [y doubleValue], [w doubleValue], [h doubleValue])];
		[bezierPath setLineWidth:this.lineWidth];
		[bezierPath stroke];
	};
	javaScriptContext[@"FillOval"] = ^(NSNumber *x, NSNumber *y, NSNumber *w, NSNumber *h) {
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake([x doubleValue], [y doubleValue], [w doubleValue], [h doubleValue])];
		[bezierPath setLineWidth:this.lineWidth];
		[bezierPath fill];
	};
	javaScriptContext[@"StrokeOval"] = ^(NSNumber *x, NSNumber *y, NSNumber *w, NSNumber *h) {
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake([x doubleValue], [y doubleValue], [w doubleValue], [h doubleValue])];
		[bezierPath setLineWidth:this.lineWidth];
		[bezierPath stroke];
	};
	javaScriptContext[@"Line"] = ^(NSNumber *fromX, NSNumber *fromY, NSNumber *toX, NSNumber *toY) {
		UIBezierPath *bezierPath = [UIBezierPath bezierPath];
		[bezierPath setLineWidth:this.lineWidth];
		[bezierPath moveToPoint:CGPointMake([fromX doubleValue], [fromY doubleValue])];
		[bezierPath addLineToPoint:CGPointMake([toX doubleValue], [toY doubleValue])];
		[bezierPath stroke];
	};
	javaScriptContext[@"SetLineWidth"] = ^(NSNumber *w) {
		this.lineWidth = [w doubleValue];
	};
	javaScriptContext[@"SetFontName"] = ^(NSString *fontName) {
		this.fontName = fontName;
	};
	javaScriptContext[@"SetFontSize"] = ^(NSNumber *size) {
		this.fontSize = [size doubleValue];
	};
	javaScriptContext[@"Text"] = ^(NSString *text, NSNumber *x, NSNumber *y) {
		UIFont *font = [UIFont fontWithName:this.fontName size:this.fontSize];
		NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: this.color};
		[text drawAtPoint:CGPointMake([x doubleValue], [y doubleValue]) withAttributes:attr];
	};
}

- (id)init
{
	self = [super init];
	if (self) {
		javaScriptContext = [[JSContext alloc] init];
		[self _initJavaScriptObjects];
	}
	return self;
}

- (void)loadJavaScript:(NSString *)script
{
	[javaScriptContext evaluateScript:script];
}

- (void)runJavaScriptDrawingFunction
{
	if (javaScriptContext[@"onDraw"]) {
		[javaScriptContext[@"onDraw"] callWithArguments:nil];
	}
}

- (void)runJavaScriptTapFunctionWithLocation:(CGPoint)inLocation
{
	if (javaScriptContext[@"onTap"]) {
		[javaScriptContext[@"onTap"] callWithArguments:@[[JSValue valueWithPoint:inLocation inContext:javaScriptContext]]];
	}
}

@end
