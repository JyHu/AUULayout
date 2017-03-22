//
//  UIView+AUUVFLEdge.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import "UIView+AUUVFLEdge.h"
#import "NSObject+AUUVFLPrivate.h"
#import "AUULayoutAttribute+AUUPrivate.h"

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
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))leftEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))bottomEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))rightEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))widthEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))heightEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))centerXEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

- (UIView *(^)(AUULayoutAttribute *))centerYEqual
{
    return [^(AUULayoutAttribute *layoutAttribute){
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:layoutAttribute.secondView
                                                                   attribute:layoutAttribute.secondlayoutAttribute
                                                                  multiplier:layoutAttribute.multiplier
                                                                    constant:layoutAttribute.margin]];
        return self;
    } copy];
}

@end
