//
//  UIColor+Factory.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "UIColor+Factory.h"

@implementation UIColor (Factory)

+ (UIColor *)generate
{
    return [UIColor colorWithRed:(arc4random_uniform(256) / 255.0)
                           green:(arc4random_uniform(256) / 255.0)
                            blue:(arc4random_uniform(256) / 255.0) alpha:1];
}

@end
