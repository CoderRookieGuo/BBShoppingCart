//
//  BBHeaderBlockView.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 2017/2/4.
//
//

#import <UIKit/UIKit.h>
@class BBCartStore;

@interface BBHeaderBlockView : UITableViewHeaderFooterView

@property (nonatomic,strong) BBCartStore *store;

@property (nonatomic,copy) void(^headerDidClickSelectBlock)();
@end
