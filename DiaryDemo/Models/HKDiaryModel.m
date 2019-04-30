//
//  HKDiaryModel.m
//  DiaryDemo
//
//  Created by PDA-iOS on 2019/4/30.
//  Copyright © 2019 HeiKki. All rights reserved.
//

#import "HKDiaryModel.h"

@implementation HKDiaryModel

+ (instancetype)modelWithTitle:(NSString *)title{
    HKDiaryModel * model = [[HKDiaryModel alloc]init];
    model.title = title;
    return model;
}

@end
