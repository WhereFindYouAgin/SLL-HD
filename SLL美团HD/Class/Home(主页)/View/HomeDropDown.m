//
//  HomeDropDown.m
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "HomeDropDown.h"
#import "MTCategory.h"
#import "MainCell.h"
#import "SubCell.h"

@interface HomeDropDown()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (nonatomic, assign) NSInteger selectRow;


@end

@implementation HomeDropDown

+(instancetype)dropDown{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HomeDropDown" owner:nil options:nil] firstObject];
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.mainTableView) {
        return [self.dataSource numberOfRowInMainTableView:self];
    }else{
        return [[self.dataSource homeDropDown:self subTitleDateForRowInMainTable:self.selectRow] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        MainCell *cell = [MainCell cellWithTaleView:tableView];
        cell.textLabel.text = [self.dataSource homeDropDown:self titleForRowInMainTable:indexPath.row];
        NSArray *subRegions = [self.dataSource homeDropDown:self subTitleDateForRowInMainTable:indexPath.row];
        if (subRegions.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropDownh:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropDownh:self iconForRowInMainTable:indexPath.row]];
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropDownh:selectedForRowInMainTable:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropDownh:self selectedForRowInMainTable:indexPath.row]];
        }
        return cell;
    }else{
        SubCell *cell = [SubCell cellWithTaleView:tableView];
        NSArray *subRegions = [self.dataSource homeDropDown:self subTitleDateForRowInMainTable:self.selectRow];
        cell.textLabel.text = subRegions[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        self.selectRow = indexPath.row;
        [self.subTableView reloadData];
        if ([self.delegate respondsToSelector: @selector(homeDropDown:didSelectMainTableViewRow:)]) {
            [self.delegate homeDropDown:self didSelectMainTableViewRow:indexPath.row];
            }
    }else{
        if ([self.delegate respondsToSelector:@selector(homeDropDown:didSelectSubTableViewRow:withMaintableRow:)]) {
            [self.delegate homeDropDown:self didSelectSubTableViewRow:indexPath.row withMaintableRow:self.selectRow];
        }
        
    }
    
}

@end
