//
//  CollectViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/20.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CollectViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "MJRefresh.h"

#import "Const.h"
#import "DealTool.h"
#import "DealCell.h"
#import "DetailViewController.h"

NSString *const MTDone = @"完成";
NSString *const MTEdit = @"编辑";
#define MTString(str) [NSString stringWithFormat:@"  %@  ", str]

@interface CollectViewController ()
@property (nonatomic, weak) UIImageView *noDataView;

@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, assign) int currentPage;


@property (nonatomic, strong)  UIBarButtonItem *backItem ;
@property (nonatomic, strong)  UIBarButtonItem *selectAllItem ;
@property (nonatomic, strong)  UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong)  UIBarButtonItem *removeItem;


@end

@implementation CollectViewController

static NSString * const reuseIdentifier = @"dealCell";

- (UIImageView *)noDataView{
    if (!_noDataView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        [self.view addSubview:imageView];
        [imageView autoCenterInSuperview];
        _noDataView = imageView;
    }
    return _noDataView;
}
- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem initWithTarget:self action:@selector(back) image:@"icon_back" hightImage:@"icon_back_highlighted"];
    }
    return _backItem;
}
- (UIBarButtonItem *)selectAllItem{
    if (!_selectAllItem) {
        _selectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selctAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem{
    if (!_unselectAllItem) {
        _unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselctAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)removeItem{
    if (!_removeItem) {
        _removeItem = [[UIBarButtonItem alloc] initWithTitle:MTString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
    }
    return _removeItem;
}



- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
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
    self.collectionView.backgroundColor = MTGlobalBg;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.title = @"个人收藏";
    self.navigationItem.leftBarButtonItem = self.backItem;
    [self loadMoreDeals];
    
    [MTNotificationCenter addObserver:self selector:@selector(collectStateChange:) name:CollectStateDidChangeNotification object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];

}
- (void)edit:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:MTEdit]) {
        item.title = MTDone;
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem,  self.unselectAllItem, self.removeItem];
    }else{
        item.title = MTEdit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
    
}
- (void)loadMoreDeals{
    self.currentPage ++;
    [self.deals addObjectsFromArray:[DealTool collectDeals:self.currentPage]];
    // 3.刷新表格
    [self.collectionView reloadData];
    
}

- (void)collectStateChange:(NSNotification *)notification{
    [self.deals removeAllObjects];
    
    self.currentPage = 0;
    [self loadMoreDeals];
}

- (void)dealloc{
    [MTNotificationCenter removeObserver:self];
}

/**
 当屏幕旋转,控制器view的尺寸发生改变调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024) ? 3 : 2;
    
    // 根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    // 设置每一行之间的间距
    layout.minimumLineSpacing = inset;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 计算一遍内边距
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    self.noDataView.hidden = !(self.deals.count == 0);

    self.collectionView.footerHidden = self.deals.count > [DealTool collectDealsCount] ? NO : YES;
    
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   DealCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVc = [[DetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}



- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
