//
//  BBShoppingCartGroupVC.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/18.
//
//

#import "BBShoppingCartGroupVC.h"
#import "YYModel.h"
#import "BBShoppingCart.h"
#import "BBTableView.h"
#import "BBGoodCell.h"
#import "BBHeaderView.h"
#import "BBBottomView.h"


@interface BBShoppingCartGroupVC () <UITableViewDelegate,UITableViewDataSource,BBGoodCellDelegate,BBHeaderViewDelegate,BBBottomViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BBBottomView *bottomView;
@property (nonatomic,strong) BBShoppingCart *shoppingCart;
@property (nonatomic,strong) NSMutableArray *loseEffecArr;
@end

@implementation BBShoppingCartGroupVC

- (instancetype)init {
    self = [super init];
    
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.loseEffecArr = @[].mutableCopy;
    _tableView = [[BBTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 50, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.f green:245/255.f blue:245/255.f alpha:1];
    
    _bottomView = [[BBBottomView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    _bottomView.delegate = self;
    [self.view addSubview:_bottomView];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:@""];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BBShoppingCart *shoppingCart = [BBShoppingCart yy_modelWithDictionary:dic];
        [shoppingCart getStoreData:shoppingCart.cart_list];
        [self countLoseEffectivenessGoodsWithShoppingCartModel:shoppingCart];
        _shoppingCart = shoppingCart;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 计算总价
            [self countTotalPrice];
            [_tableView reloadData];
        });
    });
}

#pragma mark - Count  Lose Effectiveness Goods
- (void)countLoseEffectivenessGoodsWithShoppingCartModel:(BBShoppingCart *)shoppingCart {
    __weak __typeof(&*self)weakSelf = self;
    [shoppingCart.cartStore enumerateObjectsUsingBlock:^(BBCartStore *store, NSUInteger idx, BOOL * _Nonnull stop) {
        [store.goodArr enumerateObjectsUsingBlock:^(BBCartGood *good, NSUInteger i, BOOL * _Nonnull stop) {
            if (!good.state) {
                [store.goodArr removeObjectAtIndex:i];
                [weakSelf.loseEffecArr addObject:good];
            }
        }];
    }];
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shoppingCart.cartStore.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BBCartStore *store = _shoppingCart.cartStore[section];
    return store.goodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBShoppingCartGroupCell"];
    if (!cell) {
        cell = [[BBGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBShoppingCartGroupCell"];
    }
    
    BBCartStore *store = _shoppingCart.cartStore[indexPath.section];
    BBCartGood *good = store.goodArr[indexPath.row];
    
    cell.good = good;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;

}
 
#pragma mark - Table View delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BBHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BBShoppingCartGroupHeader"];
    if (headerView == nil) {
        headerView = [[BBHeaderView alloc] initWithReuseIdentifier:@"BBShoppingCartGroupHeader"];
    }
    BBCartStore *store = self.shoppingCart.cartStore[section];
    headerView.store = store;
    headerView.section = section;
    headerView.delegate = self;
    return headerView;

}
#pragma mark height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 54;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
#pragma mark delete
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeGoodAtIndexPath:indexPath];
    }
}


