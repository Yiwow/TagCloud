//
//  ViewController.m
//  TagCloud
//
//  Created by shang on 2017/7/19.
//  Copyright © 2017年 shang. All rights reserved.
//

#import "ViewController.h"

#import "CloudView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = @[@"曹操",
                       @"孙权",
                       @"刘备",
                       @"吕布",
                       @"赵云",
                       @"典韦",
                       @"马超",
                       @"关羽",
                       @"张飞",
                       @"曹操",
                       @"孙权",
                       @"刘备",
                       @"吕布",
                       @"赵云",
                       @"典韦",
                       @"马超",
                       @"关羽",
                       @"张飞",
                       @"曹操",
                       @"孙权",
                       @"刘备",
                       @"吕布",
                       @"赵云",
                       @"典韦",
                       @"马超",
                       @"关羽",
                       @"张飞",
                       @"曹操",
                       @"孙权",
                       @"刘备",
                       @"吕布",
                       @"赵云",
                       @"典韦",
                       @"马超",
                       @"关羽",
                       @"张飞"];
    
    CloudView *cloudView = [[CloudView alloc]initWithFrame:CGRectMake(0, 200, 320, 180)];
    [self.view addSubview:cloudView];
    cloudView.tags = array;
    [cloudView productTagCloud];

    
}

@end
