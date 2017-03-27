//
//  AUUVFLLayout.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import "AUUVFLLayout.h"
#import <objc/runtime.h>

@implementation NSString (__AUUPrivate)
- (BOOL)isLegalObjectWithPattern:(NSString *)pattern {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern] evaluateWithObject:self];
}
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

@implementation AUUVFLLayoutConstrants

- (NSMutableDictionary *)layoutKits {
    if (!_layoutKits) {
        _layoutKits = [[NSMutableDictionary alloc] init];
    }
    return _layoutKits;
}

- (NSString *)cacheView:(UIView *)view {
    if (view.superview && [view.superview isKindOfClass:[UIView class]]) {
        // viewcontroller的view不可以设置这个属性，否则会出问题
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSString *key = [NSString stringWithFormat:@"com_auu_vfl_%@%@", NSStringFromClass([view class]), @([view hash])];
    [self.layoutKits setObject:view forKey:key];
    return key;
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    return self[@(idx)];
}

@end

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
        self.pri_VFLString = [NSString stringWithFormat:@"(%@)", key];
    } else if ([key isKindOfClass:[UIView class]]) {
        self.pri_VFLString = [NSString stringWithFormat:@"(%@)", [self cacheView:key]];
    } else if ([key isKindOfClass:[NSString class]]) {
        BOOL isNormalLength = [key isLegalObjectWithPattern:@"^\\([\\d\\.]+\\)$"];
        BOOL isBetweenLength = [key isLegalObjectWithPattern:@"^\\([<>]=[\\d\\.]+,[<>]=[\\d\\.]+\\)$"];
        BOOL isPriorityLength = [key isLegalObjectWithPattern:@"^\\([\\d\\.]+@[\\d\\.]+\\)$"];
        BOOL isGreaterLength = [key isLegalObjectWithPattern:@"^\\(>=[\\d\\.]+\\)$"];
        BOOL isLessLength = [key isLegalObjectWithPattern:@"^\\(<=[\\d\\.]+\\)$"];
        NSAssert2(isNormalLength || isBetweenLength || isPriorityLength || isGreaterLength || isLessLength, @"当前子VFL(%@)没有设置有效的宽高属性，相关的视图:%@", key, self.sponsorView);
        self.pri_VFLString = key;
    }
    return self;
}

@end

@implementation AUUVFLConstraints

- (AUUVFLConstraints *)resetWithDirection:(AUUVFLLayoutDirection)direction {
    if (direction == AUUVFLLayoutDirectionHorizontal) {
        self.pri_VFLString = [@"H:" mutableCopy];
    } else {
        self.pri_VFLString = [@"V:" mutableCopy];
    }
    return self;
}

- (NSString *(^)())end {
    return [^(){
        [self.pri_VFLString appendString:@"|"];
        return self.endL();
    } copy];;
}

- (NSString *(^)())endL {
    return [^(){
        [self.sponsorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:self.pri_VFLString options:NSLayoutFormatDirectionMask metrics:nil views:self.layoutKits]];
        return self.pri_VFLString;
    } copy];
}

- (instancetype)objectForKeyedSubscript:(id)key {
    if ([key isKindOfClass:[NSNumber class]]) {
        [self.pri_VFLString appendFormat:@"%@-%@-", (self.pri_VFLString && self.pri_VFLString.length == 2 ? @"|" : @""), key];
    } else {
        if ([key isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)key;
            [self.pri_VFLString appendFormat:@"[%@]", [self cacheView:key]];
        } else if ([key isKindOfClass:[AUUSubVFLConstraints class]]) {
            AUUSubVFLConstraints *subConstrants = (AUUSubVFLConstraints *)key;
            [self.layoutKits addEntriesFromDictionary:subConstrants.layoutKits];
            [self.pri_VFLString appendFormat:@"[%@%@]", [self cacheView:subConstrants.sponsorView], subConstrants.pri_VFLString];
        }
    }
    
    return self;
}

- (NSString *)cacheView:(UIView *)view {
    if (view.superview && [view.superview isKindOfClass:[UIView class]]) {
        self.sponsorView = view.superview;
    }
    return [super cacheView:view];
}

@end

@implementation UIView (AUUVFLSpace)

const char *__kSubVFLAssociatedKey = (void *)@"com.auu.vfl.__kSubVFLAssociatedKey";

- (void)setVFL:(AUUSubVFLConstraints *)VFL {
    objc_setAssociatedObject(self, __kSubVFLAssociatedKey, VFL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AUUSubVFLConstraints *)VFL {
    AUUSubVFLConstraints *VFLConstrants = objc_getAssociatedObject(self, __kSubVFLAssociatedKey);
    if (!VFLConstrants) {
        VFLConstrants = [[AUUSubVFLConstraints alloc] init];
        self.VFL = VFLConstrants;
    }
    VFLConstrants.sponsorView = self;
    return VFLConstrants;
}

@end

@implementation UIView (AUUVFLLayout)

- (NSArray *(^)(UIEdgeInsets))edge {
    return [^(UIEdgeInsets insets){
        return @[H[@(insets.left)][self][@(insets.right)].end(),
                 V[@(insets.top)][self][@(insets.bottom)].end()];
    } copy];
}

- (UIView *(^)(CGFloat, CGFloat))fixedSize {
    return [^(CGFloat width, CGFloat height){
        H[self.VFL[@(width)]].endL();
        V[self.VFL[@(height)]].endL();
        return self;
    } copy];
}

@end




