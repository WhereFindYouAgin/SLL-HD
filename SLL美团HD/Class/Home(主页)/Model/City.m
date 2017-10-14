//
//  City.m
//  SLL美团HD
//
//  Created by LUOSU on 2017/10/14.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "City.h"
#import "MJExtension.h"
#import "Regions.h"
@implementation City

- (NSDictionary *)objectClassInArray{
    
    return @{@"regions" : [Regions class]};
}
@end
