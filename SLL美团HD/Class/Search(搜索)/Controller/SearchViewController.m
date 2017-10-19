//
//  SearchViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/19.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "SearchViewController.h"

#import "UIBarButtonItem+Extension.h"

#import "MJRefresh.h"
@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *search = [[UISearchBar alloc] init];
    search.placeholder = @"请输入你想搜索的团购";
    search.delegate = self;
    self.navigationItem.titleView = search;
    [self setupNav];
}

- (void)setupNav{
    self.navigationItem.title = @" 改变城市";
    UIBarButtonItem *dismissBarItem = [UIBarButtonItem initWithTarget:self action:@selector(dismissFromView) image:@"icon_back" hightImage:@"icon_back_highlighted"];
    self.navigationItem.leftBarButtonItems = @[dismissBarItem];
}

-(void)dismissFromView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar  {
    [self.collectionView headerBeginRefreshing];
    [searchBar resignFirstResponder];
}


#pragma mark -- 设置父类的方法
- (void)setParms:(NSMutableDictionary *)params{
    params[@"city"] = @"北京";
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}


@end
