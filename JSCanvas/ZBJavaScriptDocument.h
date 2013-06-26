/*!
 A document object which represents a JavaScript file.
 */
@interface ZBJavaScriptDocument : UIDocument

+ (NSArray *)existingFiles;
+ (ZBJavaScriptDocument *)createNewDocument;
+ (NSURL *)fileURLWithFileName:(NSString *)inFileName;

@property (readonly, nonatomic) NSMutableString *text;
@end
