//
//  BBShoppingCart.h
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/18.
//
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface BBCartGood : NSObject

///  购物车ID
@property (nonatomic,assign) NSInteger cart_id;
///  用户ID
@property (nonatomic,assign) NSInteger buyer_id;
///  店铺id
@property (nonatomic,assign) NSInteger store_id;
///  商品ID
@property (nonatomic,assign) NSInteger goods_id;
///  0非预售 1 预售
@property (nonatomic,copy) NSString *is_presell;
///  是否选中
@property (nonatomic,assign) BOOL select;
///  是否失效
@property (nonatomic,assign) BOOL state;
///  库存不足失效
@property (nonatomic,assign) BOOL storage_state;
///  商品名称
@property (nonatomic,copy) NSString *goods_name;
///  商品数量
@property (nonatomic,copy) NSString *goods_num;
///  商品图片
@property (nonatomic,copy) NSString *goods_image_url;
@property (nonatomic,copy) NSString *goods_image;
///  商品重量
@property (nonatomic,copy) NSString *goods_netweight;
///  最小起订量
@property (nonatomic,copy) NSString *minnum;
///  价格
@property (nonatomic,copy) NSString *goods_price;
///  体积
@property (nonatomic,copy) NSString *goods_volume;
///  运费
@property (nonatomic,copy) NSString *goods_freight;
///  库存
@property (nonatomic,copy) NSString *goods_storage;
///  该商品总价
@property (nonatomic,copy) NSString *goods_total;

//是否选中
@property (nonatomic,assign) BOOL isSelectedGood;

/// 是否可选 0,不可选  1,可选
@property (nonatomic,assign) BOOL isEnabled;

@end


@interface BBCartStore : NSObject

///  店铺id
@property (nonatomic,assign) NSInteger store_id;
@property (nonatomic,copy) NSString *store_flag;
///  店铺名称
@property (nonatomic,copy) NSString *store_name;
///  商品
@property (nonatomic,strong) NSArray *goods;
@property (nonatomic,strong) NSMutableArray *goodArr;

//是否选中
@property (nonatomic,assign) BOOL isSelectedStore;
/// 是否可选 0,不可选  1,可选
@property (nonatomic,assign) BOOL isEnabled;

@end



@interface BBShoppingCart : NSObject
///  店铺
@property (nonatomic,strong) NSArray *cart_list;
@property (nonatomic,strong) NSMutableArray *cartStore;

- (void)getStoreData:(NSArray *)cartStoreArr;

@end
