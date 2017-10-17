//
//  CateGoryViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CateGoryViewController.h"

#import "UIView+Extension.h"
#import "HomeDropDown.h"
#import "MTCategory.h"
#import "MetaTool.h"
#import "Const.h"

@interface CateGoryViewController ()<HomeDropDownDataSource, HomeDropDownDelegate>

@end

@implementation CateGoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HomeDropDown *dropdown = [HomeDropDown dropDown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    
    [self.view addSubview:dropdown];
    self.preferredContentSize = dropdown.size;
}

#pragma mark -- HomeDropDownDataSource

- (NSInteger)numberOfRowInMainTableView:(HomeDropDown *)homeDropdown{
    return [[MetaTool categories] count];
}
- (NSString *)homeDropDown:(HomeDropDown *)homeDropDown titleForRowInMainTable:(NSInteger)row{
    MTCategory *category = [MetaTool categories][row];
    return category.name;
}
- (NSString *)homeDropDownh:(HomeDropDown *)homeDropDown iconForRowInMainTable:(NSInteger)row{
    MTCategory *category = [MetaTool categories][row];
    return category.small_icon;
}

- (NSString *)homeDropDownh:(HomeDropDown *)homeDropDown selectedForRowInMainTable:(NSInteger)row{
    MTCategory *category = [MetaTool categories][row];
    return category.small_highlighted_icon;
}

- (NSArray *)homeDropDown:(HomeDropDown *)homeDropDown subTitleDateForRowInMainTable:(NSInteger)row{
    MTCategory *category = [MetaTool categories][row];
    return category.subcategories;
}

#pragma mark -- HomeDropDownDelegate
- (void)homeDropDown:(HomeDropDown *)homeDropDown didSelectMainTableViewRow:(NSInteger)row{
    MTCategory *category = [MetaTool categories][row];
    if (!category.subcategories.count) {
        [MTNotificationCenter postNotificationName:CategoryDidChangeNotification object:nil userInfo:@{SelectCategory : category}];
    }
    
}

- (void)homeDropDown:(HomeDropDown *)homeDropDown didSelectSubTableViewRow:(NSInteger)row withMaintableRow:(NSInteger)mainRow{
    MTCategory *category = [MetaTool categories][mainRow];
    NSString *subCategory = category.subcategories[row];
    [MTNotificationCenter postNotificationName:CategoryDidChangeNotification object:nil userInfo:@{ SelectCategory : category , SelectSubCategoryName : subCategory}];

    
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
