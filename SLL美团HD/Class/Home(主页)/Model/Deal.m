//
//  Deal.m
//  SLL美团HD
//
//  Created by sll on 2017/10/18.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "Deal.h"
#import "MJExtension.h"

@implementation Deal
- (NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"desc": @"description"};
}
MJCodingImplementation;
@end
