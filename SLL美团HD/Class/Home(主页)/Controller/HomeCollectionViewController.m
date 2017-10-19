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
#import "UIView+AutoLayout.h"
#import "HomeTopItem.h"
#import "DealCell.h"
#import "Const.h"
#import "CateGoryViewController.h"
#import "CityController.h"
#import "SortViewController.h"
#import "NavigationController.h"
#import "City.h"
#import "Regions.h"
#import "Deal.h"
#import "Sort.h"
#import "MTCategory.h"
#import "MetaTool.h"

#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "DPAPI.h"


@interface HomeCollectionViewController ()<DPRequestDelegate>
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
/** 加载的Deals */
@property (nonatomic, strong) NSMutableArray *deals;
/** 加载的页码 */
@property (nonatomic, assign) int currentPage;
/** 最后的请求 */
@property (nonatomic, weak) DPRequest *lastRequest ;
/** 请求结果总数 */
@property (nonatomic, assign) int totalCount;

/** 没有数据显示 */
@property (nonatomic, weak) UIImageView *noDataView;


@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"dealCell";

- (instancetype)init{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
    
}

- (UIImageView *)noDataView{
    if (!_noDataView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:imageView];
        [imageView autoCenterInSuperview];
        _noDataView = imageView;
    }
    return _noDataView;
}
- (NSMutableArray *)deals{
    if (!_deals) {
        _deals = [NSMutableArray array];
    }
    return _deals;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DealCell" bundle:nil ] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = MTGlobalBg;
    
    [self setUpLeftNav];
    [self setupRightNav];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeCategoryName:) name:CategoryDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeCityName:) name:CityDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeRegionName:) name:MTRegionDidChangeNotification object:nil];
    
    [MTNotificationCenter addObserver:self selector:@selector(changeSortName:) name:SortDidChangeNotification object:nil];
    self.collectionView .alwaysBounceVertical = YES;
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoerDeals)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];

    
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

    [self loadNewDeals];
}

//改变城市
- (void)changeCityName:(NSNotification *)notifiction{
    self.selectedCityName = notifiction.userInfo[SelectCityName];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.districtItem.customView;
    [cityTopItem setName:[NSString stringWithFormat:@"%@--全部",self.selectedCityName]];
    [cityTopItem setSubName:nil];
    self.selectedRegionName = nil;
    [self loadNewDeals];
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
    
    [self loadNewDeals];
}

//改变排序
- (void)changeSortName:(NSNotification *)notification{
    self.selectSort = notification.userInfo[SelectSort];
    HomeTopItem *cityTopItem = (HomeTopItem *)self.sortItem.customView;
    [cityTopItem setSubName:self.selectSort.label];
    [self.sortPopover dismissPopoverAnimated:YES ];
    
    [self loadNewDeals];
}


#pragma mark -- 与服务器交互
- (void)loadDeals{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //城市
    params[@"city"] = self.selectedCityName;
    //每页条数
    params[@"limit"] = @5;
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
    params[@"page"]  = @(self.currentPage);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    NSLog(@"请求参数 = %@",params);
    
}

- (void)loadMoerDeals{
    self.currentPage ++;
    
    [self loadDeals];
}

- (void)loadNewDeals{
    self.currentPage = 1;
    [self loadDeals];
}
#pragma mark -- DPAPIDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    if (request != self.lastRequest) return;
    self.totalCount = [result[@"total_count"] intValue];;
    NSArray *newDeal = [Deal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (_currentPage == 1 ) {
        [self.deals removeAllObjects];
    }
    [self.deals addObjectsFromArray:newDeal];
    
    [self.collectionView reloadData];
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
    if (request != self.lastRequest) return;
    [MBProgressHUD showError:@"网络加载错误" toView:self.view];
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    
    // 3.如果是上拉加载失败了
    if (self.currentPage > 1) {
        self.currentPage--;
    }
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
#pragma mark -- 屏幕发生改变

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024? 3 : 2);
    UICollectionViewFlowLayout *layOut = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat inset = (size.width - layOut.itemSize.width * cols) / (cols + 1);
    layOut.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    layOut.minimumLineSpacing = inset;
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    self.collectionView.footerHidden = (self.deals.count == self.totalCount);
    self.noDataView.hidden = !(self.totalCount == 0);
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     DealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
