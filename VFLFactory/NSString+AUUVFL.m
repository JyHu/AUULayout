//
//  NSString+AUUVFL.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "NSString+AUUVFL.h"
#import "NSObject+AUUVFLPrivate.h"

@implementation NSString (AUUVFL)

- (NSString *(^)(CGFloat))interval
{
    return [^(CGFloat interval){
        NSAssert1(interval >=0, @"设置的间距必须是个有效值", self);
        return [self append:@"%@-%@-", self && self.length == 2 ? @"|" : @"", @(interval)];
    } copy];
}

- (NSString *)standardInterval
{
    return [self append:@"-"];
}

- (NSString *(^)(UIView *))nextTo
{
    return [^(UIView *view){
        NSString *res =  [self append:@"[%@%@]", [self.base addHashKey:view], view.releation ?: @""];
        view.releation = nil;
        return res;
    } copy];
}

- (NSString *)end
{
    return [[self append:@"|"] endL];
}

- (NSString *)endL
{
    [self.base addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:self options:NSLayoutFormatDirectionMask metrics:nil views:self.base.layoutKits]];
    return self;
}

- (NSString *)append:fmt, ...
{
    va_list args;
    va_start(args, fmt);
    NSString *res = [self stringByAppendingString:[[NSString alloc] initWithFormat:fmt arguments:args]];
    va_end(args);
    
    res.base = self.base;
    
    return res;
}


@end
