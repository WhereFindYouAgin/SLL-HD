//
//  Const.h
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <Foundation/Foundation.h>

//日志输出
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define MTColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define MTGlobalBg MTColor(230, 230, 230)

#define MTNotificationCenter [NSNotificationCenter defaultCenter]
extern  NSString *const CityDidChangeNotification;
extern  NSString *const SelectCityName;


