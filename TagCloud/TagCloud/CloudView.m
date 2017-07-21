//
//  CloudView.m
//  TagCloud
//
//  Created by shang on 2017/7/19.
//  Copyright © 2017年 shang. All rights reserved.
//

#import "CloudView.h"

@interface CloudView ()

//创建数组存储所有label
@property (nonatomic, strong) NSMutableArray *labels;
//最大的label
@property (nonatomic, strong) UILabel *maxLab;
//固定好的矩形
@property (nonatomic, strong) NSMutableArray *setLabels;
//未固定好位置的label
@property (nonatomic, strong) NSMutableArray *unSetLabels;
//最小字体
@property (nonatomic, assign) NSInteger minFontSize;
//最大字体
@property (nonatomic, assign) NSInteger maxFontSize;
//竖向排列文字拆分成的数组
@property (nonatomic, strong) NSMutableArray *verticalArr;
//已经排列好的矩形的四个点的集合
@property (nonatomic, strong) NSMutableArray *pointArr;
//可用frame数组
@property (nonatomic, strong) NSMutableArray *frameArr;
//所有可用frame数组
@property (nonatomic, strong) NSMutableArray *allFrameArr;

@end



@implementation CloudView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.minFontSize = 10;
        self.maxFontSize = 20;
    }
    return self;
}

