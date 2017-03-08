# UISearchControllerAndUILocalizedCollection

## 简介

UISearchController和UILocalizedCollection的使用Demo

##功能列表：
 1. **在单页面筛选**
 2. **多页面筛选**
 3. **简单字母分组排序**
 4. **汉语字母分组排序**


## 更新记录
2017.03.07 -- 实现在UILocalizedCollection进行字母区间和姓氏的排序

2017.03.06 -- 实现在UISearchController在单页面进行筛选和多个页面进行筛选的功能
 
## 方法简介
### 初始化UISearchController

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
    
    
###searchResultsUpdater代理中进行数据筛选

	- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
       NSString * searchString = searchController.searchBar.text;
       NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"SELF CONTAINS %@",searchString];
       self.filteredArray = [[self.dataArray filteredArrayUsingPredicate:predicate] mutableCopy];
       [self.tableView reloadData];
    }


### 初始化UILocalizedIndexedCollation及数据

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

### UILocalizedIndexedCollation对数据进行处理

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
 
 
## 效果图：
 
 ![筛选效果图1](https://github.com/MisterZhouZhou/UISearchControllerAndUILocalizedCollection/blob/master/imgs/show2.gif)
 <br/>
 <br/>
 <br/>

 
  ![排序1](https://github.com/MisterZhouZhou/UISearchControllerAndUILocalizedCollection/blob/master/imgs/show0.png)
 <br/>
 <br/>
 <br/>


 ![排序2](https://github.com/MisterZhouZhou/UISearchControllerAndUILocalizedCollection/blob/master/imgs/show1.png)
