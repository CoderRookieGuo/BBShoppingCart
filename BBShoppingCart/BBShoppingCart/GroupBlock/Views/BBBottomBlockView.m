//
//  BBBottomBlockView.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 2017/2/4.
//
//

#import "BBBottomBlockView.h"

@interface BBBottomBlockView ()

///  全选按钮
@property (nonatomic,strong)UIButton *allSelectButton;
///  全选label
@property (nonatomic,strong)UILabel *allSelectLabel;
///  合计
@property (nonatomic,strong)UILabel *allLabel;
///  总价
@property (nonatomic,strong)UILabel *allPriceLabel;

///  提交订单
@property (nonatomic,strong)UIButton *buyButton;

@end

@implementation BBBottomBlockView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}

- (void)allSelectButtonClick:(UIButton *)sender {
    if (self.bottomSelectClickBlock) {
        self.bottomSelectClickBlock();
    }
}
- (void)setIsAllSelect:(BOOL)isAllSelect {
    _isAllSelect = isAllSelect;
    self.allSelectButton.selected = !isAllSelect;
}
- (void)setAllPrice:(double)allPrice {
    _allPrice = allPrice;
    self.allPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",allPrice];
}
- (void)initSubviews {
    //分割线
    UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    sepView.backgroundColor = [UIColor colorWithRed:251/255.f green:251/255.f blue:251/255.f alpha:1];
    ;
    [self addSubview:sepView];
    //全选按钮
    _allSelectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
    [_allSelectButton setImage:[UIImage imageNamed:@"cart_check_m"] forState:UIControlStateNormal];
    [_allSelectButton setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateSelected];
    
    _allSelectButton.selected = YES;
    [_allSelectButton addTarget:self action:@selector(allSelectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_allSelectButton];
    //全选label
    _allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 25, 50)];
    _allSelectLabel.text = @"全选";
    _allSelectLabel.textColor = [UIColor colorWithRed:202/255.f green:202/255.f blue:202/255.f alpha:1];
    _allSelectLabel.font = [UIFont systemFontOfSize:11];
    
    [self addSubview:_allSelectLabel];
    
    //合计
    _allLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 30, 50)];
    _allLabel.text = @"合计: ";
    _allLabel.textColor = [UIColor colorWithRed:202/255.f green:202/255.f blue:202/255.f alpha:1];
    _allLabel.font = [UIFont systemFontOfSize:11];
    
    [self addSubview:_allLabel];
    //总价
    _allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, self.bounds.size.width-200, 50)];
    _allPriceLabel.text = @"¥ 0.00";
    _allPriceLabel.textColor = [UIColor colorWithRed:235/255.f green:122/255.f blue:9/255.f alpha:1];
    _allPriceLabel.font = [UIFont systemFontOfSize:17];
    
    [self addSubview:_allPriceLabel];
    
    //提交订单
    _buyButton = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width-100, 0, 100, self.bounds.size.height)];
    _buyButton.backgroundColor = [UIColor colorWithRed:235/255.f green:122/255.f blue:9/255.f alpha:1];
    [_buyButton setTitle:@"确认订单" forState:UIControlStateNormal];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self addSubview:_buyButton];
}

@end
