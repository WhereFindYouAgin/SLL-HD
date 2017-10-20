//
//  DetailViewController.h
//  SLL美团HD
//
//  Created by sll on 2017/10/20.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Deal;
@interface DetailViewController : UIViewController

/** 当前商品*/
@property (nonatomic, strong) Deal *deal;

@end
