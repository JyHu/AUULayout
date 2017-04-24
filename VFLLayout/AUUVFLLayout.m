//
//  AUUVFLLayout.m
//  AUULayout
//
//  Created by JyHu on 2017/3/31.
//  Copyright © 2017年 JyHu. All rights reserved.
//

#import "AUUVFLLayout.h"
#import <objc/runtime.h>

@implementation NSString (__AUUPrivate)

/**
 判断是否满足这个正则表达式

 @param pattern 正则表达式
 @return 是否满足条件
 */
- (BOOL)isLegalStringWithPattern:(NSString *)pattern {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern] evaluateWithObject:self];
}

/**
 判断是否满足其中的某个正则表达式

 @param patterns 正则表达式列表
 @return 是否满足条件
 */
- (BOOL)isLegalStringWithPatterns:(NSArray *)patterns {
    for (NSString *pattern in patterns) {
        if ([self isLegalStringWithPattern:pattern]) {
            return YES;
        }
    }
    return NO;
}

/**
 判断是否满足所有这些正则表达式

 @param patterns 正则表达式列表
 @return 是否满足条件
 */
- (BOOL)isLegalStringAllMatchPatterns:(NSArray *)patterns {
    for (NSString *pattern in patterns) {
        if (![self isLegalStringWithPattern:pattern]) {
            return NO;
        }
    }
    return YES;
}
/**
 使用正则匹配来查找字符串中有多少个匹配的内容

 @param pattern 用来匹配的正则表达式
 @return 匹配到的个数
 */
- (NSUInteger)numberOfMatchesWithPattern:(NSString *)pattern {
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)].count;
}
@end

@interface NSArray (__AUUPrivate)
@end
@implementation NSArray (__AUUPrivate)

/**
 操作数组中的所有元素，并重新返回一个数组

 @param map 数据转换的block
 @param cls 要判断的数据类型，如果为nil，则所有的数据类型都可进行操作
 @return 转换后的数组
 */
- (NSArray *)map:(id (^)(id obj, NSUInteger index))map checkClass:(Class)cls
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    if (self && self.count > 0) {
        for (NSUInteger i = 0; i < self.count; i ++) {
            id cur = self[i];
            if (!cls || (cls && [cur isKindOfClass:cls])) {
                id temp = map(cur, i);
                if (temp) {
                    [results addObject:temp];
                }
            }
        }
    }
    return results;
}
@end

@implementation AUUVFLLayout
@end

@interface AUUVFLLayoutConstrants()

/**
 VFL语句中相关的视图，在主VFL中表示的是容器视图，在子VFL中表示的是当前要设置宽高属性的视图
 */
@property (weak, nonatomic) UIView *sponsorView;

/**
 VFL语句，在主VFL中表示的是当前的完整的VFL语句，在子VFL中表示的是当前要设置的视图的宽高属性
 */
@property (retain, nonatomic) NSMutableString *pri_VFLString;

/**
 VFL语句中保存视图的字典
 */
@property (retain, nonatomic) NSMutableDictionary *layoutKits;

/**
 缓存视图到字典中
 
 @param view 要缓存的视图
 @return 为视图生成的HashKey
 */
- (NSString *)cacheView:(UIView *)view;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation AUUVFLLayoutConstrants

- (NSMutableDictionary *)layoutKits {
    if (!_layoutKits) {
        _layoutKits = [[NSMutableDictionary alloc] init];
    }
    return _layoutKits;
}

/**
 缓存视图到字典

 @param view 要缓存的视图
 @return 为这个视图生成的唯一的key
 */
