//
//  ViewController.h
//  MyHackerNews
//
//  Created by YangDaqiong on 15/4/28.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "libHN.h"

CGFloat const ErrorMessageFontSize = 16;

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UIpostfilter;


@property UIColor *ReadTextColor;
@property UIColor *ReadDetailTextColor;
@property UIColor *ErrorMessageLabelTextColor;
@property PostFilterType DefaultPostFilterType;
@property PostFilterType postFilter;
@property NSMutableArray *posts;
@property NSString *nextPageId;
@property BOOL scrolledToBottom;
@property UIRefreshControl *refreshControl;
@property UILabel *errorMessageLabel;

-(void)configureUI;
-(IBAction)changePostFilter:(id)sender;
@end

