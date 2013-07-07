#import "ZBCanvasManager.h"
#import <AVFoundation/AVSpeechSynthesis.h>

@interface ZBJavaScriptValueAlertView : UIAlertView
@property (retain, nonatomic) JSValue *callback;
@end

@implementation ZBJavaScriptValueAlertView
@end

@interface ZBAlertConfirmHandler : NSObject <UIAlertViewDelegate>
@end

@implementation ZBAlertConfirmHandler
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	ZBJavaScriptValueAlertView *a = (ZBJavaScriptValueAlertView *)alertView;
	[a.callback callWithArguments:@[@(buttonIndex==1)]];
}
@end

@interface ZBAlertPromptHandler : NSObject
@end

@implementation ZBAlertPromptHandler
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	ZBJavaScriptValueAlertView *a = (ZBJavaScriptValueAlertView *)alertView;
	if (buttonIndex == 1) {
		NSString *text = [a textFieldAtIndex:0].text;
		[a.callback callWithArguments:@[text]];
	}
}
@end

@interface ZBCanvasManager()
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) NSString *fontName;
@property (assign, nonatomic) CGFloat fontSize;
@property (readonly, nonatomic) BOOL drawing;
@property (readonly, nonatomic) AVSpeechSynthesizer *speechSynthesizer;
@property (strong, nonatomic) ZBAlertConfirmHandler *alertConfirmHandler;
@property (strong, nonatomic) ZBAlertPromptHandler *alertPromptHandler;
@end

@implementation ZBCanvasManager
{
	BOOL drawing;
	JSContext *javaScriptContext;
	AVSpeechSynthesizer *speechSynthesizer;
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
	self.alertConfirmHandler = [[ZBAlertConfirmHandler alloc] init];
	self.alertPromptHandler = [[ZBAlertPromptHandler alloc] init];
	__block ZBCanvasManager *this = self;

	// Debug
	javaScriptContext[@"Log"] = ^(NSString *text) {
		NSLog(@"%@", text);
	};

	// Drawing
	javaScriptContext[@"Rect"] = ^(NSNumber *x, NSNumber *y, NSNumber *w, NSNumber *h) {
		CGRect rect = CGRectMake([x doubleValue], [y doubleValue], [w doubleValue], [h doubleValue]);
		JSValue *value = [JSValue valueWithRect:rect inContext:[JSContext currentContext]];
		__block JSValue *theValue = value;
		value[@"Fill"] = ^() {
			CGRect theRect = CGRectMake([theValue[@"x"] toDouble], [theValue[@"y"] toDouble], [theValue[@"width"] toDouble], [theValue[@"height"] toDouble]);
			UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:theRect];
			[bezierPath setLineWidth:this.lineWidth];
			[bezierPath fill];
		};
		value[@"Stroke"] = ^() {
			CGRect theRect = CGRectMake([theValue[@"x"] toDouble], [theValue[@"y"] toDouble], [theValue[@"width"] toDouble], [theValue[@"height"] toDouble]);
			UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:theRect];
			[bezierPath setLineWidth:this.lineWidth];
			[bezierPath stroke];
		};
		return value;
	};
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
	javaScriptContext[@"TextBox"] = ^(NSString *text, NSNumber *x, NSNumber *y, NSNumber *w, NSNumber *h) {
		UIFont *font = [UIFont fontWithName:this.fontName size:this.fontSize];
		NSDictionary *attr = @{NSFontAttributeName: font, NSForegroundColorAttributeName: this.color};
		[text drawInRect:CGRectMake([x doubleValue], [y doubleValue], [w doubleValue], [h doubleValue]) withAttributes:attr];
	};

	// Alerts
	javaScriptContext[@"Alert"] = ^(NSString *title) {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title ? title: @"" message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alert show];
	};
	javaScriptContext[@"Confirm"] = ^(NSString *title, JSValue *callback) {
		ZBJavaScriptValueAlertView *alert = [[ZBJavaScriptValueAlertView alloc]initWithTitle:title ? title: @"" message:@"" delegate:this.alertConfirmHandler cancelButtonTitle:NSLocalizedString(@"No", @"") otherButtonTitles:NSLocalizedString(@"Yes", @""), nil];
		alert.callback = callback;
		[alert show];
	};
	javaScriptContext[@"Prompt"] = ^(NSString *title, JSValue *callback) {
		ZBJavaScriptValueAlertView *alert = [[ZBJavaScriptValueAlertView alloc]initWithTitle:title ? title: @"" message:@"" delegate:this.alertPromptHandler cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
		alert.alertViewStyle = UIAlertViewStylePlainTextInput;
		alert.callback = callback;
		[alert show];
	};


	// Sound
	javaScriptContext[@"Say"] = ^(NSString *text) {
		if (this.drawing) {
			return;
		}
		AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:[AVSpeechSynthesisVoice currentLanguageCode]];
		AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
		utterance.voice = voice;
		[this.speechSynthesizer speakUtterance:utterance];
	};
	javaScriptContext[@"Ajax"] = ^(NSString *URLString, JSValue *callback) {
		if (this.drawing) {
			return ;
		}
		NSURL *URL = [NSURL URLWithString:URLString];
		if (!URL) {
			return;
		}
		[[NSURLSession sharedSession] dataTaskWithHTTPGetRequest:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
			NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			if (callback) {
				[callback callWithArguments:@[responseString]];
			}
		}];
	};
}

- (id)init
{
	self = [super init];
	if (self) {
		javaScriptContext = [[JSContext alloc] init];
		speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
		[self _initJavaScriptObjects];
	}
	return self;
}

- (void)loadJavaScript:(NSString *)script
{
	[javaScriptContext evaluateScript:script];
	if (javaScriptContext[@"setup"]) {
		[javaScriptContext[@"setup"] callWithArguments:nil];
	}
}

- (void)runJavaScriptDrawingFunction
{
	if (javaScriptContext[@"onDraw"]) {
		drawing = YES;
		[javaScriptContext[@"onDraw"] callWithArguments:nil];
		drawing = NO;
	}
}

- (void)runJavaScriptTapFunctionWithLocation:(CGPoint)inLocation
{
	if (javaScriptContext[@"onTap"]) {
		[javaScriptContext[@"onTap"] callWithArguments:@[[JSValue valueWithPoint:inLocation inContext:javaScriptContext]]];
	}
}

@synthesize drawing;
@synthesize speechSynthesizer;

@end
