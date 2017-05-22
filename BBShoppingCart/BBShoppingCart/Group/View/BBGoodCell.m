
//
//  BBGoodCell.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/18.
//
//

#import "BBGoodCell.h"
#import "BBShoppingCart.h"

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width


@interface BBGoodCell ()

/// 选中按钮
@property (nonatomic,strong) UIButton *selectButton;
/// 商品图片
@property (nonatomic,strong) UIImageView *goodsImageView;
///  失效蒙版
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIButton *coverButton;
/// 商品名称
@property (nonatomic,strong) UILabel *goodsTitle;
/// 商品重量
@property (nonatomic,strong) UILabel *goodsWeight;
/// 商品价格
@property (nonatomic,strong) UILabel *goodsPrice;
/// 增加商品数量按钮
@property (nonatomic,strong) UIButton *plusCountButton;
/// 减少商品数量按钮
@property (nonatomic,strong) UIButton *reduceCountButton;
/// 更改商品数量文本框
@property (nonatomic,strong) UITextField *changeCountTxt;

@end

@implementation BBGoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    return self;
}
#pragma mark - action
#pragma mark 选择商品
- (void)selectButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidClickSelectWithCell:cellForRowAtIndexPath:)]) {
        [self.delegate cellDidClickSelectWithCell:self cellForRowAtIndexPath:self.indexPath];
    }
}
#pragma mark 改变商品数量
// plus
- (void)plusCountButtonClick:(UIButton *)sender {
    self.changeCountTxt.text = [NSString stringWithFormat:@"%d",[self.changeCountTxt.text intValue] + 1];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeGoodsCount:) object:sender];
    [self performSelector:@selector(changeGoodsCount:) withObject:sender afterDelay:0.f];
}

// reduce
- (void)reduceCountButtonClick:(UIButton *)sender {
    self.changeCountTxt.text = [NSString stringWithFormat:@"%d",[self.changeCountTxt.text intValue] - 1];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeGoodsCount:) object:sender];
    [self performSelector:@selector(changeGoodsCount:) withObject:sender afterDelay:0.f];
}


- (void)changeGoodsCount:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cellChangeGoodNumWithCell:cellForRowAtIndexPath:goodNumber:)]) {
        [self.delegate cellChangeGoodNumWithCell:self cellForRowAtIndexPath:self.indexPath goodNumber:self.changeCountTxt.text];
    }
}
#pragma mark - setter
- (void)setGood:(BBCartGood *)good {
    _good = good;
    self.selectButton.selected = !good.isSelectedGood;
    self.goodsImageView.image = [UIImage imageNamed:@"1234567.jpg"];
    self.goodsTitle.text = good.goods_name;
    self.goodsWeight.text = [NSString stringWithFormat:@"净重: %@斤",good.goods_netweight];
    self.goodsPrice.text =[NSString stringWithFormat:@"￥%@/件",good.goods_price];
    
    self.changeCountTxt.text = good.goods_num;
}
- (void)initSubviews {
    //选中按钮
    _selectButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 100)];
    
    [_selectButton setImage:[UIImage imageNamed:@"cart_check_m"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"cart_check"] forState:UIControlStateSelected];
    
    [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectButton];
    //商品图片
    _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 80, 80)];
    _goodsImageView.image = [UIImage imageNamed:@"p_photo"];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImageView.backgroundColor = [UIColor whiteColor];
    _goodsImageView.layer.masksToBounds = YES;
    _goodsImageView.layer.cornerRadius = 5;
    _goodsImageView.layer.borderWidth = 0.5;
    _goodsImageView.layer.borderColor = [[UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1] CGColor];
    [self.contentView addSubview:_goodsImageView];

//    /// 失效蒙版
//    UIView *coverView = [[UIView alloc]init];
//    coverView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
//    [goodsImageView addSubview:coverView];
//    self.coverView = coverView;
//    
//    UIButton *coverButton = [UIButton buttonWithTitle:@"已失效" titleColor:@"#ffffff" selectColor:@"#ffffff" titleSize:12 radius:5];
//    coverButton.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
//    coverButton.layer.borderWidth = 1;
//    [coverView addSubview:coverButton];
//    self.coverButton = coverButton;
    //商品名称
    _goodsTitle = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 130, 15)];
    _goodsTitle.text = @"新西兰红玫瑰";
    _goodsTitle.textColor = [UIColor blackColor];
    _goodsTitle.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_goodsTitle];


    //商品重量
    _goodsWeight = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 130, 13)];
    _goodsWeight.text = @"9.00 斤";
    _goodsWeight.textColor = [UIColor blackColor];
    _goodsWeight.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_goodsWeight];

    
    //商品价格
    _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(150, 77, 130, 13)];
    _goodsPrice.text = @"¥ 168";
    _goodsPrice.textColor = [UIColor colorWithRed:235/255.f green:122/255.f blue:9/255.f alpha:1];
    _goodsPrice.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_goodsPrice];

    //增加商品数量按钮
    _plusCountButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-40, 66, 30, 24)];
    
    [_plusCountButton setBackgroundImage:[UIImage imageNamed:@"cart_pur_plus"] forState:UIControlStateNormal];
    [_plusCountButton setBackgroundImage:[UIImage imageNamed:@"cart_pur_plus"] forState:UIControlStateHighlighted];
    _plusCountButton.hidden = NO;
    
    [_plusCountButton addTarget:self action:@selector(plusCountButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_plusCountButton];

    //更改商品数量按钮
    _changeCountTxt = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth-67, 66, 28, 24)];
    _changeCountTxt.keyboardType = UIKeyboardTypeDefault;
    _changeCountTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    _changeCountTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    [self addInputAccessoryViewWithTextFiled:changeCountTxt];
    
    
    [_changeCountTxt setBackground:[UIImage imageNamed:@"cart_pur"]];
    _changeCountTxt.text = @"1";
    _changeCountTxt.textAlignment = NSTextAlignmentCenter;
    _changeCountTxt.font = [UIFont systemFontOfSize:13];
    _changeCountTxt.textColor = [UIColor colorWithRed:235/255.f green:122/255.f blue:9/255.f alpha:1];
    _changeCountTxt.hidden = NO;
    _changeCountTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    
    [self addSubview:_changeCountTxt];

    //减少商品数量按钮
    UIButton *reduceCountButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-96, 66, 30, 24)];
    [reduceCountButton setBackgroundImage:[UIImage imageNamed:@"cart_pur_reduce"] forState:UIControlStateNormal];
    [reduceCountButton setBackgroundImage:[UIImage imageNamed:@"cart_pur_reduce"] forState:UIControlStateHighlighted];
    reduceCountButton.hidden = NO;
    
    [reduceCountButton addTarget:self action:@selector(reduceCountButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reduceCountButton];
    self.reduceCountButton = reduceCountButton;

}
@end
