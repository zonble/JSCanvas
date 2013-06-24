#import "ZBPreviewView.h"

@implementation ZBPreviewView

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
//	[[UIColor redColor] set];
//	[[UIBezierPath bezierPathWithRect:self.bounds] fill];

	if (self.delegate) {
		[self.delegate previewViewDidRequestDrawingFunction:self];
	}
}

@synthesize delegate;

@end
