//
//  NSObject+Factory.m
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import "NSObject+Factory.h"

@implementation NSObject (Factory)

@end

@implementation UIView (Factory)

+ (instancetype)generateView
{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor generate];
    
    return view;
}

@end

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

@implementation NSArray (Factory)

+ (NSArray *)mapNumber:(NSUInteger)num map:(id (^)(void))map
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < num; i ++) {
        [res addObject:map()];
    }
    return res;
}

@end

@implementation UIColor (Factory)

+ (UIColor *)generate
{
    return [UIColor colorWithRed:(arc4random_uniform(256) / 255.0)
                           green:(arc4random_uniform(256) / 255.0)
                            blue:(arc4random_uniform(256) / 255.0) alpha:1];
}

@end
