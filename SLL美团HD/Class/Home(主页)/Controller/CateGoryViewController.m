//
//  CateGoryViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/13.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CateGoryViewController.h"

#import "UIView+Extension.h"
#import "HomeDropDown.h"
#import "MJExtension.h"
#import "MTCategory.h"

@interface CateGoryViewController ()

@end

@implementation CateGoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    HomeDropDown *dropdown = [HomeDropDown dropDown];
    dropdown.categories = [MTCategory objectArrayWithFilename:@"categories.plist"];
    
    [self.view addSubview:dropdown];
    self.preferredContentSize = dropdown.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
