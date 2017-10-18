//
//  HomeViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "HomeViewController.h"

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "HomeTopItem.h"
#import "Const.h"
#import "CateGoryViewController.h"
#import "CityController.h"
#import "SortViewController.h"
#import "NavigationController.h"
#import "City.h"
#import "Regions.h"
#import "Sort.h"
#import "MTCategory.h"
#import "MetaTool.h"
#import "DPAPI.h"


@interface HomeViewController ()<DPRequestDelegate>
@property (nonatomic, weak) UIBarButtonItem *categoryItem;

@property (nonatomic, weak) UIBarButtonItem *districtItem;

@property (nonatomic, weak) UIBarButtonItem *sortItem;

@property (nonatomic, strong) UIPopoverController *popover;
/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
/** 区域popover */
@property (nonatomic, strong) UIPopoverController *regionPopover;
/** 排序popover */
@property (nonatomic, strong) UIPopoverController *sortPopover;

/** 选择的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 选择的区域名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 选择的排序 */
@property (nonatomic, strong) Sort *selectSort;
/** 选择的分类名字 */
@property (nonatomic, copy) NSString *selectCategoryName;




@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNav];
    [self setupRightNav];
    [MTNotificationCenter addObserver:self selector:@selector(changeCategoryName:) name:CategoryDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeCityName:) name:CityDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeRegionName:) name:MTRegionDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeSortName:) name:SortDidChangeNotification object:nil];
    
}

#pragma mark -- 处理通知
//改变分类
- (void)changeCategoryName:(NSNotification *)notification{
    self.selectCategoryName = notification.userInfo[SelectSubCategoryName];
    MTCategory *category = notification.userInfo[SelectCategory];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.categoryItem.customView;
    [cityTopItem setSubName:self.selectCategoryName];
    [cityTopItem setName:category.name];
    [cityTopItem setIcon:category.icon helighIcon:category.highlighted_icon];
    [self.sortPopover dismissPopoverAnimated:YES ];
    
}

//改变城市
- (void)changeCityName:(NSNotification *)notifiction{
    self.selectedCityName = notifiction.userInfo[SelectCityName];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.districtItem.customView;
    [cityTopItem setName:[NSString stringWithFormat:@"%@--全部",self.selectedCityName]];
}

//改变区域
- (void)changeRegionName:(NSNotification *)notification{
    Regions *region = notification.userInfo[MTSelectRegion];
    NSString *subregionName = notification.userInfo[MTSelectSubregionName];
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    } else {
        self.selectedRegionName = subregionName;
    }
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    HomeTopItem *cityTopItem = (HomeTopItem *)self.districtItem.customView;
    [cityTopItem setName:[NSString stringWithFormat:@"%@-%@", self.selectedCityName,region.name]];
    [cityTopItem setSubName:subregionName];
    [self.regionPopover dismissPopoverAnimated:YES];
}

//改变排序
- (void)changeSortName:(NSNotification *)notification{
    self.selectSort = notification.userInfo[SelectSort];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.sortItem.customView;
    [cityTopItem setSubName:self.selectSort.label];
    [self.sortPopover dismissPopoverAnimated:YES ];
}

#pragma mark -- 与服务器交互
- (void)laodNewDeals{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //城市
    params[@"city"] = self.selectedCityName;
    //每页条数
    params[@"limit"] = @5;
    //分类
    if (self.selectCategoryName) {
        params[@"category"] = self.selectCategoryName;
    }
    //区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    //排序
    if (self.selectSort) {
        params[@"sort"] = @(self.selectSort.value);
    }
    [api requestWithURL:@"" params:params delegate:self];
}
#pragma mark -- DPAPIDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    
    DLog(@"结果 =%@",result);
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    DLog(@"错误信息%@",error);

}


#pragma mark  -- 设置导航栏
- (void)setUpLeftNav
{
    //1 , Logo
    UIBarButtonItem *logoBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:self action:nil];
    logoBar.enabled = NO;
    //2 , 分类
    HomeTopItem *catergoyTopItem = [HomeTopItem item];
    [catergoyTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *category = [[UIBarButtonItem alloc] initWithCustomView:catergoyTopItem];
    self.categoryItem = category;
    //3 , 地区
    HomeTopItem *districtTopItem = [HomeTopItem item];
    [districtTopItem addTarget:self action:@selector(districtClick)];
    UIBarButtonItem *district = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = district;
    //4 , 排序
    HomeTopItem *sortTopItem = [HomeTopItem item];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    [sortTopItem setName:@"排序"];
    [sortTopItem setIcon:@"icon_sort" helighIcon:@"icon_sort_highlighted"];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sort;
    
    self.navigationItem.leftBarButtonItems = @[logoBar, category, district, sort];
}


- (void)setupRightNav{
    UIBarButtonItem *map = [UIBarButtonItem initWithTarget:nil action:nil image:@"icon_map" hightImage:@"icon_map_highlighted"];
    map.width = 80;
    
    UIBarButtonItem *search = [UIBarButtonItem initWithTarget:nil action:nil image:@"icon_search" hightImage:@"icon_search_highlighted"];
    map.width = 80;
    
    self.navigationItem.rightBarButtonItems = @[map , search];
    
}

#pragma mark -- 顶部按钮的点击
- (void)categoryClick{
    CateGoryViewController *contVC = [[CateGoryViewController alloc]init];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contVC];
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.categoryPopover = popover;
}

- (void)districtClick
{
    City *city = [[[MetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName]] firstObject];
    CityController *contVC = [[CityController alloc]init];
    contVC.regions = city.regions;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contVC];
    contVC.popoverView = popover;
    [popover presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.regionPopover = popover;
}

- (void)sortClick
{
   SortViewController *sortViewController = [[SortViewController alloc]init];
    UIPopoverController *sortPopover = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    [sortPopover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.sortPopover = sortPopover;
}
- (void)dealloc{
    
    [MTNotificationCenter removeObserver:self];
}
@end
