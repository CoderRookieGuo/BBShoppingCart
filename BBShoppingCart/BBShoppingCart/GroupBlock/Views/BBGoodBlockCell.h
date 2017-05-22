//
//  BBGoodBlockCell.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 2017/2/4.
//
//

#import "BBTableViewCell.h"
@class BBCartGood;

@interface BBGoodBlockCell : BBTableViewCell

@property (nonatomic,strong) BBCartGood *good;

@property (nonatomic,copy) void(^cellDidClickSelectBlock)();
@property (nonatomic,copy) void(^cellChangeGoodNumBlock)(NSString *goodNum);
@end
