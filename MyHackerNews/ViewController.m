//
//  ViewController.m
//  MyHackerNews
//
//  Created by YangDaqiong on 15/4/28.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import "ViewController.h"
#import "BrowserViewController.h"

@interface ViewController (){
    NSString *PostCellIdentifier;
    NSString *FetchErrorMessage;
    NSString *NoPostsErrorMessage;
    NSString *ShowBrowserIdentifier;
}

@end

@implementation ViewController{
}

@synthesize tableview;
@synthesize refreshControl;
@synthesize posts = _posts;
@synthesize UIpostfilter;
@synthesize postFilter;
@synthesize DefaultPostFilterType;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    _posts = [NSMutableArray new];
    ShowBrowserIdentifier = @"ShowBrowser";
    PostCellIdentifier = @"PostCell";
    FetchErrorMessage = @"Could Not Fetch Posts";
    NoPostsErrorMessage = @"No More Posts to Fetch";
    DefaultPostFilterType = PostFilterTypeTop;
    postFilter = DefaultPostFilterType;
    self.ReadTextColor = [UIColor colorWithRed:0.467 green:0.467 blue:0.467 alpha:1.0];
    self.ReadDetailTextColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    self.ErrorMessageLabelTextColor = [UIColor grayColor];
    self.nextPageId = @"";
    self.scrolledToBottom = false;
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureUI];
    [self fetchPosts];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(movedown:) userInfo:nil repeats:YES];
}

//-(void)movedown:(NSTimer*) t{
//    if(_posts != nil && [_posts count]>0){
//        CGPoint offset = tableview.contentOffset;
//        offset.y += 3;
//        [tableview setContentOffset:offset animated:false];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureUI{

    [refreshControl addTarget:self
                            action:@selector(fetchPosts)
                  forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tableview insertSubview:refreshControl atIndex:0];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    self.errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.errorMessageLabel.textColor = self.ErrorMessageLabelTextColor;
    self.errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.errorMessageLabel.font = [UIFont systemFontOfSize:ErrorMessageFontSize];
}

-(void)fetchPosts{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    
    NSString *postUrlAddition = [HNManager sharedManager].postUrlAddition;
    if(!self.scrolledToBottom){
        [[HNManager sharedManager] loadPostsWithFilter:postFilter completion:^(NSArray *posts, NSString *nextPageIdentifier) {
            if (posts != nil && [posts count]>0) {
                [self.posts removeAllObjects];
                _posts = [NSMutableArray new];
                [self.posts addObjectsFromArray:posts];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 0, 1) animated:false];
                    [self.tableview reloadData];
                    [self.refreshControl endRefreshing];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                });
            }
            else{
                self.posts = nil;
                [self.tableview reloadData];
                if (posts == nil) {
                    [self showErrorMessage:FetchErrorMessage];
                }
                else{
                    [self showErrorMessage:NoPostsErrorMessage];
                }
                self.scrolledToBottom = false;
                [self.refreshControl endRefreshing];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }
        }];
    }
    else if(postUrlAddition != nil){
        [[HNManager sharedManager] loadPostsWithUrlAddition:postUrlAddition completion:^(NSArray *posts, NSString *nextPageIdentifier) {
            if (posts != nil && [posts count] > 0) {
                [self.posts addObjectsFromArray:posts];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    [self.tableview reloadData];
                    [self.tableview flashScrollIndicators];
                    self.scrolledToBottom = false;
                    [self.refreshControl endRefreshing];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
                });
            }
            else{
                self.posts = nil;
                [self.tableview reloadData];
                if (posts == nil) {
                    [self showErrorMessage:FetchErrorMessage];
                }
                else{
                    [self showErrorMessage:NoPostsErrorMessage];
                }
                self.scrolledToBottom = false;
                [self.refreshControl endRefreshing];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
            }
        }];
    }

}
-(void)showErrorMessage:(NSString*)message{
    self.errorMessageLabel.text = message;
    self.tableview.backgroundView = self.errorMessageLabel;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_posts count];
}

-(void)stylePostCellAsRead:(UITableViewCell*) cell{
    cell.textLabel.textColor = self.ReadTextColor;
    cell.detailTextLabel.textColor = self.ReadDetailTextColor;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:PostCellIdentifier];
    
    HNPost *post = [_posts objectAtIndex:indexPath.row];

    if([[HNManager sharedManager] hasUserReadPost:post]){
        [self stylePostCellAsRead:cell];
    }
    
    cell.textLabel.text = post.Title;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%d points by %@", post.Points, post.Username];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableview deselectRowAtIndexPath:indexPath animated:true];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat y = offset.y + bounds.size.height - inset.bottom;
    CGFloat h = size.height;
    
    CGFloat reloadDistance = 10;
    
    if(y > h + reloadDistance && !self.scrolledToBottom && [_posts count]>0){
        self.scrolledToBottom = true;
        [self fetchPosts];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:ShowBrowserIdentifier]){
        UINavigationController *nav = segue.destinationViewController;
        BrowserViewController *webview = nav.viewControllers[0];
        UITableViewCell *cell = sender;
        HNPost *post = _posts[tableview.indexPathForSelectedRow.row];
        
        [[HNManager sharedManager] setMarkAsReadForPost:post];
        [self stylePostCellAsRead:cell];
        
        webview.post = post;
        
    }
}
-(IBAction)changePostFilter:(id)sender{
    if(sender == UIpostfilter){
        [HNManager sharedManager].postUrlAddition = nil;
        
        if (UIpostfilter.selectedSegmentIndex == 0) {
            postFilter = PostFilterTypeTop;
        } else if (UIpostfilter.selectedSegmentIndex == 1) {
            postFilter = PostFilterTypeNew;
        } else if (UIpostfilter.selectedSegmentIndex == 2) {
            postFilter = PostFilterTypeAsk;
        } else {
            NSLog(@"Bad segment index!");
        }
        
        [self fetchPosts];

    }
}
@end

