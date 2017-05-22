//
//  BBBottomView.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/22.
//
//

#import <UIKit/UIKit.h>
@class BBBottomView;

@protocol BBBottomViewDelegate <NSObject>

- (void)bottomSelectClickWithBottomView:(BBBottomView *)bottomView;

@end

@interface BBBottomView : UIView

@property (nonatomic,assign) BOOL isAllSelect;

@property (nonatomic,assign) double allPrice;

@property (nonatomic,weak) id<BBBottomViewDelegate> delegate;
@end
