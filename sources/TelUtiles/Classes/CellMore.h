//  UICellConfig.h

#import <UIKit/UIKit.h>
@interface CellMore: UITableViewCell
{
	UILabel * thelabel;
	UIActivityIndicatorView * thesleep;
}

-(void) start;
-(void) stop;
 
@end





