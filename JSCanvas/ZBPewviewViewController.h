#import "ZBPreviewView.h"
#import "ZBCanvasManager.h"

@interface ZBPewviewViewController : UIViewController <ZBPreviewViewDelegate, ZBCanvasManagerDelegate>
@property (retain, nonatomic) IBOutlet ZBPreviewView *previewView;
@end
