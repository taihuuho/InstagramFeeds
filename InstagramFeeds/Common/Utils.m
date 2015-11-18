/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    Utils.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "Utils.h"

/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface Utils ()

@end

@implementation Utils
+ (NSString *)formatStringLikeCount:(NSInteger)likesCount{
    return [NSString stringWithFormat:(likesCount > 1? NSLocalizedString(@"%d likes",) : NSLocalizedString(@"%d like",)), likesCount];
}
@end