- (NSString *)cacheView:(UIView *)view {
    if (view.superview && [view.superview isKindOfClass:[UIView class]]) {
        // viewcontroller的view不可以设置这个属性，否则会出问题
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSString *key = [NSString stringWithFormat:@"com_AUU_vfl_%@%@", NSStringFromClass([view class]), @([view hash])];
    [self.layoutKits setObject:view forKey:key];
    return key;
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    return self[@(idx)];
}

@end

#pragma clang diagnostic pop

@implementation AUUSubVFLConstraints

NSString *priority(CGFloat width, CGFloat priority) {
    return [NSString stringWithFormat:@"(%@@%@)", @(width), @(priority)];
}

NSString *between(CGFloat minLength, CGFloat maxLength) {
    return [NSString stringWithFormat:@"(>=%@,<=%@)", @(minLength), @(maxLength)];
}

NSString *greaterThan(CGFloat length) {
    return [NSString stringWithFormat:@"(>=%@)", @(length)];
}

NSString *lessThan(CGFloat length) {
    return [NSString stringWithFormat:@"(<=%@)", @(length)];
}

- (instancetype)objectForKeyedSubscript:(id)key {
    if ([key isKindOfClass:[NSNumber class]]) {
        // 设置宽高属性为具体的值
        self.pri_VFLString = (NSMutableString *)[NSString stringWithFormat:@"(%@)", key];
    } else if ([key isKindOfClass:[UIView class]]) {
        // 设置与某视图宽高相等
        self.pri_VFLString = (NSMutableString *)[NSString stringWithFormat:@"(%@)", [self cacheView:key]];
    } else if ([key isKindOfClass:[NSString class]] && [key numberOfMatchesWithPattern:@"\\."] <= 1) {
        // 设置宽高的属性
        BOOL isLeagalSubVFL = [key isLegalStringWithPatterns:@[@"^\\([\\d\\.]+\\)$",              // (34.87)
                                                         @"^\\([<>]=[\\d\\.]+,[<>]=[\\d\\.]+\\)$",  // (>=34,<=98)
                                                         @"^\\([\\d\\.]+@[\\d\\.]+\\)$",    // (24@43)
                                                         @"^\\(>=[\\d\\.]+\\)$",            // (>=79)
                                                         @"^\\(<=[\\d\\.]+\\)$"]];          // (<=24)
        NSAssert2(isLeagalSubVFL, @"当前子VFL(%@)没有设置有效的宽高属性，相关的视图:%@", key, self.sponsorView);
        self.pri_VFLString = key;
    }
    return self;
}

@end

@implementation AUUVFLConstraints

- (AUUVFLConstraints *)resetWithDirection:(AUUVFLLayoutDirection)direction {
    // vfl的开始
    if (direction == AUUVFLLayoutDirectionHorizontal) {
        self.pri_VFLString = [@"H:" mutableCopy];
    } else {
        self.pri_VFLString = [@"V:" mutableCopy];
    }
    return self;
}

- (NSString *(^)())end {
    return [^(){
        // 以父视图的末尾结束当前的vfl语句
        [self.pri_VFLString appendString:@"|"];
        return self.cut();
    } copy];;
}

- (NSString *(^)())cut {
    return [^(){
        // 结束VFL语句，并设置到具体的视图上
        [self.sponsorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:self.pri_VFLString options:NSLayoutFormatDirectionMask metrics:nil views:self.layoutKits]];
#ifdef DEBUG
        NSLog(@"VFL %@", self.pri_VFLString);
#endif
        return self.pri_VFLString;
    } copy];
}

- (instancetype)objectForKeyedSubscript:(id)key {
    if ([key isKindOfClass:[NSNumber class]] ||
        ([key isKindOfClass:[NSString class]] && [key numberOfMatchesWithPattern:@"\\."] <= 1 &&
         [key isLegalStringWithPatterns:@[@"^\\([0-9][0-9\\.]*\\)$", @"^\\(>=[0-9][0-9\\.]*\\)$", @"^\\(<=[0-9][0-9\\.]*\\)$"]])) {
            // 设置两个视图的间距
        [self.pri_VFLString appendFormat:@"%@-%@-", (self.pri_VFLString && self.pri_VFLString.length == 2 ? @"|" : @""), key];
    } else {
        if ([key isKindOfClass:[UIView class]]) {
            // 设置相邻的视图
            [self.pri_VFLString appendFormat:@"[%@]", [self cacheView:key]];
        } else if ([key isKindOfClass:[AUUSubVFLConstraints class]]) {
            // 设置相邻视图，和相邻视图其宽高属性的子VFL语句
            AUUSubVFLConstraints *subConstrants = (AUUSubVFLConstraints *)key;
            [self.layoutKits addEntriesFromDictionary:subConstrants.layoutKits];
            [self.pri_VFLString appendFormat:@"[%@%@]", [self cacheView:subConstrants.sponsorView], subConstrants.pri_VFLString];
        }
        
    }

    return self;
}

- (NSString *)cacheView:(UIView *)view {
    if (view.superview && [view.superview isKindOfClass:[UIView class]]) {
        // 当前VFL语句操作的父视图
        self.sponsorView = view.superview;
    }
    return [super cacheView:view];
}

