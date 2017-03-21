//
//  UIView+Factory.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "UIView+Factory.h"

@implementation UIView (Factory)

+ (instancetype)generateView
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor generate];
    
    return view;
}

@end
