//
//  UIColor+NEPlus.h
//
//  Created by sherlock on 2016/11/29.
//  Copyright © 2016年 xiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIColor (NEPlus)
//以#开头的字符串（不区分大小写）,如：#ffFFff, 若需要alpha，则传#abcdef255, 不传默认为1
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

//随机色
+ (UIColor *)randomColor;

@end
NS_ASSUME_NONNULL_END
