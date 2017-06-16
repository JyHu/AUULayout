//
//  AUUEdgeLayout.m
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import "AUUEdgeLayout.h"
#import <objc/runtime.h>
#import "_AUULayoutAssistant.h"
#import "AUULayoutAssistant.h"


@interface AUUEdgeLayout ()
@property (weak, nonatomic) UIView *pri_bindingView;                    // 缓存关联视图
@property (assign, nonatomic) NSLayoutAttribute pri_layoutAttribute;    // 缓存约束属性
@end

@implementation AUUEdgeLayout

- (UIView *)bindingView {
    return self.pri_bindingView;
}

@end

@interface AUUPassivelyParam ()
@property (assign, nonatomic) CGFloat pri_multiple;
@property (assign, nonatomic) CGFloat pri_offset;
@end

@implementation AUUPassivelyParam

- (instancetype)init {
    if (self = [super init]) {
        self.pri_multiple = 1.0;
        self.pri_offset = 0.0;
    }
    return self;
}

- (AUUPassivelyParam *(^)(CGFloat))offset {
    return [^(CGFloat offset){
        self.pri_offset = offset;
        return self;
    } copy];
}

- (AUUPassivelyParam *(^)(CGFloat))multiple {
    return [^(CGFloat multiple){
        self.pri_multiple = multiple;
        return self;
    } copy];
}

@end

@implementation AUUSponsorParam

#define __CacheSponsorAttribute__(param, attr)      \
            - (AUUSponsorParam *)param {            \
                self.pri_layoutAttribute = attr;    \
                return self;                        \
            }

__CacheSponsorAttribute__(top,          NSLayoutAttributeTop)
__CacheSponsorAttribute__(left,         NSLayoutAttributeLeft)
__CacheSponsorAttribute__(bottom,       NSLayoutAttributeBottom)
__CacheSponsorAttribute__(right,        NSLayoutAttributeRight)
__CacheSponsorAttribute__(centerX,      NSLayoutAttributeCenterX)
__CacheSponsorAttribute__(centerY,      NSLayoutAttributeCenterY)
__CacheSponsorAttribute__(leading,      NSLayoutAttributeLeading)
__CacheSponsorAttribute__(trailing,     NSLayoutAttributeTrailing)
__CacheSponsorAttribute__(width,        NSLayoutAttributeWidth)
__CacheSponsorAttribute__(height,       NSLayoutAttributeHeight)
__CacheSponsorAttribute__(lastBaseline,     NSLayoutAttributeLastBaseline)
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
__CacheSponsorAttribute__(firstBaseline,    NSLayoutAttributeFirstBaseline)
#endif

#define __RelationSetting__(param, relation)                                                    \
            - (AUUSponsorParam *(^)(id))param {                                                 \
                return [^(id element){                                                          \
                    return [self layoutConstrantWithRelation:relation releatedItem:element];    \
                } copy];                                                                        \
            }

__RelationSetting__(equal, NSLayoutRelationEqual)
__RelationSetting__(greaterThan, NSLayoutRelationGreaterThanOrEqual)
__RelationSetting__(lessThan, NSLayoutRelationLessThanOrEqual)

