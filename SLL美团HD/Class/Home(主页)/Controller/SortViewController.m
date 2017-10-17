//
//  SortViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/17.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "SortViewController.h"
#import "Sort.h"
#import "MetaTool.h"
#import "UIView+Extension.h"
#import "Const.h"
@interface SortButton : UIButton
@property (nonatomic, strong) Sort *sort;

@end

@implementation SortButton
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}
-(void)setSort:(Sort *)sort{
    _sort = sort;
    [self setTitle:sort.label forState:UIControlStateNormal];
}

@end

@interface SortViewController ()

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *sorts = [MetaTool sorts];
    CGFloat buttonW = 100;
    CGFloat buttonH = 50;
    CGFloat btnMargin = 15;
    CGFloat viewHight = 0;
    for (int i = 0; i < sorts.count; i++) {
        SortButton * btn  = [[SortButton alloc] init];
        btn.x = btnMargin;
        btn.y = i * buttonH + btnMargin * (i + 1);
        btn.width = buttonW;
        btn.height = buttonH;
        btn.sort = sorts[i];
        [btn addTarget:self action:@selector(sortBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        viewHight = CGRectGetMaxY(btn.frame);
    }
    self.preferredContentSize = CGSizeMake(buttonW + btnMargin * 2, viewHight + btnMargin);
}

- (void)sortBtnClick:(SortButton *)btn
{
    Sort * sort = btn.sort;
    [MTNotificationCenter postNotificationName:SortDidChangeNotification object:nil userInfo:@{ SelectSort: sort}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
