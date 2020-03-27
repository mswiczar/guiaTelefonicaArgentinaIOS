//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface StorePick : NSObject<MKAnnotation> {
	NSMutableDictionary *thestore;
	CLLocationCoordinate2D coordinate;
	NSInteger thepos;
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSMutableDictionary *thestore;
@property (nonatomic) NSInteger thepos;


-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle;
- (NSString *)title;

@end