- (AUUEdgeLayout *)layoutConstrantWithRelation:(NSLayoutRelation)relation releatedItem:(id)item {
    NSAssert1(self.pri_bindingView.superview, @"当前视图[%@]还没有添加到父视图上，请在添加约束前添加到你需要的父视图上", self.pri_bindingView);
    
    self.pri_bindingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *layoutConstrant = [self constrantWithRelation:relation releatedItem:item];

    if (layoutConstrant) {
        for (NSLayoutConstraint *oldLayoutConstrant in self.pri_bindingView.superview.constraints) {
            // 如果两个约束类似的话，就报错
            if ([oldLayoutConstrant similarTo:layoutConstrant] && oldLayoutConstrant.active) {
                [self.pri_bindingView hierarchyLog];
                if (self.pri_bindingView.superview.repetitionLayoutConstrantsReporter) {
                    oldLayoutConstrant.active = self.pri_bindingView.superview.repetitionLayoutConstrantsReporter(self.pri_bindingView, oldLayoutConstrant);
                } else if ([AUUGlobalDataStorage sharedStorage].needAutoCoverRepetitionLayoutConstrants) {
                    oldLayoutConstrant.active = NO;
                }
                if ([AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter) {
                    [AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter(oldLayoutConstrant, layoutConstrant);
                }
            }
        }
        
        [self.pri_bindingView.superview addConstraint:layoutConstrant];
    }
    
    return self;
}

- (NSLayoutConstraint *)constrantWithRelation:(NSLayoutRelation)relation releatedItem:(id)item
{
    if ([item isKindOfClass:[UIView class]]) {
        NSAssert(((UIView *)item).nextResponder, @"当前视图没有父视图");
        return [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_layoutAttribute
                                            relatedBy:relation toItem:item attribute:self.pri_layoutAttribute multiplier:1 constant:0];
    } else if ([item isKindOfClass:[NSNumber class]]) {
        return [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_layoutAttribute
                                            relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                           multiplier:1 constant:[item doubleValue]];
    } else if ([item isKindOfClass:[AUUPassivelyParam class]]) {
        AUUPassivelyParam *param = (AUUPassivelyParam *)item;
        return [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_layoutAttribute
                                            relatedBy:relation toItem:param.pri_bindingView attribute:param.pri_layoutAttribute
                                           multiplier:param.pri_multiple constant:param.pri_offset];
    }
    
    return nil;
}

@end

@implementation UIView (AUUSponsorParam)
- (AUUSponsorParam *)auu_layout {
    AUUSponsorParam *edgeLayout = [[AUUSponsorParam alloc] init];
    edgeLayout.pri_bindingView = self;
    return edgeLayout;
}
@end

@implementation AUUSponsorParam (AUUEdgeLayout)

#define __SponsorParamSetting__(attr)                       \
            - (AUUSponsorParam *(^)(id))attr##Equal {       \
                return [^(id element){                      \
                    return self.attr.equal(element);        \
                } copy];                                    \
            }

__SponsorParamSetting__(top)
__SponsorParamSetting__(left)
__SponsorParamSetting__(bottom)
__SponsorParamSetting__(right)
__SponsorParamSetting__(leading)
__SponsorParamSetting__(trailing)
__SponsorParamSetting__(centerX)
__SponsorParamSetting__(centerY)
__SponsorParamSetting__(width)
__SponsorParamSetting__(height)
__SponsorParamSetting__(lastBaseline)
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
__SponsorParamSetting__(firstBaseline)
#endif

- (AUUSponsorParam *(^)(id))sizeEqual {
    return [^(id element){
        if ([element isKindOfClass:[UIView class]]) {
            return self.widthEqual(element).heightEqual(element);
        } else if ([element isKindOfClass:[NSValue class]]) {
            CGSize size = [element CGSizeValue];
            return self.widthEqual(@(size.width)).heightEqual(@(size.height));
        }
        NSAssert(0, @"传递了一个错误的参数");
        return [AUUSponsorParam new];
    }copy];
}

- (AUUSponsorParam *(^)(id))centerEqual {
    return [^(id element) {
        if ([element isKindOfClass:[UIView class]]) {
            return self.centerXEqual(element).centerYEqual(element);
        } else if ([element isKindOfClass:[NSValue class]]) {
            CGPoint center = [element CGPointValue];
            return self.centerXEqual(@(center.x)).centerYEqual(@(center.y));
        }
        NSAssert(0, @"传递了一个错误的参数");
        return [AUUSponsorParam new];
    } copy];
}

- (AUUSponsorParam *(^)(UIEdgeInsets))edgeEqual {
    return [^(UIEdgeInsets insets) {
        return  self.topEqual(   @(insets.top))
                    .leftEqual(  @(insets.left))
                    .bottomEqual(@(insets.bottom))
                    .rightEqual( @(insets.right));
    } copy];
}

@end

@implementation UIView (AUUPassivelyParam)

#define __PassivelyParamWithAttribute__(param, attr)                            \
            - (AUUPassivelyParam *)auu_##param {                                \
                AUUPassivelyParam *param = [[AUUPassivelyParam alloc] init];    \
                param.pri_bindingView = self;                                   \
                param.pri_layoutAttribute = attr;                               \
                return param;                                                   \
            }

__PassivelyParamWithAttribute__(top,        NSLayoutAttributeTop)
__PassivelyParamWithAttribute__(left,       NSLayoutAttributeLeft)
__PassivelyParamWithAttribute__(bottom,     NSLayoutAttributeBottom)
__PassivelyParamWithAttribute__(right,      NSLayoutAttributeRight)
__PassivelyParamWithAttribute__(centerX,    NSLayoutAttributeCenterX)
__PassivelyParamWithAttribute__(centerY,    NSLayoutAttributeCenterY);
__PassivelyParamWithAttribute__(leading,    NSLayoutAttributeLeading)
__PassivelyParamWithAttribute__(trailing,   NSLayoutAttributeTrailing)
__PassivelyParamWithAttribute__(width,      NSLayoutAttributeWidth)
__PassivelyParamWithAttribute__(height,     NSLayoutAttributeHeight)
__PassivelyParamWithAttribute__(lastBaseline,   NSLayoutAttributeLastBaseline)
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
__PassivelyParamWithAttribute__(firstBaseline,  NSLayoutAttributeFirstBaseline)
#endif

@end

