//
//  CityController.m
//  SLL美团HD
//
//  Created by LUOSU on 2017/10/14.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CityController.h"
#import "CitiesController.h"
#import "NavigationController.h"
#import "HomeDropDown.h"
#import "Regions.h"
#import "UIView+Extension.h"
#import "Const.h"

@interface CityController ()<HomeDropDownDataSource ,HomeDropDownDelegate>

@end

@implementation CityController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *title = [[self.view subviews] firstObject];
    HomeDropDown *homeDropDown = [HomeDropDown dropDown];
    homeDropDown.y = title.height;
    homeDropDown.dataSource = self;
    homeDropDown.delegate = self;
    [self.view addSubview:homeDropDown];
    // 设置控制器在popover中的尺寸
    self.preferredContentSize = CGSizeMake(homeDropDown.width, CGRectGetMaxY(homeDropDown.frame));
}
- (IBAction)changeCityClick:(id)sender {
    [self.popoverView dismissPopoverAnimated:YES];
    CitiesController *contVC = [[CitiesController alloc]init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:contVC];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark -- HomeDropDownDataSource
-(NSInteger)numberOfRowInMainTableView:(HomeDropDown *)homeDropdown{
    return self.regions.count;
}
- (NSString *)homeDropDown:(HomeDropDown *)homeDropDown titleForRowInMainTable:(NSInteger)row{
    Regions *region = self.regions[row];
    return region.name;
}

- (NSArray *)homeDropDown:(HomeDropDown *)homeDropDown subTitleDateForRowInMainTable:(NSInteger)row{
    Regions *region = self.regions[row];
    return region.subregions;
}

#pragma mark -- HomeDropDownDelegate
- (void)homeDropDown:(HomeDropDown *)homeDropDown didSelectMainTableViewRow:(NSInteger)row{
    Regions *region = self.regions[row];
    if (!region.subregions.count) {
        [MTNotificationCenter postNotificationName:MTRegionDidChangeNotification object:nil userInfo:@{MTSelectRegion : region}];
    }
    
}

- (void)homeDropDown:(HomeDropDown *)homeDropDown didSelectSubTableViewRow:(NSInteger)row withMaintableRow:(NSInteger)mainRow{
    Regions *region = self.regions[mainRow];;
    NSString *subRegion = region.subregions[row];
    [MTNotificationCenter postNotificationName:MTRegionDidChangeNotification object:nil userInfo:@{ MTSelectRegion : region , MTSelectSubregionName: subRegion}];
 
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
