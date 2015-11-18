/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    UIColor+AppColor.m
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import "UIColor+AppColor.h"

/*============================================================================
 PRIVATE CONSTANTS
 =============================================================================*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/*============================================================================
 PRIVATE INTERFACE
 =============================================================================*/

@implementation UIColor (AppColor)
+(UIColor *)lightGreenColor{
    static UIColor *lightGreenColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightGreenColor =  UIColorFromRGB(0x0DD0BB);
    });
    return lightGreenColor;
}

+(UIColor *)lightRedColor{
    static UIColor *lightGreenColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lightGreenColor =  UIColorFromRGB(0xFF6C77);
    });
    return lightGreenColor;
}

@end
