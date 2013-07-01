/*!
 A document object which represents a JavaScript file.
 */
@interface ZBJavaScriptDocument : UIDocument

+ (NSString *)scriptDocumentFolderPath;
+ (NSArray *)allExistingFiles;
+ (ZBJavaScriptDocument *)createNewDocumentWithFileName:(NSString *)inFileName;
+ (NSURL *)fileURLWithFileName:(NSString *)inFileName;

@property (readonly, nonatomic) NSMutableString *text;
@end
