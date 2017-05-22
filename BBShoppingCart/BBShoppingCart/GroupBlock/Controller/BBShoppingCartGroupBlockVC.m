//
//  BBShoppingCartGroupBlockVC.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 2017/2/4.
//
//

#import "BBShoppingCartGroupBlockVC.h"
#import "YYModel.h"
#import "BBTableView.h"
#import "BBShoppingCart.h"
#import "BBGoodBlockCell.h"
#import "BBHeaderBlockView.h"
#import "BBBottomBlockView.h"

@interface BBShoppingCartGroupBlockVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BBBottomBlockView *bottomView;
@property (nonatomic,strong) BBShoppingCart *shoppingCart;
@end

@implementation BBShoppingCartGroupBlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
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
    
    _bottomView = [[BBBottomBlockView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    
    __weak __typeof (&*self)weakSelf = self;
    _bottomView.bottomSelectClickBlock = ^() {
        weakSelf.bottomView.isAllSelect = !weakSelf.bottomView.isAllSelect;
        [weakSelf isSlectAllStoreWithBottomView:weakSelf.bottomView];
        // 计算总价
        [weakSelf countTotalPrice];
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:_bottomView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:@""];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        BBShoppingCart *shoppingCart = [BBShoppingCart yy_modelWithDictionary:dic];
        [shoppingCart getStoreData:shoppingCart.cart_list];
        _shoppingCart = shoppingCart;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 计算总价
//            [self countTotalPrice];
            [_tableView reloadData];
        });
    });

    
}

#pragma mark - data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _shoppingCart.cartStore.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BBCartStore *store = _shoppingCart.cartStore[section];
    return store.goodArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBGoodBlockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBShoppingCartGroupBlockCell"];
    if (!cell) {
        cell = [[BBGoodBlockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBShoppingCartGroupBlockCell"];
    }
    BBCartStore *store = _shoppingCart.cartStore[indexPath.section];
    BBCartGood *good = store.goodArr[indexPath.row];
    
    cell.good = good;
    
    __weak __typeof(&*self)weakSelf = self;
    cell.cellDidClickSelectBlock = ^() {
        [weakSelf cellDidClickSelectWithStore:store good:good cellForRowAtIndexPath:indexPath];
    };
    cell.cellChangeGoodNumBlock = ^(NSString *goodNum) {
        [weakSelf cellChangeGoodNumWithGood:good cellForRowAtIndexPath:indexPath goodNumber:goodNum];
    };
    return cell;
}

#pragma mark - delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BBHeaderBlockView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"BBShoppingCartGroupHeader"];
    if (headerView == nil) {
        headerView = [[BBHeaderBlockView alloc] initWithReuseIdentifier:@"BBShoppingCartGroupHeader"];
    }
    BBCartStore *store = self.shoppingCart.cartStore[section];
    headerView.store = store;
    __weak __typeof (&*self)weakSelf = self;
    headerView.headerDidClickSelectBlock = ^() {
        [weakSelf headerDidClickSelectWithStore:store viewForHeaderInSection:section];
    };
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
- (void)cellChangeGoodNumWithGood:(BBCartGood *)good cellForRowAtIndexPath:(NSIndexPath *)indexPath goodNumber:(NSString *)goodNum {
    
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
#pragma mark - Select
#pragma mark cell select
- (void)cellDidClickSelectWithStore:(BBCartStore *)store good:(BBCartGood *)good cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (void)headerDidClickSelectWithStore:(BBCartStore *)store viewForHeaderInSection:(NSInteger)section {
    store.isSelectedStore = !store.isSelectedStore;
    // 当点击店铺的时候，让该店铺下面的商品跟店铺状态一致
    [self isSlectAllGoodWithStoreModel:store];
    // 当点击店铺的时候，判断是否全选
    self.bottomView.isAllSelect = [self isAllStoreDidSelected];
    // 计算总价
    [self countTotalPrice];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
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
- (void)isSlectAllStoreWithBottomView:(BBBottomBlockView *)bottomView {
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
