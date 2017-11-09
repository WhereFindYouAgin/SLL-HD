//
//  DealCell.h
//  SLL美团HD
//
//  Created by sll on 2017/10/18.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Deal;
@class DealCell;

@protocol DealCellDelegate <NSObject>

- (void)dealCellCoverDidChange:(DealCell *)cell;

@end
@interface DealCell : UICollectionViewCell
@property (nonatomic, strong) Deal *deal;
@property (nonatomic, weak)  id<DealCellDelegate> delegate;


@end
