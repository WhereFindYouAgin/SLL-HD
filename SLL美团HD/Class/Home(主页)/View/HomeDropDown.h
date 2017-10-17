//
//  HomeDropDown.h
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeDropDown;

@protocol HomeDropDownDataSource <NSObject>

- (NSInteger)numberOfRowInMainTableView:(HomeDropDown *)homeDropdown;

/**
 左边每一行的标题
 */
- (NSString *)homeDropDown:(HomeDropDown *)homeDropDown titleForRowInMainTable:(NSInteger)row;
- (NSArray *)homeDropDown:(HomeDropDown *)homeDropDown subTitleDateForRowInMainTable:(NSInteger )row;
@optional
/**
 *  左边表格每一行的图标
 *  @param row          行号
 */
- (NSString *)homeDropDownh:(HomeDropDown *)homeDropDown iconForRowInMainTable:(NSInteger)row;
/**
 *  左边表格每一行的选中图标
 *  @param row          行号
 */
- (NSString *)homeDropDownh:(HomeDropDown *)homeDropDown selectedForRowInMainTable:(NSInteger)row;

@end
@interface HomeDropDown : UIView

+ (instancetype)dropDown;


/**
 分类
 */
@property (nonatomic, strong) NSArray *categories;

/**
 数据源
 */
@property (nonatomic, weak) id<HomeDropDownDataSource> dataSource;


@end
