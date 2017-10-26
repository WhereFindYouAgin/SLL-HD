//
//  MTRestrictions.h
//  SLL美团HD
//
//  Created by work on 2017/10/26.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRestrictions : NSObject

/** int    是否需要预约，0：不是，1：是 */
@property (nonatomic, assign) int  is_reservation_required;
/** int    是否支持随时退款，0：不是，1：是*/
@property (nonatomic, assign) int  is_refundable;
/** string    附加信息(一般为团购信息的特别提示)*/
@property (nonatomic, copy) NSString *special_tips;

@end
