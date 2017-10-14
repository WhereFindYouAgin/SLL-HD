//
//  CityController.m
//  SLL美团HD
//
//  Created by LUOSU on 2017/10/14.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "CityController.h"
#import "CitiesController.h"
#import "NavigationController.h"

@interface CityController ()

@end

@implementation CityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)changeCityClick:(id)sender {
    CitiesController *contVC = [[CitiesController alloc]init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:contVC];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nav animated:YES completion:nil];
    
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
