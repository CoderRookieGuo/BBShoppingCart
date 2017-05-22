//
//  BBHeaderView.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/19.
//
//

#import "BBHeaderView.h"
#import "BBShoppingCart.h"

@interface BBHeaderView ()

///  选中店铺所有商品
@property (nonatomic,strong) UIButton *selectStoreButton;
///  店铺名称
@property (nonatomic,strong) UILabel *storeTitleLabel;

@end

static NSString *ID = @"groud_header_view";
@implementation BBHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

#pragma mark - 点击方法
//选中店铺所有商品
- (void)selectStoreButtonClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(headerDidClickSelectWithHeaderView:viewForHeaderInSection:)]) {
        [self.delegate headerDidClickSelectWithHeaderView:self viewForHeaderInSection:self.section];
    }
    
}
- (void)setStore:(BBCartStore *)store {
    _store = store;
    self.storeTitleLabel.text = store.store_name;
    self.selectStoreButton.selected = !store.isSelectedStore;
//    if (store.isEnabled == 0) {
//        self.selectStoreButton.enabled = NO;
//        [self.selectStoreButton setImage:[UIImage imageNamed:@"shixiao"] forState:UIControlStateNormal];
//    } else{
//        self.selectStoreButton.enabled = YES;
//        [self.selectStoreButton setImage:[UIImage imageNamed:@"cart_check_m"] forState:UIControlStateNormal];
//    }
}
- (void)initSubviews {
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    topView.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    [self.contentView addSubview:topView];
    // 选中店铺所有商品
    _selectStoreButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, 20, 44)];
    [_selectStoreButton setImage:[UIImage imageNamed:@"cart_check_m"] forState:UIControlStateNormal];
    [_selectStoreButton setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateSelected];
    
    
    [_selectStoreButton addTarget:self action:@selector(selectStoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectStoreButton];

    // 店铺名称
    _storeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, [UIScreen mainScreen].bounds.size.width, 44)];
    _storeTitleLabel.text = @"店铺";
    _storeTitleLabel.textColor = [UIColor blackColor];
    _storeTitleLabel.font = [UIFont systemFontOfSize:14];


    [self.contentView addSubview:_storeTitleLabel];

    //分割线
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 53, [UIScreen mainScreen].bounds.size.width, 1)];
    sepView.backgroundColor = [UIColor colorWithRed:251/255.f green:251/255.f blue:251/255.f alpha:1];
;
    [self addSubview:sepView];

}


@end
