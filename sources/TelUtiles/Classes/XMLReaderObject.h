#import <Foundation/Foundation.h>
@interface XMLReaderObject : NSObject
{
	NSError *error;
	NSMutableArray *products;
	NSMutableDictionary *currentProduct;
	NSMutableArray *currentKey;
	NSString *currenStr;
	NSString *ObjectName;
	NSString *lastvalue;
}

@property (nonatomic,retain) NSMutableArray *products;
@property (nonatomic,retain) NSMutableDictionary *currentProduct;
@property (nonatomic,retain) NSString *ObjectName;

@property (nonatomic,retain) NSMutableArray *currentKey;
@property (nonatomic,retain) NSString *currenStr;
@property (nonatomic,retain) NSError *error;

- (NSError*)parseXML: (NSString *)data;


@end

