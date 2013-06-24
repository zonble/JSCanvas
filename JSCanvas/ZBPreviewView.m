#import "ZBPreviewView.h"

@implementation ZBPreviewView

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];

	if (self.delegate) {
		[self.delegate previewViewDidRequestDrawingFunction:self];
	}
}

@synthesize delegate;

@end
