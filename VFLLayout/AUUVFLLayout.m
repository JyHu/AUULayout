//
//  AUUVFLLayout.m
//  AUULayout
//
//  Created by JyHu on 2017/3/31.
//  Copyright © 2017年 JyHu. All rights reserved.
//

#import "AUUVFLLayout.h"
#import <objc/runtime.h>
#import "AUULayoutAssistant.h"
#import "_AUULayoutAssistant.h"

@implementation AUUVFLLayout
@end

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 为布局扩展下标法的基类
#pragma mark -
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@interface AUUVFLLayoutConstrants() <NSCopying>

/**
 VFL语句中相关的视图，在主VFL中表示的是容器视图，在子VFL中表示的是当前要设置宽高属性的视图
 */
@property (weak, nonatomic) UIView *pri_sponsorView;

/**
 VFL语句，在主VFL中表示的是当前的完整的VFL语句，在子VFL中表示的是当前要设置的视图的宽高属性
 */
@property (retain, nonatomic) NSMutableString *pri_VFLString;

/**
 VFL语句中保存视图的字典
 */
@property (retain, nonatomic) NSMutableDictionary <NSString *, UIView *> *layoutKits;

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

- (NSMutableDictionary<NSString *,UIView *> *)layoutKits {
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

- (id)copyWithZone:(NSZone *)zone
{
    AUUVFLLayoutConstrants *layoutConstrants = [[[self class] allocWithZone:zone] init];
    layoutConstrants.pri_sponsorView = self.pri_sponsorView;
    layoutConstrants.pri_VFLString = [self.pri_VFLString mutableCopy];
    layoutConstrants.layoutKits = [self.layoutKits mutableCopy];
    return layoutConstrants;
}

@end

#pragma clang diagnostic pop

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 对主VFL语句设置属性的类
#pragma mark -
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        NSArray *currentInstalledConstrants = [NSLayoutConstraint constraintsWithVisualFormat:self.pri_VFLString options:NSLayoutFormatDirectionMask metrics:nil views:self.layoutKits];
#ifdef DEBUG
        BOOL hasAmbiguousLayout = NO;

        for (UIView *view in self.layoutKits.allValues) {
            for (NSLayoutConstraint *oldLayoutConstrant in view.superview.constraints) {
                for (NSLayoutConstraint *newLayoutConstrant in currentInstalledConstrants) {
                    if ([newLayoutConstrant similarTo:oldLayoutConstrant] && oldLayoutConstrant.active) {
                        hasAmbiguousLayout = YES;
                        
                        if (view.superview.repetitionLayoutConstrantsReporter) {
                            oldLayoutConstrant.active = view.superview.repetitionLayoutConstrantsReporter(view, oldLayoutConstrant);
                        } else if ([AUUGlobalDataStorage sharedStorage].needAutoCoverRepetitionLayoutConstrants) {
                            oldLayoutConstrant.active = NO;
                        }
                        
                        if ([AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter) {
                            [AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter(oldLayoutConstrant, newLayoutConstrant);
                        }
                    }
                }
            }
        }
        
        if (hasAmbiguousLayout) {
            [self.pri_sponsorView hierarchyLog];
        }
        
        NSLog(@"VFL %@", self.pri_VFLString);
#endif
        
        [self.pri_sponsorView addConstraints:currentInstalledConstrants];
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
                [self.pri_VFLString appendFormat:@"[%@%@]", [self cacheView:subConstrants.pri_sponsorView], subConstrants.pri_VFLString];
            }
        }
    return self;
}

- (NSString *)cacheView:(UIView *)view {
    if (view.superview && [view.superview isKindOfClass:[UIView class]]) {
        // 当前VFL语句操作的父视图
        self.pri_sponsorView = view.superview;
    }
    NSAssert1(view.nextResponder, @"当前视图[%@]没有被添加到需要的父视图上，无法进行自动布局", view);
    return [super cacheView:view];
}

@end

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 对子视图设置VFL布局的类，及对UIView扩充的一些方法
#pragma mark -
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        if (![key isLegalStringWithPatterns:@[@"^\\([\\d\\.]+\\)$",                     // (34.87)
                                              @"^\\([<>]=[\\d\\.]+,[<>]=[\\d\\.]+\\)$",  // (>=34,<=98)
                                              @"^\\([\\d\\.]+@[\\d\\.]+\\)$",            // (24@43)
                                              @"^\\(>=[\\d\\.]+\\)$",                    // (>=79)
                                              @"^\\(<=[\\d\\.]+\\)$"]]) {                // (<=24)
            NSAssert2(1, @"当前子VFL(%@)没有设置有效的宽高属性，相关的视图:%@", key, self.pri_sponsorView);
        }
        self.pri_VFLString = key;
    }
    return self;
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
    VFLConstrants.pri_sponsorView = self;
    return VFLConstrants;
}

#if kUIViewUseVFLSubscriptLayout
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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 对批量属性操作的类及辅助方法
#pragma mark -
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@interface AUUGroupVFLConstrants ()
/**
 要批量操作的对象数组
 */
@property (retain, nonatomic) NSArray *layoutObjects;
@end
@implementation AUUGroupVFLConstrants

- (instancetype)objectForKeyedSubscript:(id)key {
    if (!self.layoutObjects || self.layoutObjects.count == 0) {
        self.layoutObjects = [key isKindOfClass:[NSArray class]] ? key : @[key];
    } else {
        if ([key isKindOfClass:[NSArray class]]) {
            // 如果是数组，则需要一个个的对应着去设定
            if ([key count] > 0) {
                if ([key count] > self.layoutObjects.count) {
                    // 先暂存一份最后的一个值，避免在block内拼接的时候取了上一个已被拼接的数据
                    id lastObject = [[self.layoutObjects lastObject] copy];
                    self.layoutObjects = [key map:^id(id obj, NSUInteger index) {
                        return [(index < self.layoutObjects.count ? self.layoutObjects[index] : lastObject) objectForKeyedSubscript:key[index]];
                    } checkClass:nil];
                } else {
                    self.layoutObjects = [self.layoutObjects map:^id(id obj, NSUInteger index) {
                        return [[self.layoutObjects objectAtIndex:index] objectForKeyedSubscript:(index < [key count] ? key[index] : [key lastObject])];
                    } checkClass:nil];
                }
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
