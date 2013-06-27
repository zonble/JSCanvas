/*!
 * The controller to help editing JavaScript source code.
 */
#import "ZBJavaScriptDocument.h"

@interface ZBSourceEditorViewController : UIViewController
	<UIActionSheetDelegate>

- (instancetype)initWithDocoment:(ZBJavaScriptDocument *)document;
- (IBAction)run:(id)sender;
- (IBAction)showMoreOptions:(id)sender;
- (IBAction)showAPIReference:(id)sender;

@property (readonly, nonatomic) ZBJavaScriptDocument *document;
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) NSString *currentScript;
@end
