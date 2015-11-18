/*============================================================================
 PROJECT: InstagramFeeds
 FILE:    Macro.h
 AUTHOR:  Tai Huu Ho
 DATE:    11/18/15
 =============================================================================*/

/*============================================================================
 IMPORT
 =============================================================================*/
#import <Foundation/Foundation.h>

#ifndef Macros_h
#define Macros_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]


#endif /* Macros_h */