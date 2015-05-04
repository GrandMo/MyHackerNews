//
//  BrowserViewController.m
//  MyHackerNews
//
//  Created by YangDaqiong on 15/4/30.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController

@synthesize post = _post;
@synthesize toolbarBarButtonItems;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    toolbarBarButtonItems =  self.toolbarItems;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.Webview.delegate = self;
    
    [self configureUI];
    [self loadUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{
    if([self isMovingFromParentViewController]){
        [self.Webview stopLoading];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    }
}

- (void)configureUI{
    self.title = _post.Title;
}

- (void)loadUrl{
    NSURL *url = [[NSURL alloc] initWithString:_post.UrlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.Webview loadRequest:request];
}

-(IBAction)closeModal:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)showSharingOptions:(id)sender{
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[_post.Title, _post.UrlString]
                                                        applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact];
    [self.navigationController presentViewController:activityViewController animated:true completion:nil];
}

#pragma mark - Browser Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    UIBarItem *back = toolbarBarButtonItems[0];
    back.enabled = self.Webview.canGoBack;
    UIBarItem *forward = toolbarBarButtonItems[2];
    forward.enabled = self.Webview.canGoForward;
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
