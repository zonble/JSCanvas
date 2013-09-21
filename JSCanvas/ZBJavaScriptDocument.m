#import "ZBJavaScriptDocument.h"

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
	BOOL createNewDir = NO;
	if (![manager fileExistsAtPath:folderPath isDirectory:&isDir]) {
		NSError *error;
		[manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
		createNewDir = YES;
	}
	else if (!isDir) {
		NSError *error;
		[manager removeItemAtPath:folderPath error:&error];
		[manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
		createNewDir = YES;
	}

	if (createNewDir) {
		NSString *welcomePath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samples"] stringByAppendingPathComponent:@"welcome.js"];
		NSString *toPath = [folderPath stringByAppendingPathComponent:@"welcome.js"];
		[manager copyItemAtPath:welcomePath toPath:toPath error:nil];

		NSString *clockPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samples"] stringByAppendingPathComponent:@"clock.js"];
		toPath = [folderPath stringByAppendingPathComponent:@"sample.js"];
		[manager copyItemAtPath:clockPath toPath:toPath error:nil];

		NSString *scriptPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"samples"] stringByAppendingPathComponent:@"template.js"];
		toPath = [folderPath stringByAppendingPathComponent:@"newscript.js"];
		[manager copyItemAtPath:scriptPath toPath:toPath error:nil];
	}
}

+ (NSArray *)allExistingFiles
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

+ (ZBJavaScriptDocument *)newDocumentWithFileName:(NSString *)inFileName
{
	NSURL *templateFileURL = [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"js"];
	NSString *template = [NSString stringWithContentsOfURL:templateFileURL encoding:NSUTF8StringEncoding error:nil];
	NSArray *existingFiles = [self allExistingFiles];
	NSString *filename = [NSString stringWithFormat:@"%@.js", inFileName];
	NSInteger index = 0;
	while ([existingFiles containsObject:filename]) {
		filename = [NSString stringWithFormat:@"%@_%d.js", inFileName, ++index];
	}
	NSURL *fileURL = [self fileURLWithFileName:filename];
	ZBJavaScriptDocument *document = [[ZBJavaScriptDocument alloc] initWithFileURL:fileURL];
	[document.text setString:template];
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
	return [NSData dataWithBytes:[text UTF8String] length:strlen([text UTF8String])];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
	NSString *existingText = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
	[text setString:existingText ? existingText : @""];
	return YES;
}

@synthesize text;

@end
