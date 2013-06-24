@class ZBPreviewView;
@protocol ZBPreviewViewDelegate <NSObject>
- (void)previewViewDidRequestDrawingFunction:(ZBPreviewView *)inView;
@end

@interface ZBPreviewView : UIView
@property (weak, nonatomic) IBOutlet id <ZBPreviewViewDelegate> delegate;
@end