//存储所有label
- (NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _labels;
}
//固定好的label
- (NSMutableArray *)setLabels
{
    if (!_setLabels) {
        _setLabels = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _setLabels;
}
//未固定好位置的label
- (NSMutableArray *)unSetLabels
{
    if (!_unSetLabels) {
        _unSetLabels = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _unSetLabels;
}
//将横向的文字拆分成竖向的文字
- (NSMutableArray *)verticalArr
{
    if (!_verticalArr) {
        _verticalArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _verticalArr;
}
//已经排列好的矩形的四个点的集合
- (NSMutableArray *)pointArr
{
    if (!_pointArr) {
        _pointArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _pointArr;
}
//可用frame数组
- (NSMutableArray *)frameArr
{
    if (!_frameArr) {
        _frameArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _frameArr;
}
//所有可用frame数组
- (NSMutableArray *)allFrameArr
{
    if (!_allFrameArr) {
        _allFrameArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _allFrameArr;
}

- (void)productTagCloud
{
    //1.根据数组判断要生成多少个label
    NSInteger count = _tags.count;
    
    for (int i = 0; i < count; i++) {
        
        //2.随机设置文字的横竖
        NSString *text;
        BOOL isVertical = arc4random() % 2;
        if (isVertical) {
            text = [self stringVerticalAlignmentWithString:_tags[i]];
        }else{
            text = _tags[i];
        }
        
        //3.生成label
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = -1;
        label.text = text;
    
        //4.随机付给label字体大小
        NSInteger fontSize = (arc4random() % 11)+10;
        label.font = [UIFont systemFontOfSize:fontSize];
        CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
        
        label.frame = CGRectMake(0, 0, size.width, size.height);
        
        [self addSubview:label];
        
        //将所有label存储到数组中
        [self.labels addObject:label];
        //此时所有矩形没有准确的位置
        [self.unSetLabels addObject:label];
    }
    
    //5.获取最大矩形
    self.maxLab = self.labels[0];
    for (UILabel *label in self.labels) {
        double maxArea = self.maxLab.frame.size.width * self.maxLab.frame.size.width;
        double labArea = label.frame.size.width * label.frame.size.width;
        if (maxArea < labArea) {
            self.maxLab = label;
        }
    }
    
    //6.设置最大矩形的中心点为当前视图的中心点
    self.maxLab.center = CGPointMake(self.center.x-self.frame.origin.x, self.center.y-self.frame.origin.y);
    //排除最大矩形
    [self.setLabels addObject:self.maxLab];
    [self.unSetLabels removeObject:self.maxLab];
    
    //7.存储最大矩形的四个点
    [self storeTheFourPointOfTheReactAngleWithLabel:self.maxLab];
    
    //8.循环设置其他矩形
    do {
        //随机获取一个未设置的矩形
        NSInteger count = arc4random() % self.unSetLabels.count;
        UILabel *label = self.unSetLabels[count];
        //设置label的位置
        [self setRectAnglePlaceWithLabel:label];
    } while (self.unSetLabels.count > 0);
}

//设置竖向排列的字
- (NSString *)stringVerticalAlignmentWithString:(NSString *)string
{
    [self.verticalArr removeAllObjects];
    
    for (int i = 0; i < string.length; i++) {
        NSString *sepStr = [string substringWithRange:NSMakeRange(i, 1)];
        [self.verticalArr addObject:sepStr];
    }
    
    NSString *verticalStr = @"";
    
    for (NSString *sepStr in self.verticalArr) {
        if ([verticalStr isEqualToString:@""]) {
            verticalStr = sepStr;
        }
        else
        {
            verticalStr = [NSString stringWithFormat:@"%@\n%@",verticalStr,sepStr];
        }
        
    }
    
    NSString *str = verticalStr;
    
    return str;

}

//存储矩形的四个点
- (void)storeTheFourPointOfTheReactAngleWithLabel:(UILabel *)label
{
    CGPoint center = label.center;
    NSInteger width = label.frame.size.width*0.5;
    NSInteger height = label.frame.size.height*0.5;
    
    //顺序 从左上角逆时针计算
    CGPoint point0 = CGPointMake(center.x-width-1, center.y-height-1);
    CGPoint point1 = CGPointMake(center.x-width-1, center.y+height+1);
    CGPoint point2 = CGPointMake(center.x+width+1, center.y+height+1);
    CGPoint point3 = CGPointMake(center.x+width+1, center.y-height-1);
    
    //将结构体转化为NSValue
    NSValue *value0 = [NSValue valueWithCGPoint:point0];
    NSValue *value1 = [NSValue valueWithCGPoint:point1];
    NSValue *value2 = [NSValue valueWithCGPoint:point2];
    NSValue *value3 = [NSValue valueWithCGPoint:point3];
    
    //存储到数组中
    [self.pointArr addObject:value0];
    [self.pointArr addObject:value1];
    [self.pointArr addObject:value2];
    [self.pointArr addObject:value3];
}
//设置矩形的位置
- (void)setRectAnglePlaceWithLabel:(UILabel *)label
{
    //循环存储的点，获得可用位置
    [self.allFrameArr removeAllObjects];
    for (NSInteger i = 0; i<self.pointArr.count; i++) {
        NSValue *value = self.pointArr[i];
        //设置label的中心点直到不相交为止
        NSArray *array = [self getLabelFrameWithLabel:label andPoint:value];
        [self.allFrameArr addObjectsFromArray:array];
    }
    
    //获取距离中心点最近的frame
    CGRect rect = [self nearestDistanceToMaxLabelWithFrames:self.allFrameArr];
    label.frame = rect;
    //存储当前矩形的四个点
    [self storeTheFourPointOfTheReactAngleWithLabel:label];
    //排除当前矩形
    [self.setLabels addObject:label];
    [self.unSetLabels removeObject:label];
}

//根据已知的点设置矩形的frame
- (NSArray *)getLabelFrameWithLabel:(UILabel *)label andPoint:(NSValue *)value
{
    CGPoint point = [value CGPointValue];
    
    
    NSInteger width = label.frame.size.width;
    NSInteger height = label.frame.size.height;
    
    //逆时针计算中心点位置都增加一
    //第一个起点位置
    CGPoint origin0 = CGPointMake(point.x - width-1, point.y - height-1);
    
    //第二个起点位置
    CGPoint origin1 = CGPointMake(point.x - width-1, point.y);
    
    //第三个起点位置
    CGPoint origin2 = CGPointMake(point.x , point.y);
    
    //第四个起点位置
    CGPoint origin3 = CGPointMake(point.x, point.y - height-1);
    
    //获取可用frame
    CGRect rect0 = CGRectMake(origin0.x, origin0.y, width+1, height+1);
    CGRect rect1 = CGRectMake(origin1.x, origin1.y, width+1, height+1);
    CGRect rect2 = CGRectMake(origin2.x, origin2.y, width+1, height+1);
    CGRect rect3 = CGRectMake(origin3.x, origin3.y, width+1, height+1);
    
    BOOL isIntersect0,isIntersect1,isIntersect2,isIntersect3;
    BOOL isContain0,isContain1,iscontain2,iscontain3;
    
    //判断是否和同级矩形有相交
    isIntersect0 = [self frameIntersects:rect0];
    isIntersect1 = [self frameIntersects:rect1];
    isIntersect2 = [self frameIntersects:rect2];
    isIntersect3 = [self frameIntersects:rect3];
    
    //判断是否超出当前父类矩形
    isContain0 = [self frameContain:rect0];
    isContain1 = [self frameContain:rect1];
    iscontain2 = [self frameContain:rect2];
    iscontain3 = [self frameContain:rect3];
    
    
    //将可用的frame加入数组中
    [self.frameArr removeAllObjects];
    if (isIntersect0 == NO && isContain0 == YES) {
        NSValue *frame0 = [NSValue valueWithCGRect:rect0];
        [self.frameArr addObject:frame0];
    }
    if (isIntersect1 == NO && isContain1 == YES) {
        NSValue *frame1 = [NSValue valueWithCGRect:rect1];
        [self.frameArr addObject:frame1];
    }
    if (isIntersect2 == NO && iscontain2 == YES) {
        NSValue *frame2 = [NSValue valueWithCGRect:rect2];
        [self.frameArr addObject:frame2];
    }
    if (isIntersect3 == NO && iscontain3 == YES) {
        NSValue *frame3 = [NSValue valueWithCGRect:rect3];
        [self.frameArr addObject:frame3];
    }

    return self.frameArr;
}

//判断label的frame是否相交
- (BOOL)frameIntersects:(CGRect)frame {
    for (UILabel *label in self.setLabels) {
        if (CGRectIntersectsRect(frame, label.frame)) {
            //相交
            return YES;
        }
    }
    //不相交
    return NO;
}
//判断label是否超出父类矩形
- (BOOL)frameContain:(CGRect)frame{
    //获取中心点
    double x = frame.origin.x + frame.size.width*0.5;
    double y = frame.origin.y + frame.size.height*0.5;
    CGPoint center = CGPointMake(x, y);
    
    //获取中心点可在区域
    double xRect = 0 + frame.size.width*0.5;
    double yRect = 0 + frame.size.height *0.5;
    double width = self.frame.size.width - frame.size.width;
    double height = self.frame.size.height - frame.size.height;
    CGRect rect = CGRectMake(xRect, yRect, width, height);
    
    //判断中心点是否在可在区域内
    BOOL isContain = CGRectContainsPoint(rect, center);
    
    return isContain;
}
//求出离中心点最近的frame
- (CGRect)nearestDistanceToMaxLabelWithFrames:(NSArray *)frames
{
    CGPoint maxPoint = self.maxLab.center;
    CGRect nearRect = CGRectMake(0, 0, 0, 0);
    
    //默认最小距离是屏幕宽度的平方和
    double minDistance = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width;
    
    for (NSValue *value in frames) {
        CGRect rect = [value CGRectValue];
        CGPoint point = CGPointMake(rect.origin.x + rect.size.width*0.5, rect.origin.y+rect.size.height*0.5);
        double distance = (maxPoint.x-point.x)*(maxPoint.x-point.x) + (maxPoint.y-point.y)*(maxPoint.y-point.y);
        if (minDistance > distance) {
            minDistance = distance;
            nearRect = rect;
        }
    }
    return nearRect;
}

@end
