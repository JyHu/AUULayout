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

- (UIView *)bindingView
{
    return self.pri_bindingView;
}

@end

@interface AUUPassivelyParam ()

@property (assign, nonatomic) CGFloat pri_multiple;

@property (assign, nonatomic) CGFloat pri_offset;

@end

@implementation AUUPassivelyParam

- (instancetype)init
{
    if (self = [super init]) {
        self.pri_multiple = 1.0;
        self.pri_offset = 0.0;
    }
    return self;
}

+ (AUUPassivelyParam *)paramWithView:(UIView *)view layoutAttribute:(NSLayoutAttribute)attribute
{
    AUUPassivelyParam *param = [[self alloc] init];
    param.pri_bindingView = view;
    param.pri_layoutAttribute = attribute;
    return param;
}

- (AUUPassivelyParam *(^)(CGFloat))offset
{
    return [^(CGFloat offset){
        self.pri_offset = offset;
        return self;
    } copy];
}

- (AUUPassivelyParam *(^)(CGFloat))multiple
{
    return [^(CGFloat multiple){
        self.pri_multiple = multiple;
        return self;
    } copy];
}

@end

@implementation AUUSponsorParam

+ (instancetype)edgeLayoutWithBindingView:(UIView *)view
{
    AUUSponsorParam *edgeLayout = [[self alloc] init];
    edgeLayout.pri_bindingView = view;
    return edgeLayout;
}

- (AUUSponsorParam *)cacheSponsorAttribute:(NSLayoutAttribute)attribute
{
    self.pri_layoutAttribute = attribute;
    return self;
}

- (AUUSponsorParam *)top
{
    return [self cacheSponsorAttribute:NSLayoutAttributeTop];
}

- (AUUSponsorParam *)left
{
    return [self cacheSponsorAttribute:NSLayoutAttributeLeft];
}

- (AUUSponsorParam *)bottom
{
    return [self cacheSponsorAttribute:NSLayoutAttributeBottom];
}

- (AUUSponsorParam *)right
{
    return [self cacheSponsorAttribute:NSLayoutAttributeRight];
}

- (AUUSponsorParam *)centerX
{
    return [self cacheSponsorAttribute:NSLayoutAttributeCenterX];
}

- (AUUSponsorParam *)centerY
{
    return [self cacheSponsorAttribute:NSLayoutAttributeCenterY];
}

- (AUUSponsorParam *)leading
{
    return [self cacheSponsorAttribute:NSLayoutAttributeLeading];
}

- (AUUSponsorParam *)trailing
{
    return [self cacheSponsorAttribute:NSLayoutAttributeTrailing];
}

- (AUUSponsorParam *)width
{
    return [self cacheSponsorAttribute:NSLayoutAttributeWidth];
}

- (AUUSponsorParam *)height
{
    return [self cacheSponsorAttribute:NSLayoutAttributeHeight];
}

- (AUUSponsorParam *)lastBaseLine
{
    return [self cacheSponsorAttribute:NSLayoutAttributeLastBaseline];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
- (AUUSponsorParam *)firstBaseLine
{
    return [self cacheSponsorAttribute:NSLayoutAttributeFirstBaseline];
}
#endif

- (AUUSponsorParam *(^)(id))equal
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationEqual releatedItem:element];
    } copy];
}

- (AUUSponsorParam *(^)(id))greaterThan
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationGreaterThanOrEqual releatedItem:element];
    } copy];
}

- (AUUSponsorParam *(^)(id))lessThan
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationLessThanOrEqual releatedItem:element];
    } copy];
}

