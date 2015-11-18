/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    Runtime.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/17/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "Runtime.h"
#import <InstagramKit/InstagramEngine.h>

/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/
static NSString *kInstagramAccessTokenKey = @"kInstagramAccessTokenKey";

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/


@implementation Runtime
@synthesize instagramToken = _instagramToken;

+ (instancetype)sharedRuntime {
	static dispatch_once_t predicate;
	static Runtime *instance = nil;
	dispatch_once(&predicate, ^{instance = [[self alloc] init];});
	return instance;
}

- (void)setInstagramToken:(NSString *)instagramToken{
    _instagramToken = instagramToken;
    [InstagramEngine sharedEngine].accessToken = _instagramToken;
    [[NSUserDefaults standardUserDefaults] setObject:instagramToken forKey:kInstagramAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)instagramToken{
    if (!_instagramToken) {
        _instagramToken = [[NSUserDefaults standardUserDefaults] objectForKey:kInstagramAccessTokenKey];
        
        // restore access token for Instagram Engine
        [InstagramEngine sharedEngine].accessToken = _instagramToken;
    }
    return _instagramToken;
}
@end
