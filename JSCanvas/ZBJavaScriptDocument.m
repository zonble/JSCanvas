#import "ZBJavaScriptDocument.h"

static NSString *const kTemplate = @"onDraw = function() {\n};";

@interface ZBJavaScriptDocument()
{
	NSMutableString *text;
}
@end

@implementation ZBJavaScriptDocument

+ (NSString *)scriptDocumentFolderPath
{
	NSString *documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
	return [documentFolder stringByAppendingPathComponent:@"scripts"];
}

+ (void)checkIfScriptDocumentFolderExiists
{
	NSString *folderPath = [self scriptDocumentFolderPath];
	NSFileManager *manager = [NSFileManager defaultManager];
	BOOL isDir = NO;
	if (![manager fileExistsAtPath:folderPath isDirectory:&isDir]) {
		NSError *error;
		[manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
	}
	else if (!isDir) {
		NSError *error;
		[manager removeItemAtPath:folderPath error:&error];
		[manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
	}
}

+ (NSArray *)existingFiles
{
	[self checkIfScriptDocumentFolderExiists];
	NSMutableArray *files = [NSMutableArray array];
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *folderPath = [self scriptDocumentFolderPath];
	NSDirectoryEnumerator *e = [manager enumeratorAtPath:folderPath];
	NSString *filename = nil;
	while (filename = [e nextObject]) {
		if ([filename rangeOfString:@"/"].location != NSNotFound) {
			continue;
		}
		NSString *fullpath = [folderPath stringByAppendingPathComponent:filename];
		BOOL isDir = NO;
		[manager fileExistsAtPath:fullpath isDirectory:&isDir];
		if (isDir) {
			continue;
		}
		if ([[filename pathExtension] isEqualToString:@"js"]) {
			[files addObject:filename];
		}
	}
	return files;
}

+ (ZBJavaScriptDocument *)createNewDocument
{
	NSArray *existingFiles = [self existingFiles];
	NSString *filename = @"newscript.js";
	NSInteger index = 0;
	while ([existingFiles containsObject:filename]) {
		filename = [NSString stringWithFormat:@"newscript_%d.js", ++index];
	}
	NSURL *fileURL = [self fileURLWithFileName:filename];
	ZBJavaScriptDocument *document = [[ZBJavaScriptDocument alloc] initWithFileURL:fileURL];
	[document.text setString:kTemplate];
	[document saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
	}];
	return document;
}

+ (NSURL *)fileURLWithFileName:(NSString *)inFileName
{
	NSString *folderPath = [self scriptDocumentFolderPath];
	NSString *fullPath = [folderPath stringByAppendingPathComponent:inFileName];
	return [NSURL fileURLWithPath:fullPath];
}

- (id)initWithFileURL:(NSURL *)url
{
    self = [super initWithFileURL:url];
    if (self) {
        text = [[NSMutableString alloc] init];
    }
    return self;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
	return [NSData dataWithBytes:[text UTF8String] length:[text length]];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	NSString *existingText = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
	[text setString:existingText ? existingText : @""];
 	return YES;
}

@synthesize text;

@end
