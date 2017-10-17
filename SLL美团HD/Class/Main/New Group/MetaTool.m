//
//  MetaTool.m
//  SLL美团HD
//
//  Created by sll on 2017/10/17.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "MetaTool.h"
#import "MTCategory.h"
#import "MJExtension.h"
#import "City.h"

@implementation MetaTool

static NSArray *_cities;
+ (NSArray *)cities{
    if (!_cities) {
        _cities = [City objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}


static NSArray *_categories;
+(NSArray*)categories{
    if (!_categories) {
       _categories = [MTCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}

@end
