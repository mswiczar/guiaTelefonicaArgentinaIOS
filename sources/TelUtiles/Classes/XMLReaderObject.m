
#import "XMLReaderObject.h"


@implementation XMLReaderObject
@synthesize error;
@synthesize products;
@synthesize currentProduct;
@synthesize currentKey;
@synthesize currenStr;
@synthesize ObjectName;



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) {
        elementName = qName;
    }
	
		if ([elementName isEqualToString:self.ObjectName]) 
		{
			self.currentProduct = [[NSMutableDictionary alloc] initWithCapacity:1];
			self.currentKey = [[NSMutableArray alloc] init];

			if(attributeDict)
			{
				[currentProduct addEntriesFromDictionary:attributeDict];
			}
		} 
	[self.currentKey  addObject: elementName];
	
	self.currenStr = @"";
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) 
	{
        elementName = qName;
    }
	
	//NSLog(@"key= %@  value=%@ end; ",self.currentKey,self.currenStr);
	

	if ([elementName isEqualToString:self.ObjectName]) 
	{
				[products addObject:currentProduct];
	}
	else
	{

		NSString *key = [self.currentKey componentsJoinedByString:@"_"];
		[self.currentProduct setObject:self.currenStr forKey:key];

	}
	if([self.currentKey count]!=0)
	{
		[self.currentKey  removeLastObject];
	}

		

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	self.currenStr = [currenStr stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
// sent when the parser first sees a namespace attribute.
// In the case of the cvslog tag, before the didStartElement:, you'd get one of these with prefix == @"" and namespaceURI == @"http://d4meadmin.comxml.apple.com/cvslog" (i.e. the default namespace)
// In the case of the radar:radar tag, before the didStartElement: you'd get one of these with prefix == @"radar" and namespaceURI == @"http://d4meadmin.comxml.apple.com/radar"
{
//	NSLog(@"start prefix =%@,namespaceURI =%@ " , prefix,namespaceURI);
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
	//NSLog(@"end prefix =%@ " , prefix);

}



- (NSError*)parseXML: (NSString *)data;
{	
	if (error != nil) 
	{
		[error release];
	}
    error = [NSError alloc];
	
	if(self.products==nil)
	{
		self.products = [[NSMutableArray alloc] initWithCapacity:1];
	}
	//NSLog(data);
	
	BOOL salida = YES;

	NSData *d = [ data dataUsingEncoding:NSUTF8StringEncoding];
	//NSLog(data);
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:d];
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:YES];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    NSError *parseError = [parser parserError];
    if (parseError && error) {
        error = parseError;
		salida = -100;
    }
    [parser release];
	return error;
	
}



@end