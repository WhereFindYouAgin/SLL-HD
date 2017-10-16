//
//  HomeTopItem.h
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopItem : UIView
+ (instancetype)item;

- (void)addTarget:(id)target action:(SEL)action;

- (void)setName:(NSString*)name;
- (void)setSubName:(NSString *)subName;
- (void)setIcon:(NSString *)icon helighIcon:(NSString*)helighIcon;
@end
