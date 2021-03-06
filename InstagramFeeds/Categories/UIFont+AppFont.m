/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    UIFont+AppFont.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIFont+AppFont.h"

/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation UIFont (AppFont)
+(instancetype)appFontWithFontSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Billabong" size:fontSize];
}
@end
