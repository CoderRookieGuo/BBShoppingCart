//
//  BBShoppingCart.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/18.
//
//

#import "BBShoppingCart.h"
#import "YYModel.h"


@implementation BBCartGood

#pragma mark - description
- (NSString *)description {
    
    return [self yy_modelDescription];
}
@end

@implementation BBCartStore

- (void)getGoodData:(NSArray *)goodArr {
    for (NSDictionary *goodDic in goodArr) {
        BBCartGood *good = [BBCartGood yy_modelWithDictionary:goodDic];
        [self.goodArr addObject:good];
    }
}

- (NSMutableArray *)goodArr {
    if (_goodArr == nil) {
        _goodArr = [[NSMutableArray alloc]initWithCapacity:5];
    }
    return _goodArr;
}

#pragma mark - description
- (NSString *)description {
    
    return [self yy_modelDescription];
}
@end


@implementation BBShoppingCart

- (void)getStoreData:(NSArray *)cartStoreArr {
    for (NSDictionary *dic in cartStoreArr) {
        BBCartStore *store = [BBCartStore yy_modelWithDictionary:dic];
        [store getGoodData:store.goods];
        [self.cartStore addObject:store];
    }
}

- (NSMutableArray *)cartStore {
    if (_cartStore == nil) {
        _cartStore = [NSMutableArray array];
    }
    return _cartStore;
}
#pragma mark - description
- (NSString *)description {
    
    return [self yy_modelDescription];
}

@end


