//
//  DealsViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/19.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "DealsViewController.h"

#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "DealCell.h"
#import "Deal.h"

#import "Const.h"
#import "MBProgressHUD+MJ.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "DPAPI.h"


@interface DealsViewController ()<DPRequestDelegate>
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

@implementation DealsViewController

static NSString * const reuseIdentifier = @"dealCell";

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

- (instancetype)init{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"DealCell" bundle:nil ] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = MTGlobalBg;
    self.collectionView .alwaysBounceVertical = YES;
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoerDeals)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}

#pragma mark -- 与服务器交互
- (void)loadDeals{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self setParms:params];
    //每页条数
    params[@"limit"] = @5;
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
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024? 3 : 2);
    UICollectionViewFlowLayout *layOut = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat inset = (size.width - layOut.itemSize.width * cols) / (cols + 1);
    layOut.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    layOut.minimumLineSpacing = inset;
    
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

@end
