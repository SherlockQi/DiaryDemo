//
//  HKDairyDetailModel.h
//  MyBeautifulLife
//
//  Created by sherlock on 2019/4/30.
//  Copyright © 2019年 HeiKki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HKDiaryDetailModel : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) CGFloat heightScale;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)modelWithContent: (NSString *)content type: (NSString *)type heightScale:(CGFloat) heightScale;

@end

