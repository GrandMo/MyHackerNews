//
//  BrowserViewController.h
//  MyHackerNews
//
//  Created by YangDaqiong on 15/4/30.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libHN.h"

@interface BrowserViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) HNPost *post;
@property (nonatomic, assign) NSArray *toolbarBarButtonItems;
@property (weak, nonatomic) IBOutlet UIWebView *Webview;

-(IBAction)closeModal:(id)sender;
-(IBAction)showSharingOptions:(id)sender;
@end
