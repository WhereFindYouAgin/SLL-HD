//
//  HomeTopItem.m
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "HomeTopItem.h"

@implementation HomeTopItem

+ (instancetype)item{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"HomeTopItem" owner:self options:nil]firstObject];
}

@end
