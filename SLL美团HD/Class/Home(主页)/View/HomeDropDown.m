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

@property (nonatomic, strong) MTCategory *selectCategory;


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
        return self.categories.count;
    }else{
        
        return  self.selectCategory.subcategories.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        MainCell *cell = [MainCell cellWithTaleView:tableView];
        MTCategory *myCategory = self.categories[indexPath.row];
        if (myCategory.subcategories ) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = myCategory.name;
        cell.imageView.image = [UIImage imageNamed:myCategory.small_icon];
        return cell;
    }else{
        SubCell *cell = [SubCell cellWithTaleView:tableView];
        cell.textLabel.text = self.selectCategory.subcategories[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mainTableView) {
        self.selectCategory = self.categories[indexPath.row];
        [self.subTableView reloadData];
    }
}

@end
