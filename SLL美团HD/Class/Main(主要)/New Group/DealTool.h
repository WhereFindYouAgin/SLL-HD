//
//  DealTool.h
//  SLL美团HD
//
//  Created by sll on 2017/10/27.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Deal;

@interface DealTool : NSObject

/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(Deal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(Deal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(Deal *)deal;

@end
