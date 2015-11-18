/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    StickyCollectionViewFlowLayout.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "StickyCollectionViewFlowLayout.h"

/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface StickyCollectionViewFlowLayout ()

@end

@implementation StickyCollectionViewFlowLayout
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.sectionHeadersPinToVisibleBounds = YES;
}
@end
