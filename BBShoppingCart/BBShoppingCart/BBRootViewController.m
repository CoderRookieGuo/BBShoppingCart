//
//  BBRootViewController.m
//  BBShoppingCart
//
//  Created by 郭绍彬 on 17/1/18.
//
//

#import "BBRootViewController.h"

@interface BBRootViewController ()
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,strong) NSMutableArray *classNames;
@end

@implementation BBRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"shoppingCartGroup" className:@"BBShoppingCartGroupVC"];
    [self addCell:@"shoppingCart" className:@"BBShoppingCartVC"];
    [self addCell:@"shoppingCartGroupBlock" className:@"BBShoppingCartGroupBlockVC"];
    if ([UIDevice currentDevice].systemVersion.doubleValue < 7) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title className:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"demo";
}

#pragma mark - Table View data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BBHome"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBHome"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = _classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        self.title = @" ";
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
