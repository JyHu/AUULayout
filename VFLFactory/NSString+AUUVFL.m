//
//  NSString+AUUVFL.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "NSString+AUUVFL.h"
#import "NSObject+AUUVFLPrivate.h"
#import "AUULayoutAttribute+AUUPrivate.h"

@implementation NSString (AUUVFL)

- (NSString *(^)(CGFloat))interval
{
    return [^(CGFloat interval){
        return [self append:@"%@-(%@)-", self && self.length == 2 ? @"|" : @"", @(interval)];
    } copy];
}

- (NSString *)standardInterval
{
    return [self append:@"-"];
}

- (NSString *(^)(UIView *))nextTo
{
    return [^(UIView *view){
        NSString *releation = view.releation;
        if (releation) {
            NSAssert2(![releation matchWithPattern:@"(?<=\\()@[\\d\\.]+(?=\\))"],
                      @"设置优先级错误，在设置优先级的同时必须设定相关联的最小宽高，请使用lengthIs或者lengthEqual添加 view:%@, releation:%@", view, releation);
        }
        
        self.base = view.superview;
        NSString *res =  [self append:@"[%@%@]", [view hashKey], releation ?: @""];
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
    // 遍历所有的视图并做判断
    for (NSString *hk in [self matchesWithPattern:@"(?<=\\[)[\\w\\d]*?(?=[\\(\\]])"]) {
        NSAssert2([[self.base.layoutKits allKeys] containsObject:hk], @"\n要布局的视图在视图字典中没有保存\nvfl:%@\ndict:%@", self, self.base.layoutKits);
    }
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
