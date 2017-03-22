//
//  AUULayoutAttribute+AUUPrivate.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import "AUULayoutAttribute+AUUPrivate.h"
#import <objc/runtime.h>

@implementation AUULayoutAttribute (AUUPrivate)


+ (instancetype)layoutAttributeWithView:(UIView *)view attribute:(NSLayoutAttribute)layoutAttribute {
    AUULayoutAttribute *attribute = [[AUULayoutAttribute alloc] init];
    attribute.secondView = view;
    attribute.secondlayoutAttribute = layoutAttribute;
    attribute.multiplier = 1.0f;
    attribute.margin = 0.0f;
    return attribute;
}

const char *kFirstViewAssociatedKey = (void *)@"kFirstViewAssociatedKey";
- (void)setFirstView:(UIView *)firstView {
    objc_setAssociatedObject(self, kFirstViewAssociatedKey, firstView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)firstView {
    return objc_getAssociatedObject(self, kFirstViewAssociatedKey);
}

const char *kSecondViewAssociatedKey = (void *)@"kSecondViewAssociatedKey";
- (void)setSecondView:(UIView *)secondView {
    objc_setAssociatedObject(self, kSecondViewAssociatedKey, secondView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)secondView {
    return objc_getAssociatedObject(self, kSecondViewAssociatedKey);
}

const char *kSecondLayoutAttributeAssociatedKey = (void *)@"kSecondLayoutAttributeAssociatedKey";
- (void)setSecondlayoutAttribute:(NSLayoutAttribute)secondlayoutAttribute {
    objc_setAssociatedObject(self, kSecondLayoutAttributeAssociatedKey, @(secondlayoutAttribute), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSLayoutAttribute)secondlayoutAttribute {
    id obj = objc_getAssociatedObject(self, kSecondLayoutAttributeAssociatedKey);
    return obj ? (NSLayoutAttribute)[obj integerValue] : 0;
}

const char *kFirstLayoutAttributeAssociatedKey = (void *)@"kFirstLayoutAttributeAssociatedKey";
- (void)setFirstLayoutAttribute:(NSLayoutAttribute)firstLayoutAttribute {
    objc_setAssociatedObject(self, kFirstLayoutAttributeAssociatedKey, @(firstLayoutAttribute), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSLayoutAttribute)firstLayoutAttribute {
    id obj = objc_getAssociatedObject(self, kFirstLayoutAttributeAssociatedKey);
    return obj ? [obj integerValue] : 0;
}

const char *kMarginAssociatedKey = (void *)@"kMarginAssociatedKey";
- (void)setMargin:(CGFloat)margin {
    objc_setAssociatedObject(self, kMarginAssociatedKey, @(margin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)margin {
    id obj = objc_getAssociatedObject(self, kMarginAssociatedKey);
    return obj ? [obj floatValue] : 0;
}

const char *kMultiplierAssociatedKey = (void *)@"kMultiplierAssociatedKey";
- (void)setMultiplier:(CGFloat)multiplier {
    objc_setAssociatedObject(self, kMultiplierAssociatedKey, @(multiplier), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)multiplier {
    id obj = objc_getAssociatedObject(self, kMultiplierAssociatedKey);
    return obj ? [obj floatValue] : 1.0;
}

@end
