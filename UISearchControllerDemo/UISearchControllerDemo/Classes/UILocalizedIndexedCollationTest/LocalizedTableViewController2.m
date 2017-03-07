//
//  LocalizedTableViewController2.m
//  UISearchControllerDemo
//
//  Created by rayootech on 2017/3/7.
//  Copyright © 2017年 gmjr. All rights reserved.
//

#import "LocalizedTableViewController2.h"
#import "Person.h"

@interface LocalizedTableViewController2 ()

@end

@implementation LocalizedTableViewController2
{
    NSMutableArray *dataArray;
    NSMutableArray *sectionTitleArray;
    UILocalizedIndexedCollation *localizedCollection;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"汉语字母分组排序";
    self.tableView.rowHeight = 40;
    
    //配置数据源
    NSArray *firstNameArray = @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"郭",@"松",@"宋",@"长",@"大",@"小"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i=0; i<firstNameArray.count; i++) {
        Person *p = [Person new];
        p.name = [NSString stringWithFormat:@"%@",firstNameArray[i]];
        [tempArray addObject:p];
    }
  
    //初始化UILocalizedIndexedCollation
    localizedCollection = [UILocalizedIndexedCollation currentCollation];
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[localizedCollection sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [newSectionsArray addObject:array];
    }
    //将每个人按name分到某个section下
    for (Person *temp in tempArray) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [localizedCollection sectionForObject:temp collationStringSelector:@selector(name)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:temp];
    }

    //对每个section中的数组按照name属性排序
    for (int index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [localizedCollection sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    
    //section title
    sectionTitleArray = [NSMutableArray array];
    NSMutableArray *tempArr = [NSMutableArray array];
    [newSectionsArray enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (array.count == 0) {
            [tempArr addObject:array];
        }else{
            [sectionTitleArray addObject:[localizedCollection sectionTitles][idx]];
        }
    }];
    [newSectionsArray removeObjectsInArray:tempArr];
    
    dataArray = newSectionsArray.copy;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return sectionTitleArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *tempArray = dataArray[section];
    return tempArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSMutableArray *tempArray = dataArray[indexPath.section];
    Person *person = tempArray[indexPath.row];
    cell.textLabel.text = person.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return sectionTitleArray[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionTitleArray;
}


@end
