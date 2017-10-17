//
//  CitiesController.m
//  SLL美团HD
//
//  Created by LUOSU on 2017/10/14.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CitiesController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "Masonry.h"
#import "CityGroup.h"
#import "MJExtension.h"
#import "Const.h"
#import "City.h"
#import "MetaTool.h"

#import "CitySearchResultController.h"

#define CoverTag 101

@interface CitiesController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cityGroups;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *cover;
@property (nonatomic, weak) CitySearchResultController *citySearchResultController;



@end
const int MTCoverTag = 999;
@implementation CitiesController

- (CitySearchResultController *)citySearchResultController
{
    if (_citySearchResultController == nil) {
        CitySearchResultController  *citySearchResultController = [[CitySearchResultController alloc] init];
        [self addChildViewController:citySearchResultController];
        self.citySearchResultController = citySearchResultController;
        [self.view addSubview:citySearchResultController.view];
        [citySearchResultController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [citySearchResultController.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:5];
    }
    return _citySearchResultController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    self.cityGroups = [CityGroup objectArrayWithFilename:@"cityGroups.plist"];
    self.tableView.sectionIndexColor = [UIColor blackColor];

}
- (void)setupNav{
    self.navigationItem.title = @" 改变城市";
    UIBarButtonItem *dismissBarItem = [UIBarButtonItem initWithTarget:self action:@selector(dismissFromView) image:@"btn_navigation_close" hightImage:@"btn_navigation_close_hl"];
    self.navigationItem.leftBarButtonItems = @[dismissBarItem];
}

- (void)dismissFromView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)coverHiden {
    [self.searchBar resignFirstResponder];
}

#pragma mark -- searchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //CGRectMake(0, 54, self.tableView.width, self.tableView.height)
//    UIView *cover = [[UIView alloc] init];//WithFrame:self.tableView.bounds];
//    cover.backgroundColor = [UIColor blackColor];
//    cover.alpha = 0.3;
//    cover.tag = MTCoverTag;
//    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
//    [self.view addSubview:cover];
//    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.tableView.mas_left);
//        make.right.equalTo(self.tableView.mas_right);
//        make.top.equalTo(self.tableView.mas_top);
//        make.bottom.equalTo(self.tableView.mas_bottom);
//    }];
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = MTColor(47, 178, 157);
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0.5;
    }];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[self.view viewWithTag:MTCoverTag] removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0.0;
    }];
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];

}
//搜索框文字改变
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   
    if (searchText.length > 0) {
        self.citySearchResultController.view.hidden = NO;
        self.citySearchResultController.searchText = searchText;

    }else{
        self.citySearchResultController.view.hidden = YES;

    }
}

#pragma mark -- tableview datasource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CityGroup *group = [self.cityGroups objectAtIndex:section];
    return group.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"myCitiesID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    CityGroup *group = [self.cityGroups objectAtIndex:indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CityGroup *group = [self.cityGroups objectAtIndex:section];
    return group.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView*)tableView{
    //    NSMutableArray *titles = [NSMutableArray array];
    //    for (MTCityGroup *group in self.cityGroups) {
    //        [titles addObject:group.title];
    //    }
    //    return titles;
    return [self.cityGroups valueForKeyPath:@"title"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityGroup *group = self.cityGroups[indexPath.section];
    [MTNotificationCenter postNotificationName:CityDidChangeNotification object:nil userInfo:@{ SelectCityName : group.cities[indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
