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

@interface DetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MTGlobalBg;    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.loadingView stopAnimating];

}

- (NSUInteger)supportedInterfaceOrientations{
   return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
