//
//  BBHeaderView.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/19.
//
//

#import <UIKit/UIKit.h>
@class BBHeaderView,BBCartStore;

@protocol BBHeaderViewDelegate <NSObject>

- (void)headerDidClickSelectWithHeaderView:(BBHeaderView *)headerView viewForHeaderInSection:(NSInteger)section;

@end

@interface BBHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong) BBCartStore *store;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,weak) id<BBHeaderViewDelegate> delegate;
@end
