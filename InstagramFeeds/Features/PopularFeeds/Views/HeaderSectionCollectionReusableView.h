/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    HeaderSectionCollectionReusableView.h
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <UIKit/UIKit.h>

/*============================================================================
 PROTOCOL
 =============================================================================*/

/*============================================================================
 INTERFACE:   HeaderSectionCollectionReusableView
 =============================================================================*/
@class InstagramMedia;
@interface HeaderSectionCollectionReusableView : UICollectionReusableView
- (void)displayAuthorOfItem:(InstagramMedia*)item;
@end
