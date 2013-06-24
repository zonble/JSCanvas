@interface ZBSourceEditorViewController : UIViewController
- (IBAction)update:(id)sender;
- (IBAction)cancel:(id)sender;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) NSString *currentScript;
@end
