//
//  HomeTopItem.m
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "HomeTopItem.h"
@interface HomeTopItem()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;

@end

@implementation HomeTopItem

+ (instancetype)item{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"HomeTopItem" owner:self options:nil]firstObject];
}

- (void)addTarget:(id)target action:(SEL)action{
    
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setName:(NSString *)name{
    
    self.nameLabel.text = name;
}
- (void)setSubName:(NSString *)subName{
    
    self.subNameLabel.text = subName;
}
- (void)setIcon:(NSString *)icon helighIcon:(NSString *)helighIcon{
    
    [self.iconButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:helighIcon] forState:UIControlStateHighlighted];

}
@end
