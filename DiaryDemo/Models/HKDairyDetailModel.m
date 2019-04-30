//
//  HKDairyDetailModel.m
//  MyBeautifulLife
//
//  Created by sherlock on 2019/4/30.
//  Copyright © 2019年 HeiKki. All rights reserved.
//

#import "HKDiaryDetailModel.h"

@implementation HKDiaryDetailModel

+ (instancetype)modelWithContent:(NSString *)content type:(NSString *)type heightScale:(CGFloat )heightScale{
    HKDiaryDetailModel *model = [[HKDiaryDetailModel alloc]init];
    model.content = content;
    model.type = type;
    model.heightScale = heightScale;
    return model;
}

@end
