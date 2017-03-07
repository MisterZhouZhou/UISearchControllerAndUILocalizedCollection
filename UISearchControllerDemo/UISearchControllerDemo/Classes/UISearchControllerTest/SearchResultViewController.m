//
//  SearchResultViewController.m
//  UISearchControllerDemo
//
//  Created by rayootech on 2017/3/7.
//  Copyright © 2017年 gmjr. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

#pragma mark - initUI
- (void)initUI{
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 40;
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        //此处frame设置向上偏移44是为了适配UISearchController push到结果页时的便宜问题
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -44, self.view.bounds.size.width, self.view.bounds.size.height+44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
    }
    return _tableView;
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
