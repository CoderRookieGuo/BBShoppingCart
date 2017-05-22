//
//  BBGoodCell.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/18.
//
//

#import "BBTableViewCell.h"
@class BBGoodCell,BBCartGood;

@protocol BBGoodCellDelegate <NSObject>

- (void)cellDidClickSelectWithCell:(BBGoodCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)cellChangeGoodNumWithCell:(BBGoodCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath goodNumber:(NSString *)goodNum;

@end

@interface BBGoodCell : BBTableViewCell


@property (nonatomic,strong) BBCartGood *good;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,weak) id<BBGoodCellDelegate> delegate;
@end
