/*!
 A document object which represents a JavaScript file.
 */
@interface ZBJavaScriptDocument : UIDocument

+ (NSArray *)AllExistingFiles;
+ (ZBJavaScriptDocument *)createNewDocumentWithFileName:(NSString *)inFileName;
+ (NSURL *)fileURLWithFileName:(NSString *)inFileName;

@property (readonly, nonatomic) NSMutableString *text;
@end