- (AUUEdgeLayout *)layoutConstrantWithRelation:(NSLayoutRelation)relation releatedItem:(id)item
{
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

- (AUUSponsorParam *(^)(id))topEqual
{
    return [^(id element){
        return self.top.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))leftEqual
{
    return [^(id element){
        return self.left.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))bottomEqual
{
    return [^(id element){
        return self.bottom.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))rightEqual
{
    return [^(id element){
        return self.right.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))leadingEqual
{
    return [^(id element){
        return self.leading.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))trailingEqual
{
    return [^(id element){
        return self.trailing.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerXEqual
{
    return [^(id element){
        return self.centerX.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerYEqual
{
    return [^(id element){
        return self.centerY.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))widthEqual
{
    return [^(id element){
        return self.width.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))heightEqual
{
    return [^(id element){
        return self.height.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))sizeEqual
{
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

- (AUUSponsorParam *(^)(id))centerEqual
{
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

- (AUUSponsorParam *(^)(UIEdgeInsets))edgeEqual
{
    return [^(UIEdgeInsets insets) {
        return  self.topEqual(@(insets.top))
                    .leftEqual(@(insets.left))
                    .bottomEqual(@(insets.bottom))
                    .rightEqual(@(insets.right));
    } copy];
}

- (AUUSponsorParam *(^)(id))lastBaseLineEqual
{
    return [^(id element){
        return self.lastBaseLine.equal(element);
    } copy];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
- (AUUSponsorParam *(^)(id))firstBaseLineEqual
{
    return [^(id element){
        return self.firstBaseLine.equal(element);
    } copy];
}
#endif

@end

@implementation UIView (AUUEdgeLayout)

- (AUUSponsorParam *)auu_layout
{
    return [AUUSponsorParam edgeLayoutWithBindingView:self];
}

- (AUUPassivelyParam *)auu_top
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (AUUPassivelyParam *)auu_left
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (AUUPassivelyParam *)auu_bottom
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (AUUPassivelyParam *)auu_right
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (AUUPassivelyParam *)auu_centerX
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (AUUPassivelyParam *)auu_centerY
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (AUUPassivelyParam *)auu_leading
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (AUUPassivelyParam *)auu_trailing
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (AUUPassivelyParam *)auu_width
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (AUUPassivelyParam *)auu_height
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (AUUPassivelyParam *)auu_lastBaseLine
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
- (AUUPassivelyParam *)auu_firstBaseLine
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
#endif

@end

#if kUIViewUsePihyLayoutEqual

@implementation UIView (AUUPihyAssistant)

- (AUUSponsorParam *(^)(id))topEqual
{
    return [^(id element) {
        return self.auu_layout.topEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))leftEqual
{
    return [^(id element) {
        return self.auu_layout.leftEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))bottomEqual
{
    return [^(id element) {
        return self.auu_layout.bottomEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))rightEqual
{
    return [^(id element) {
        return self.auu_layout.rightEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerXEqual
{
    return [^(id element) {
        return self.auu_layout.centerXEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerYEqual
{
    return [^(id element) {
        return self.auu_layout.centerYEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))leadingEqual
{
    return [^(id element) {
        return self.auu_layout.leadingEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))trailingEqual
{
    return [^(id element) {
        return self.auu_layout.trailingEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))widthEqual
{
    return [^(id element) {
        return self.auu_layout.widthEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))heightEqual
{
    return [^(id element) {
        return self.auu_layout.heightEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))sizeEqual
{
    return [^(id element) {
        return self.auu_layout.sizeEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerEqual
{
    return [^(id element) {
        return self.auu_layout.centerEqual(element);
    } copy];
}

- (AUUSponsorParam *(^)(UIEdgeInsets))edgeEqual
{
    return [^(UIEdgeInsets insets) {
        return self.auu_layout.edgeEqual(insets);
    } copy];
}

- (AUUSponsorParam *(^)(id))lastBaseLineEqual
{
    return [^(id element) {
        return self.auu_layout.lastBaseLineEqual(element);
    } copy];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000

- (AUUSponsorParam *(^)(id))firstBaseLineEqual
{
    return [^(id element) {
        return self.auu_layout.firstBaseLineEqual(element);
    } copy];
}

#endif

@end

#endif
