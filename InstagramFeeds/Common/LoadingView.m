/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    LoadingView.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "LoadingView.h"
#import "AppDelegate.h"
#import "UIColor+AppColor.h"

/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/

/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@interface LoadingView ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation LoadingView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+ (instancetype)sharedInstance {
    static dispatch_once_t predicate;
    static LoadingView *instance = nil;
    dispatch_once(&predicate, ^{
        NSArray *nibs = [[UINib nibWithNibName:@"LoadingView" bundle:nil] instantiateWithOwner:self options:nil];
        instance = nibs.firstObject;
        instance.indicatorView.color = [UIColor lightRedColor];
        
    });
    return instance;
}

- (void)addToWindow{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        self.center = appDelegate.window.center;
        self.bounds = appDelegate.window.bounds;
        [appDelegate.window addSubview:self];
    });
}

- (void)startLoading{
    [self addToWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView startAnimating];
    });
    
}

- (void)stopLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.indicatorView stopAnimating];
        if (self.superview) {
            [self removeFromSuperview];
            
        }
    });
}

@end
