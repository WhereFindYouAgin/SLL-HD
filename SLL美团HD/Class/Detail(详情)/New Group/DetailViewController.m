//
//  DetailViewController.m
//  SLL美团HD
//
//  Created by sll on 2017/10/20.
//  Copyright © 2017年 sll. All rights reserved.
//

#import "DetailViewController.h"
#import "Deal.h"
#import "Const.h"
#import "MTRestrictions.h"
#import "DealTool.h"

#import "MJExtension.h"
#import "MBProgressHUD.h"
#import "DPAPI.h"

@interface DetailViewController ()<UIWebViewDelegate, DPRequestDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

@property (weak, nonatomic) IBOutlet UIButton *leftTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
- (IBAction)back:(id)sender;

@end

@implementation DetailViewController
- (IBAction)buyNow:(id)sender {
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MTGlobalBg;    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]];
    [self.webView loadRequest:request];
    NSLog(@"添加了一句备注");
    //设置基本信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    
    //设置剩余时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];
    dead = [dead dateByAddingTimeInterval:24 * 60 * 60];
    NSDate *now = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:dead options:0];
    if (cmps.day > 365) {
        [self.leftTimeBtn setTitle:@"一年内不过期" forState:UIControlStateNormal];
    }else{
         [self.leftTimeBtn setTitle:[NSString stringWithFormat:@"%d天%d小时%d分钟", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 页码
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    // 设置收藏状态
    self.collectBtn.selected = [DealTool isCollected:self.deal];
    
}

- (IBAction)collect:(id)sender {
    if (self.collectBtn.isSelected) {
        [DealTool removeCollectDeal:self.deal];
    }else{
        [DealTool addCollectDeal:self.deal];
    }
    self.collectBtn.selected = !self.collectBtn.isSelected;
}

#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.loadingView stopAnimating];

}






- (NSUInteger)supportedInterfaceOrientations{
   return UIInterfaceOrientationMaskLandscape;
}

#pragma mark -- DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result{
    self.deal = [Deal objectWithKeyValues:[result[@"deals"] firstObject]];
    // 设置退款信息
    self.refundableAnyTimeButton.selected = self.deal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.deal.restrictions.is_refundable;
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
