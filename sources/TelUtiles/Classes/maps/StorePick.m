
#import "StorePick.h"


@implementation StorePick


@synthesize coordinate;
@synthesize thestore;
@synthesize thepos;


- (NSString *)subtitle{
return [NSString stringWithFormat:@"%@", [thestore objectForKey:@"direccion"] ];

}
- (NSString *)title{

	return [NSString stringWithFormat:@"%@", [thestore objectForKey:@"nombre"] ];
	
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
//	NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}
@end

