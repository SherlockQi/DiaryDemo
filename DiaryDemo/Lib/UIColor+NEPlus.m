//
//  UIColor+NEPlus.m
//
//  Created by sherlock on 2016/11/29.
//  Copyright © 2016年 xiaqi. All rights reserved.
//

#import "UIColor+NEPlus.h"

@implementation UIColor (NEPlus)
int convertToInt(char c)

{
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        return printf("字符非法！");
    }
}
+ (UIColor *)colorWithHexString:(NSString *)name
{
    
    if (![[name substringToIndex:0] isEqualToString:@"#"] && name.length < 7) {
        return nil;
    }
    const char *str = [[name substringWithRange:NSMakeRange(1, 6)] UTF8String];
    NSString *alphaString = [name substringFromIndex:7];
    CGFloat red = (convertToInt(str[0]) * 16 + convertToInt(str[1])) / 255.0f;
    CGFloat green = (convertToInt(str[2]) * 16 + convertToInt(str[3])) / 255.0f;
    CGFloat blue = (convertToInt(str[4]) * 16 + convertToInt(str[5])) / 255.0f;
    CGFloat alpha = ([alphaString isEqualToString:@""]) ? 1 : alphaString.floatValue / 255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
}

+ (UIColor *)randomColor
{
    CGFloat red = (arc4random()%256)/255.0;
    CGFloat green = (arc4random()%256)/255.0;
    CGFloat blue = (arc4random()%256)/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.3];
}


@end
