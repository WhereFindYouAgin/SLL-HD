//
//  CenterLineLabel.m
//  SLL美团HD
//
//  Created by sll on 2017/10/19.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CenterLineLabel.h"

@implementation CenterLineLabel




- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIRectFill(CGRectMake(0, rect.size.height * 0.5, rect.size.width, 1));
}


@end
