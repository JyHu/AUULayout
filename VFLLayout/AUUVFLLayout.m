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

@implementation UIView (__AUUPrivate)

- (NSString *)hashKey {
    return [NSString stringWithFormat:@"com_auu_vfl_%@%@", NSStringFromClass([self class]), @([self hash])];
}

@end


@interface AUUVFLLayoutConstrants()

@property (retain, nonatomic) NSMutableDictionary *layoutKits;

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
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSString *key = [view hashKey];
    [self.layoutKits setObject:view forKey:key];
    return key;
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx {
    return self[@(idx)];
}

@end


NSString *priority(CGFloat width, CGFloat priority) {
    return [NSString stringWithFormat:@"(%@@%@)", @(width), @(priority)];
}

NSString *between(CGFloat minLength, CGFloat maxLength) {
    return [NSString stringWithFormat:@"(>=%@,<=%@)", @(minLength), @(maxLength)];
}

NSString *greaterThan(CGFloat length) {
    return [NSString stringWithFormat:@">=%@", @(length)];
}

@interface AUUSubVFLConstraints ()

@property (weak, nonatomic) UIView *sponsorView;

@property (retain, nonatomic) NSMutableString *relationSubVFL;

@end

@implementation AUUSubVFLConstraints

- (instancetype)objectForKeyedSubscript:(id)key {
    if ([key isKindOfClass:[NSNumber class]]) {
        self.relationSubVFL = [[NSString stringWithFormat:@"(%@)", key] mutableCopy];
    } else if ([key isKindOfClass:[UIView class]]) {
        self.relationSubVFL = [[NSString stringWithFormat:@"(%@)", [self cacheView:key]] mutableCopy];
    } else if ([key isKindOfClass:[NSString class]]) {
        BOOL isNormalLength = [key isLegalObjectWithPattern:@"^\\([\\d\\.]+\\)$"];
        BOOL isBetweenLength = [key isLegalObjectWithPattern:@"^\\(>=[\\d\\.]+,<=[\\d\\.]+\\)$"];
        BOOL isPriorityLength = [key isLegalObjectWithPattern:@"^\\([\\d\\.]+@[\\d\\.]+\\)$"];
        BOOL isGreaterLength = [key isLegalObjectWithPattern:@"^\\(>=[\\d\\.]+\\)$"];
        
        if (isNormalLength || isBetweenLength || isPriorityLength || isGreaterLength) {
            self.relationSubVFL = key;
        } else {
            NSLog(@"设置子视图宽高属性");
        }
        
        if (isNormalLength) {
            NSLog(@"是正常的数值设置");
        } else if (isBetweenLength) {
            NSLog(@"是区间值得设置");
        } else if (isPriorityLength) {
            NSLog(@"是优先级的设置");
        } else if (isGreaterLength) {
            NSLog(@"是最大值的设置");
        }
    }
    
    return self;
}

- (NSMutableString *)relationSubVFL
{
    if (!_relationSubVFL) {
        _relationSubVFL = [[NSMutableString alloc] init];
    }
    return _relationSubVFL;
}

@end



@interface AUUVFLConstraints()

@property (weak, nonatomic) UIView *containerView;

@property (retain, nonatomic) NSMutableString *VFLString;

@end

@implementation AUUVFLConstraints

- (NSString *(^)())end {
    return [^(){
        [self.VFLString appendString:@"|"];
        return self.endL();
    } copy];;
}

- (NSString *(^)())endL {
    return [^(){
        [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:self.VFLString options:NSLayoutFormatDirectionMask metrics:nil views:self.layoutKits]];
        return self.VFLString;
    } copy];
}

- (instancetype)objectForKeyedSubscript:(id)key {
    if ([key isKindOfClass:[NSNumber class]]) {
        [self.VFLString appendFormat:@"%@-%@-", (self.VFLString && self.VFLString.length == 2 ? @"|" : @""), key];
    } else {
        if ([key isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)key;
            [self.VFLString appendFormat:@"[%@]", [self cacheView:key]];
        } else if ([key isKindOfClass:[AUUSubVFLConstraints class]]) {
            AUUSubVFLConstraints *subConstrants = (AUUSubVFLConstraints *)key;
            [self.layoutKits addEntriesFromDictionary:subConstrants.layoutKits];
            [self.VFLString appendFormat:@"[%@%@]", [self cacheView:subConstrants.sponsorView], subConstrants.relationSubVFL];
        }
    }
    
    return self;
}

- (NSString *)cacheView:(UIView *)view {
    if (view.superview && [view.superview isKindOfClass:[UIView class]]) {
        self.containerView = view.superview;
    }
    return [super cacheView:view];
}

@end


NSString *const H = @"H:";
NSString *const V = @"V:";

@implementation NSString (AUUVFLSpace)

const char *__kVFLAssociatedKey = (void *)@"com.auu.vfl.__kVFLAssociatedKey";

- (void)setVFL:(AUUVFLConstraints *)VFL {
    objc_setAssociatedObject(self, __kVFLAssociatedKey, VFL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AUUVFLConstraints *)VFL {
    AUUVFLConstraints *VFLConstrants = objc_getAssociatedObject(self, __kVFLAssociatedKey);
    if (!VFLConstrants) {
        VFLConstrants = [[AUUVFLConstraints alloc] init];
        self.VFL = VFLConstrants;
    }
    
    VFLConstrants.VFLString = [self mutableCopy];
    
    return VFLConstrants;
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
    VFLConstrants.relationSubVFL = [@"" mutableCopy];
    
    return VFLConstrants;
}

@end

@implementation UIView (AUUVFLLayout)

- (NSArray *(^)(UIEdgeInsets))edge {
    return [^(UIEdgeInsets insets){
        return @[H.VFL[@(insets.left)][self][@(insets.right)].end(),
                 V.VFL[@(insets.top)][self][@(insets.bottom)].end()];
    } copy];
}

- (UIView *(^)(CGFloat, CGFloat))fixedSize {
    return [^(CGFloat width, CGFloat height){
        H.VFL[self.VFL[@(width)]].endL();
        V.VFL[self.VFL[@(height)]].endL();
        return self;
    } copy];
}

@end




