//
//  HairlineView.m
//  MyHackerNews
//
//  Created by YangDaqiong on 15/4/28.
//  Copyright (c) 2015年 GM. All rights reserved.
//

#import "HairlineView.h"

@implementation HairlineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.layer.borderColor = self.backgroundColor.CGColor;
    self.layer.borderWidth = (1.0/[UIScreen mainScreen].scale)/2;
    self.backgroundColor = [UIColor clearColor];
}
@end
