/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    MediaCollectionViewCell.h
 AUTHOR:  Tai Huu Ho
 DATE:    11/17/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 INTERFACE:   MediaCollectionViewCell
 =============================================================================*/
@class InstagramMedia;
@interface MediaCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
- (void)displayMedia:(InstagramMedia*)media;
@end
