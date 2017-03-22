//
//  UIView+AUUVFLEdge.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import "UIView+AUUVFLEdge.h"

@interface AUULayoutAttribute()

@property (weak, nonatomic) UIView *pri_view;

@property (assign, nonatomic) NSLayoutAttribute *pri_layoutAttribute;

@end

@implementation AUULayoutAttribute

+ (instancetype)layoutAttributeWithView:(UIView *)view attribute:(NSLayoutAttribute)layoutAttribute {
    AUULayoutAttribute *attribute = [[AUULayoutAttribute alloc] init];
    attribute.pri_view = view;
    attribute.pri_layoutAttribute = layoutAttribute;
    return attribute;
}

- (UIView *)view {
    return self.pri_view;
}

- (NSLayoutAttribute)layoutAttribute {
    return self.pri_layoutAttribute;
}

@end

@implementation UIView (AUUVFLEdge)

- (AUULayoutAttribute *)u_top {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeTop];
}
- (AUULayoutAttribute *)u_left {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeLeft];
}
- (AUULayoutAttribute *)u_bottom {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeBottom];
}
- (AUULayoutAttribute *)u_right {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeRight];
}
-(AUULayoutAttribute *)u_width {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeWidth];
}
- (AUULayoutAttribute *)u_height {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeHeight];
}
- (AUULayoutAttribute *)u_centerX {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeCenterX];
}
- (AUULayoutAttribute *)u_centerY {
    return [AUULayoutAttribute layoutAttributeWithView:self attribute:NSLayoutAttributeCenterY];
}

@end


@implementation UIView (AUUVFLEdgeEqual)

- (UIView *(^)(AUULayoutAttribute *))topEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        return self.topMarginEqual(layoutAttribute, 0);
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))leftEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        return self.leftMarginEqual(layoutAttribute, 0);
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))bottomEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        return self.bottomMarginEqual(layoutAttribute, 0);
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))rightEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        return self.rightMarginEqual(layoutAttribute, 0);
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))centerXEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        return self.centerXMarginEqual(layoutAttribute, 0);
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))centerYEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        return self.centerYMarginEqual(layoutAttribute, 0);
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *, CGFloat))topMarginEqual
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat margin){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.view attribute:layoutAttribute.layoutAttribute multiplier:1 constant:margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *, CGFloat))leftMarginEqual
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat margin){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.view attribute:layoutAttribute.layoutAttribute multiplier:1 constant:margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *, CGFloat))bottomMarginEqual
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat margin){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.view attribute:layoutAttribute.layoutAttribute multiplier:1 constant:margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *, CGFloat))rightMarginEqual
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat margin){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.view attribute:layoutAttribute.layoutAttribute multiplier:1 constant:margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))centerXMarginEqual
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat margin){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.view attribute:layoutAttribute.layoutAttribute multiplier:1 constant:margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *, CGFloat))centerYMarginEqual
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat margin){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.view attribute:layoutAttribute.layoutAttribute multiplier:1 constant:margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *, CGFloat))topMultiplierTo
{
    return [^(AUULayoutAttribute *layoutAttribute, CGFloat multiplier) {
        return self;
    } copy];
}

@end
