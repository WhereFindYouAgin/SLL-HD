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
#import "Masonry.h"
#import "CityGroup.h"
#import "MJExtension.h"

#define CoverTag 101

@interface CitiesController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cityGroups;


@end
const int MTCoverTag = 999;
@implementation CitiesController

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

#pragma mark -- searchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //CGRectMake(0, 54, self.tableView.width, self.tableView.height)
    UIView *cover = [[UIView alloc] init];//WithFrame:self.tableView.bounds];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.3;
    cover.tag = MTCoverTag;
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
    [self.view addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.mas_left);
        make.right.equalTo(self.tableView.mas_right);
        make.top.equalTo(self.tableView.mas_top);
        make.bottom.equalTo(self.tableView.mas_bottom);
    }];
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[self.view viewWithTag:MTCoverTag] removeFromSuperview];
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];

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
@end
