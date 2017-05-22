//
//  BBBottomBlockView.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 2017/2/4.
//
//

#import <UIKit/UIKit.h>

@interface BBBottomBlockView : UIView

@property (nonatomic,assign) BOOL isAllSelect;

@property (nonatomic,assign) double allPrice;

@property (nonatomic,copy) void(^bottomSelectClickBlock)();
@end
