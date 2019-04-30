//
//  HKDiaryModel.h
//  DiaryDemo
//
//  Created by PDA-iOS on 2019/4/30.
//  Copyright © 2019 HeiKki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKDiaryModel : NSObject
@property (nonatomic, copy) NSString *title;
+ (instancetype)modelWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
