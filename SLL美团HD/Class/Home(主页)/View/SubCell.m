//
//  SubCell.m
//  SLL美团HD
//
//  Created by LUOSU on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "SubCell.h"

@implementation SubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+ (instancetype)cellWithTaleView:(UITableView *)tableView{
    static NSString *cellId = @"mySubCellID";
    SubCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (self) {
            UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
            self.backgroundView = backImageView;
            UIImageView *selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
            self.selectedBackgroundView = selectImageView;
        }
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
