/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    LoadingView.h
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
 INTERFACE:   LoadingView
 =============================================================================*/

@interface LoadingView : UIView
+ (instancetype)sharedInstance;
- (void)startLoading;
- (void)stopLoading;
@end
