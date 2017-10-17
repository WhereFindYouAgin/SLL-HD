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
#import "NavigationController.h"
#import "City.h"
#import "MetaTool.h"

@interface HomeViewController ()
@property (nonatomic, weak) UIBarButtonItem *categoryItem;

@property (nonatomic, weak) UIBarButtonItem *districtItem;

@property (nonatomic, weak) UIBarButtonItem *sortItem;

@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, copy) NSString *cityName;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpLeftNav];
    [self setupRightNav];
    [MTNotificationCenter addObserver:self selector:@selector(changeCityName:) name:CityDidChangeNotification object:nil];
}
- (void)changeCityName:(NSNotification *)notifiction{
    self.cityName = notifiction.userInfo[SelectCityName];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.districtItem.customView;
    [cityTopItem setName:[NSString stringWithFormat:@"%@--全部",self.cityName]];
    
}
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

- (void)categoryClick{
    CateGoryViewController *contVC = [[CateGoryViewController alloc]init];
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contVC];
    [popover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.popover = popover;
}

- (void)districtClick
{
    City *city = [[[MetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.cityName]] firstObject] ;
    CityController *contVC = [[CityController alloc]init];
    contVC.regions = city.regions;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:contVC];
    [popover presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)sortClick
{
    DLog(@"sortClick");
}
- (void)dealloc{
    
    [MTNotificationCenter removeObserver:self];
}
@end
