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
    
    NSArray *array = @[@"孔子",
                       @"秦始皇",
                       @"老子",
                       @"蔡伦",
                       @"汉武帝",
                       @"孟子",
                       @"隋文帝",
                       @"朱熹",
                       @"司马迁",
                       @"刘邦",
                       @"庄子",
                       @"唐太宗",
                       @"张仲景",
                       @"李斯",
                       @"宋太祖",
                       @"周公",
                       @"屈原",
                       @"董仲舒",
                       @"朱元璋",
                       @"道安",
                       @"冉闵",
                       @"张骞",
                       @"商鞅",
                       @"成吉思汗",
                       @"李白",
                       @"杜甫",
                       @"毕升",
                       @"惠能",
                       @"姬发",
                       @"李冰",
                       @"曹操",
                       @"康熙",
                       @"张陵",
                       @"孙中山",
                       @"苏轼",
                       @"朱棣"];
    
    CloudView *cloudView = [[CloudView alloc]initWithFrame:CGRectMake(0, 200, 320, 180)];
    [self.view addSubview:cloudView];
    cloudView.tags = array;
    [cloudView productTagCloud];

    
}

@end
