//
//  MainTableViewController.m
//  UISearchControllerDemo
//
//  Created by rayootech on 2017/3/7.
//  Copyright © 2017年 gmjr. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController
{
    NSArray *cellDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"功能菜单";
    cellDataArray = @[@{@"name":@"FirstViewController",@"title":@"单页面筛选"},
                      @{@"name":@"SecondViewController",@"title":@"多页面筛选"},
                      @{@"name":@"LocalizedTableViewController",@"title":@"简单字母分组排序"},
                      @{@"name":@"LocalizedTableViewController2",@"title":@"汉语字母分组排序"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = cellDataArray[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = cellDataArray[indexPath.row];
    UIViewController *vc = [[NSClassFromString(dict[@"name"]) alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
