//
//  UILabel+Factory.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)

+ (instancetype)generateWithTtile:(NSString *)title
{
    UILabel *label = [self generate];
    label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    return label;
}

+ (instancetype)generate
{
    return [[UILabel alloc] init];
}

@end
