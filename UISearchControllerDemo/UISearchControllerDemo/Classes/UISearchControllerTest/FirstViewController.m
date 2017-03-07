//
//  ViewController.m
//  UISearchControllerDemo
//
//  Created by rayootech on 2017/3/7.
//  Copyright © 2017年 gmjr. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSMutableArray * filteredArray;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单页面筛选";
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
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.placeholder = @"";
    //设置cancel 为取消
    [_searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    //是否设置半透明覆盖层(在initWithSearchResultsController：nil的情况下最好设置为NO)
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchBar.delegate = self;
    [_searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = _searchController.searchBar;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active){
      return self.filteredArray.count;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.searchController.active){
        cell.textLabel.text = self.filteredArray[indexPath.row];
    }
    else{
        cell.textLabel.text = self.dataArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active){
        NSLog(@"%@",self.filteredArray[indexPath.row]);
    }
    else{
         NSLog(@"%@",self.dataArray[indexPath.row]);
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString * searchString = searchController.searchBar.text;
    NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"SELF CONTAINS %@",searchString];
    self.filteredArray = [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
