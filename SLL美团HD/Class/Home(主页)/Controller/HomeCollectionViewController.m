//
//  HomeCollectionViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/18.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

#import "HomeTopItem.h"
#import "Const.h"
#import "CateGoryViewController.h"
#import "CityController.h"
#import "SortViewController.h"
#import "NavigationController.h"
#import "SearchViewController.h"
#import "City.h"
#import "Regions.h"
#import "Sort.h"
#import "MTCategory.h"
#import "MetaTool.h"

#import "UIView+AutoLayout.h"
#import "AwesomeMenu.h"
#import "MJRefresh.h"




@interface HomeCollectionViewController ()<AwesomeMenuDelegate>
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

@implementation HomeCollectionViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLeftNav];
    [self setupRightNav];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeCategoryName:) name:CategoryDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeCityName:) name:CityDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeRegionName:) name:MTRegionDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeSortName:) name:SortDidChangeNotification object:nil];
    [self setUpAweSomemenu];
}
#pragma mark -- setUpAweSomemenu
- (void)setUpAweSomemenu{
    // 1.中间的item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:nil];
    
    // 2.周边的item
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    NSArray *items = @[item0, item1, item2, item3];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem optionMenus:items];
    menu.alpha = 0.5;
    // 设置菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    // 设置开始按钮的位置
    menu.startPoint = CGPointMake(50, 150);
    // 设置代理
    menu.delegate = self;
    // 不要旋转中间按钮
    menu.rotateAddButton = NO;
    [self.view addSubview:menu];
    
    // 设置菜单永远在左下角
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}

#pragma mark -- 处理通知
//改变分类
- (void)changeCategoryName:(NSNotification *)notification{
    MTCategory *category = notification.userInfo[SelectCategory];
    NSString *subcategoryName = notification.userInfo[SelectSubCategoryName];
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) {
        self.selectCategoryName = category.name;
    }else{
        self.selectCategoryName = subcategoryName;
    }
    if([self.selectCategoryName isEqualToString:@"全部分类"]){
        self.selectCategoryName = nil;
    }
    
    HomeTopItem *cityTopItem = (HomeTopItem *)self.categoryItem.customView;
    [cityTopItem setSubName:subcategoryName];
    [cityTopItem setName:category.name];
    [cityTopItem setIcon:category.icon helighIcon:category.highlighted_icon];
    //    关闭分类
    [self.categoryPopover dismissPopoverAnimated:YES ];
    [self.collectionView headerBeginRefreshing];

}

//改变城市
- (void)changeCityName:(NSNotification *)notifiction{
    self.selectedCityName = notifiction.userInfo[SelectCityName];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.districtItem.customView;
    [cityTopItem setName:[NSString stringWithFormat:@"%@--全部",self.selectedCityName]];
    [cityTopItem setSubName:nil];
    self.selectedRegionName = nil;
    [self.collectionView headerBeginRefreshing];
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
    
    [self.collectionView headerBeginRefreshing];
}

//改变排序
- (void)changeSortName:(NSNotification *)notification{
    self.selectSort = notification.userInfo[SelectSort];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.sortItem.customView;
    [cityTopItem setSubName:self.selectSort.label];
    [self.sortPopover dismissPopoverAnimated:YES ];
    [self.collectionView headerBeginRefreshing];
}
#pragma mark -- 实现父类的方法
-(void)setParms:(NSMutableDictionary *)params{
    //城市
    params[@"city"] = self.selectedCityName;
    //分类
    if (self.selectCategoryName > 0) {
        params[@"category"] = self.selectCategoryName;
    }
    //区域
    if (self.selectedRegionName.length > 0) {
        params[@"region"] = self.selectedRegionName;
    }
    //排序
    if (self.selectSort) {
        params[@"sort"] = @(self.selectSort.value);
    }
    
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
    
    UIBarButtonItem *search = [UIBarButtonItem initWithTarget:self action:@selector(searchClicik) image:@"icon_search" hightImage:@"icon_search_highlighted"];
    
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
//搜索按钮点击
- (void)searchClicik{
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:[[SearchViewController alloc]init]];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)dealloc{
    
    [MTNotificationCenter removeObserver:self];
}

#pragma mark --
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    
}


- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.alpha = 1.0;
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu{
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.alpha = 0.5;
}

#pragma mark -- 屏幕发生改变







@end
