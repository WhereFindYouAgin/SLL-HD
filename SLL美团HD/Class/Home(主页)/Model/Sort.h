//
//  Sort.h
//  SLL美团HD
//
//  Created by sll on 2017/10/17.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sort : NSObject
/** 排序名称 */
@property (nonatomic, copy) NSString *label;
/** 排序的值(将来发给服务器) */
@property (nonatomic, assign) int value;

@end
