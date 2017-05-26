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
@property (weak, nonatomic) UIView *pri_bindingView;
@property (assign, nonatomic) NSLayoutAttribute pri_layoutAttribute;
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

#define __CacheSponsorAttribute__(attribute)        \
            self.pri_layoutAttribute = attribute;   \
            return self;

- (AUUSponsorParam *)top {
    __CacheSponsorAttribute__(NSLayoutAttributeTop)
}

- (AUUSponsorParam *)left {
    __CacheSponsorAttribute__(NSLayoutAttributeLeft)
}

- (AUUSponsorParam *)bottom {
    __CacheSponsorAttribute__(NSLayoutAttributeBottom)
}

- (AUUSponsorParam *)right {
    __CacheSponsorAttribute__(NSLayoutAttributeRight)
}

- (AUUSponsorParam *)centerX {
    __CacheSponsorAttribute__(NSLayoutAttributeCenterX)
}

- (AUUSponsorParam *)centerY {
    __CacheSponsorAttribute__(NSLayoutAttributeCenterY)
}

- (AUUSponsorParam *)leading {
    __CacheSponsorAttribute__(NSLayoutAttributeLeading)
}

- (AUUSponsorParam *)trailing {
    __CacheSponsorAttribute__(NSLayoutAttributeTrailing)
}

- (AUUSponsorParam *)width {
    __CacheSponsorAttribute__(NSLayoutAttributeWidth)
}

- (AUUSponsorParam *)height {
    __CacheSponsorAttribute__(NSLayoutAttributeHeight)
}

- (AUUSponsorParam *)lastBaseLine {
    __CacheSponsorAttribute__(NSLayoutAttributeLastBaseline)
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
- (AUUSponsorParam *)firstBaseLine {
    __CacheSponsorAttribute__(NSLayoutAttributeFirstBaseline)
}
#endif

- (AUUSponsorParam *(^)(id))equal {
    return [^(id element){                                                          \
        return [self layoutConstrantWithRelation:NSLayoutRelationEqual releatedItem:element];    \
    } copy];
}

- (AUUSponsorParam *(^)(id))greaterThan {
    return [^(id element){                                                          \
        return [self layoutConstrantWithRelation:NSLayoutRelationGreaterThanOrEqual releatedItem:element];    \
    } copy];
}

- (AUUSponsorParam *(^)(id))lessThan {
    return [^(id element){                                                          \
        return [self layoutConstrantWithRelation:NSLayoutRelationLessThanOrEqual releatedItem:element];    \
    } copy];
}

- (AUUEdgeLayout *)layoutConstrantWithRelation:(NSLayoutRelation)relation releatedItem:(id)item {
    NSAssert1(self.pri_bindingView.superview, @"当前视图[%@]还没有添加到父视图上，请在添加约束前添加到你需要的父视图上", self.pri_bindingView);
    
    self.pri_bindingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *layoutConstrant = nil;
    
    if ([item isKindOfClass:[UIView class]]) {
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_layoutAttribute
                                                       relatedBy:relation toItem:item attribute:self.pri_layoutAttribute multiplier:1 constant:0];
    } else if ([item isKindOfClass:[NSNumber class]]) {
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_layoutAttribute
                                                       relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1 constant:[item doubleValue]];
    } else if ([item isKindOfClass:[AUUPassivelyParam class]]) {
        AUUPassivelyParam *param = (AUUPassivelyParam *)item;
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_layoutAttribute
                                                       relatedBy:relation toItem:param.pri_bindingView attribute:param.pri_layoutAttribute
                                                      multiplier:param.pri_multiple constant:param.pri_offset];
    } else {
        NSLog(@"错误的信息");
    }
    
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

@end

@implementation AUUSponsorParam (AUUEdgeLayout)

#define __SponsorParamSetting__(attr)       \
            - (AUUSponsorParam *(^)(id))attr##Equal { return [^(id element){ return self.attr.equal(element); } copy]; }

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
__SponsorParamSetting__(lastBaseLine)
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
__SponsorParamSetting__(firstBaseLine)
#endif

- (AUUSponsorParam *(^)(id))sizeEqual {
    return [^(id element){
        if ([element isKindOfClass:[UIView class]]) {
            return self.widthEqual(element).heightEqual(element);
        } else if ([element isKindOfClass:[NSValue class]]) {
            CGSize size = [element CGSizeValue];
            return self.widthEqual(@(size.width)).heightEqual(@(size.height));
        }
        NSAssert(1, @"传递了一个错误的参数");
        return [AUUSponsorParam new];
    }copy];
}

