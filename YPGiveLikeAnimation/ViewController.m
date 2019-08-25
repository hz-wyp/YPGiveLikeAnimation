//
//  ViewController.m
//  YPGiveLikeAnimation
//
//  Created by 王艳苹 on 2019/8/24.
//  Copyright © 2019 esk. All rights reserved.
//

#import "ViewController.h"
#import "YPGiveLikeButton.h"

@interface ViewController ()
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    YPGiveLikeButton *likeBtn = [[YPGiveLikeButton alloc]initWithFrame:CGRectMake(100, 100, 60, 60) image:@"unselected_like" selectedImage:@"selected_like"];
    [self.view addSubview:likeBtn];
}

@end