// 删除
- (void)removeGoodAtIndexPath:(NSIndexPath *)indexPath {
    BBCartStore *store = _shoppingCart.cartStore[indexPath.section];
    [store.goodArr removeObjectAtIndex:indexPath.row];
    if (store.goodArr.count < 1) {
        [self.shoppingCart.cartStore removeObjectAtIndex:indexPath.section];
        [self.tableView reloadData];
    } else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
    // 计算总价
    [self countTotalPrice];
}
#pragma mark - Change count
- (void)cellChangeGoodNumWithCell:(BBGoodCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath goodNumber:(NSString *)goodNum {
    BBCartStore *store = _shoppingCart.cartStore[indexPath.section];
    BBCartGood *good = store.goodArr[indexPath.row];
    if (goodNum.integerValue < 1) {
        NSLog(@"删除商品");
        [self removeGoodAtIndexPath:indexPath];
        return;
    } else if (goodNum.integerValue < good.minnum.integerValue) {
        NSLog(@"至少购买%@",good.minnum);
        good.goods_num = good.minnum;
    } else if (goodNum.integerValue > good.goods_storage.integerValue) {
        NSLog(@"最多购买%@",good.goods_storage);
        good.goods_num = good.goods_storage;
    } else {
        good.goods_num = goodNum;
    }
    // 计算总价
    [self countTotalPrice];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Select delegate
#pragma mark cell select
- (void)cellDidClickSelectWithCell:(BBGoodCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBCartStore *store = _shoppingCart.cartStore[indexPath.section];
    BBCartGood *good = store.goodArr[indexPath.row];
    good.isSelectedGood = !good.isSelectedGood;
    // 当点击单个商品的时候，判断是否该店铺是否选中
    store.isSelectedStore = [self isAllCellDidSelectedWithStoreModel:store];
    // 当点击单个商品的时候，判断是否全选
    self.bottomView.isAllSelect = [self isAllStoreDidSelected];
    // 计算总价
    [self countTotalPrice];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark header select
- (void)headerDidClickSelectWithHeaderView:(BBHeaderView *)headerView viewForHeaderInSection:(NSInteger)section {
    BBCartStore *store = _shoppingCart.cartStore[section];
    store.isSelectedStore = !store.isSelectedStore;
    // 当点击店铺的时候，让该店铺下面的商品跟店铺状态一致
    [self isSlectAllGoodWithStoreModel:store];
    // 当点击店铺的时候，判断是否全选
    self.bottomView.isAllSelect = [self isAllStoreDidSelected];
    // 计算总价
    [self countTotalPrice];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark bottom select
- (void)bottomSelectClickWithBottomView:(BBBottomView *)bottomView {
    bottomView.isAllSelect = !bottomView.isAllSelect;
    [self isSlectAllStoreWithBottomView:bottomView];
    // 计算总价
    [self countTotalPrice];
    [self.tableView reloadData];
}
#pragma mark - Other
// 当点击单个商品的时候，判断是否该店铺是否选中
- (BOOL)isAllCellDidSelectedWithStoreModel:(BBCartStore *)store {
    
    __block NSInteger count = 0;
    [store.goodArr enumerateObjectsUsingBlock:^(BBCartGood *good, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!good.isSelectedGood) {
            count ++;
        }

    }];
    if (count == store.goodArr.count) {
        return NO; // 选中店铺
    }
    return YES; // 不选店铺
}
// 当点击单个商品或者店铺的时候，判断是否全选
- (BOOL)isAllStoreDidSelected {
    __block NSInteger count = 0;
    [_shoppingCart.cartStore enumerateObjectsUsingBlock:^(BBCartStore *store, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!store.isSelectedStore) {
            count ++;
        }
        
    }];
    if (count == _shoppingCart.cartStore.count) {
        return NO; // 全选
    }
    return YES; // 不全选
}

// 当点击店铺的时候，让该店铺下面的商品跟店铺状态一致
- (void)isSlectAllGoodWithStoreModel:(BBCartStore *)store {
    
    [store.goodArr enumerateObjectsUsingBlock:^(BBCartGood *good, NSUInteger idx, BOOL * _Nonnull stop) {
        good.isSelectedGood = store.isSelectedStore;
    }];
}
// 当点击全选的时候，让所有商品跟全选状态一致
- (void)isSlectAllStoreWithBottomView:(BBBottomView *)bottomView {
     __weak __typeof(&*self)weakSelf = self;
    [_shoppingCart.cartStore enumerateObjectsUsingBlock:^(BBCartStore *store, NSUInteger idx, BOOL * _Nonnull stop) {
        store.isSelectedStore = bottomView.isAllSelect;
        [weakSelf isSlectAllGoodWithStoreModel:store];
    }];
}

// 计算价格
- (void)countTotalPrice {
    __block double totlePrice = 0.00;
    [_shoppingCart.cartStore enumerateObjectsUsingBlock:^(BBCartStore *store, NSUInteger idx, BOOL * _Nonnull stop) {
        [store.goodArr enumerateObjectsUsingBlock:^(BBCartGood *good, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!good.isSelectedGood) {
                totlePrice += [good.goods_price doubleValue] * good.goods_num.integerValue;
            }
        }];
    }];
    self.bottomView.allPrice = totlePrice;
}

@end
