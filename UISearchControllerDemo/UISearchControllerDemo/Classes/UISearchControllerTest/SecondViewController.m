//
//  SecondViewController.m
//  UISearchControllerDemo
//
//  Created by rayootech on 2017/3/7.
//  Copyright © 2017年 gmjr. All rights reserved.
//

#import "SecondViewController.h"
#import "SearchResultViewController.h"

@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *filteredArray;
@property (nonatomic, strong) UISearchController * searchController;
@property(nonatomic,strong) SearchResultViewController *resultVC;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"多页面筛选";
    //initUI
    [self initUI];
    //initDta
    [self initData];
}

#pragma mark - initData
- (void)initData{
    NSArray *tempArray = [UIFont familyNames];
    self.dataArray = [tempArray copy];
}

#pragma mark - initUI
- (void)initUI{
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 40;
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configureSearchController];
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



- (void)configureSearchController {
    _resultVC = [SearchResultViewController new];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultVC];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"";
    //设置cancel 为取消
    [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    //这两句设置了设置了似乎也没有什么用，筛选结果页会先下偏移44，
    _searchController.definesPresentationContext = YES;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    //above
    //是否设置半透明覆盖层
    _searchController.dimsBackgroundDuringPresentation = YES;
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
}



#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString * searchString = searchController.searchBar.text;
    NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"SELF CONTAINS %@",searchString];
    self.filteredArray = [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
    _resultVC.dataArray = self.filteredArray;
    [_resultVC.tableView reloadData];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSLog(@"%@",self.dataArray[indexPath.row]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
