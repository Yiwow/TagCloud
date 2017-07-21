//
//  CloudView.h
//  TagCloud
//
//  Created by shang on 2017/7/19.
//  Copyright © 2017年 shang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudView : UIView

@property (nonatomic, strong) NSArray *tags;

//
- (void)productTagCloud;

@end
