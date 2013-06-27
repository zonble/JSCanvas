#import "ZBPreviewView.h"
#import "ZBCanvasManager.h"

@interface ZBPreviewViewController : UIViewController
	<ZBPreviewViewDelegate, ZBCanvasManagerDelegate>

- (instancetype)initWithJavaScript:(NSString *)inJavaScript;
- (IBAction)close:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet ZBPreviewView *previewView;
@end