@end

@implementation UIView (AUUVFLSpace)

const char *__kSubVFLAssociatedKey = (void *)@"com.AUU.vfl.__kSubVFLAssociatedKey";

- (AUUSubVFLConstraints *)VFL {
    AUUSubVFLConstraints *VFLConstrants = objc_getAssociatedObject(self, __kSubVFLAssociatedKey);
    if (!VFLConstrants) {
        VFLConstrants = [[AUUSubVFLConstraints alloc] init];
        objc_setAssociatedObject(self, __kSubVFLAssociatedKey, VFLConstrants, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    VFLConstrants.sponsorView = self;
    return VFLConstrants;
}

#if kUseVFLSubscriptLayout
// 将`UIView`的下标法做的操作转到其命名空间下实现
- (id)objectForKeyedSubscript:(id)key {
    return self.VFL[key];
}
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.VFL[idx];
}
#endif

@end

@implementation UIView (AUUVFLLayout)
// 设置视图在父视图上距离上下左右的位置
- (NSArray *(^)(UIEdgeInsets))edge {
    return [^(UIEdgeInsets insets){
        return @[H[@(insets.left)][self][@(insets.right)].end(),
                 V[@(insets.top)][self][@(insets.bottom)].end()];
    } copy];
}
// 设置为指定的大小
- (NSArray *(^)(CGFloat, CGFloat))fixedSize {
    return [^(CGFloat width, CGFloat height){
        return @[H[self.VFL[@(width)]].cut(),
                 V[self.VFL[@(height)]].cut()];
    } copy];
}

@end

@interface AUUGroupVFLConstrants ()
/**
 要批量操作的对象数组
 */
@property (retain, nonatomic) NSArray *layoutObjects;
@end
@implementation AUUGroupVFLConstrants

- (instancetype)objectForKeyedSubscript:(id)key {
    if (self.layoutObjects) {
        if ([key isKindOfClass:[NSArray class]]) {
            // 如果是数组，则需要一个个的对应着去设定
            if ([key count] > 0) {
                self.layoutObjects = [self.layoutObjects map:^id(id obj, NSUInteger index) {
                    return [[self.layoutObjects objectAtIndex:index] objectForKeyedSubscript:(index < [key count] ? key[index] : [key lastObject])];
                } checkClass:nil];
            }
        } else if ([key isKindOfClass:[AUUGroupVFLConstrants class]]) {
            // 如果是 AUUGroupVFLConstrants 类型，则说明是子vfl中的批量设定，需要返回设定的结果列表，然后一一匹配
            return self[((AUUGroupVFLConstrants *)key).layoutObjects];
        } else {
            // 如果是其他类型的话，比如字符串、数值对象、视图等，需要遍历着去操作
            self.layoutObjects = [self.layoutObjects map:^id(AUUVFLLayoutConstrants *obj, NSUInteger index) {
                return obj[key];
            } checkClass:nil];
        }
    }
    return self;
}

- (NSArray *(^)())end {
    return [^(void){
        return [self.layoutObjects map:^id(AUUVFLConstraints *obj, NSUInteger index) {
            // 调用 AUUVFLConstraints 的end属性一个个的去结束vfl语句并设定
            return obj.end();
        } checkClass:[AUUVFLConstraints class]];
    } copy];
}

- (NSArray *(^)())cut {
    return [^(void){
        return [self.layoutObjects map:^id(AUUVFLConstraints *obj, NSUInteger index) {
            // 调用 AUUVFLConstraints 的cut属性一个个的去结束vfl语句并设定
            return obj.cut();
        } checkClass:[AUUVFLConstraints class]];
    } copy];
}

@end

@implementation NSArray (AUUVFLSpace)
const char *__kGroupVFLAssociatedKey = (void *)@"com.AUU.__kGroupVFLAssociatedKey";
- (AUUGroupVFLConstrants *)VFL {
    AUUGroupVFLConstrants *groupConstrants = objc_getAssociatedObject(self, __kGroupVFLAssociatedKey);
    if (!groupConstrants) {
        groupConstrants = [[AUUGroupVFLConstrants alloc] init];
        objc_setAssociatedObject(self, __kGroupVFLAssociatedKey, groupConstrants, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    groupConstrants.layoutObjects = self;
    return groupConstrants;
}

@end