- (AUUSponsorParam *(^)(id))centerEqual {
    return [^(id element) {
        if ([element isKindOfClass:[UIView class]]) {
            return self.centerEqual(element).centerYEqual(element);
        } else if ([element isKindOfClass:[NSValue class]]) {
            CGPoint center = [element CGPointValue];
            return self.centerXEqual(@(center.x)).centerYEqual(@(center.y));
        }
        
        NSAssert(1, @"传递了一个错误的参数");
        return [AUUSponsorParam new];
    } copy];
}

- (AUUSponsorParam *(^)(UIEdgeInsets))edgeEqual {
    return [^(UIEdgeInsets insets) {
        return  self.topEqual(@(insets.top))
                    .leftEqual(@(insets.left))
                    .bottomEqual(@(insets.bottom))
                    .rightEqual(@(insets.right));
    } copy];
}

@end

@implementation UIView (AUUEdgeLayout)

- (AUUSponsorParam *)auu_layout {
    AUUSponsorParam *edgeLayout = [[AUUSponsorParam alloc] init];
    edgeLayout.pri_bindingView = self;
    return edgeLayout;
}

#define __PassivelyParamWithAttribute__(attribute)                          \
            AUUPassivelyParam *param = [[AUUPassivelyParam alloc] init];    \
            param.pri_bindingView = self;                                   \
            param.pri_layoutAttribute = attribute;                          \
            return param;

- (AUUPassivelyParam *)auu_top
{
    __PassivelyParamWithAttribute__(NSLayoutAttributeTop)
}

- (AUUPassivelyParam *)auu_left {
    __PassivelyParamWithAttribute__(NSLayoutAttributeLeft)
}

- (AUUPassivelyParam *)auu_bottom {
    __PassivelyParamWithAttribute__(NSLayoutAttributeBottom)
}

- (AUUPassivelyParam *)auu_right {
    __PassivelyParamWithAttribute__(NSLayoutAttributeRight)
}

- (AUUPassivelyParam *)auu_centerX {
    __PassivelyParamWithAttribute__(NSLayoutAttributeCenterX)
}

- (AUUPassivelyParam *)auu_centerY {
    __PassivelyParamWithAttribute__(NSLayoutAttributeCenterY)
}

- (AUUPassivelyParam *)auu_leading {
    __PassivelyParamWithAttribute__(NSLayoutAttributeLeading)
}

- (AUUPassivelyParam *)auu_trailing {
    __PassivelyParamWithAttribute__(NSLayoutAttributeTrailing)
}

- (AUUPassivelyParam *)auu_width {
    __PassivelyParamWithAttribute__(NSLayoutAttributeWidth)
}

- (AUUPassivelyParam *)auu_height {
    __PassivelyParamWithAttribute__(NSLayoutAttributeHeight)
}

- (AUUPassivelyParam *)auu_lastBaseLine {
    __PassivelyParamWithAttribute__(NSLayoutAttributeLastBaseline)
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
- (AUUPassivelyParam *)auu_firstBaseLine {
    __PassivelyParamWithAttribute__(NSLayoutAttributeFirstBaseline)
}
#endif

@end

#if kUIViewUsePihyLayoutEqual

@implementation UIView (AUUPihyAssistant)

#define __ViewPihyAssistantSetting__(attr)                          \
            - (AUUSponsorParam *(^)(id))attr##Equal { return [^(id element) { return self.auu_layout.attr##Equal(element); } copy]; }

__ViewPihyAssistantSetting__(top)
__ViewPihyAssistantSetting__(left)
__ViewPihyAssistantSetting__(bottom)
__ViewPihyAssistantSetting__(right)
__ViewPihyAssistantSetting__(centerX)
__ViewPihyAssistantSetting__(centerY)
__ViewPihyAssistantSetting__(leading)
__ViewPihyAssistantSetting__(trailing)
__ViewPihyAssistantSetting__(width)
__ViewPihyAssistantSetting__(height)
__ViewPihyAssistantSetting__(size)
__ViewPihyAssistantSetting__(center)
__ViewPihyAssistantSetting__(lastBaseLine)
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
__ViewPihyAssistantSetting__(firstBaseLine)
#endif

- (AUUSponsorParam *(^)(UIEdgeInsets))edgeEqual {
    return [^(UIEdgeInsets insets) {
        return self.auu_layout.edgeEqual(insets);
    } copy];
}

@end

#endif
