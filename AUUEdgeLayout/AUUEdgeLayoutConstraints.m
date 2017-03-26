////
////  AUUEdgeLayoutConstraints.m
////  VFLFactory
////
////  Created by JyHu on 2017/3/26.
////
////
//
//#import "AUUEdgeLayoutConstraints.h"
//
//@implementation AUUEdgeLayoutConstraints
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))topEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeTop];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))leftEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeLeft];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))bottomEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeBottom];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))rightEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeRight];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))widthEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeWidth];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))heightEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeHeight];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))centerXEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeCenterX];
//    } copy];
//}
//
//- (AUUEdgeLayoutConstraints *(^)(AUUEdgeSubLayoutConstraints *))centerYEqual
//{
//    return [^(AUUEdgeSubLayoutConstraints *layoutAttribute){
//        return [self layoutWithLayoutAttribute:layoutAttribute type:NSLayoutAttributeCenterY];
//    } copy];
//}
//
//- (instancetype)layoutWithLayoutAttribute:(AUUEdgeSubLayoutConstraints *)layoutAttribute type:(NSLayoutAttribute)type
//{
//    if (self.sponsorView.superview && [self.sponsorView.superview isKindOfClass:[UIView class]]) {
//        self.sponsorView.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    
//    if (layoutAttribute.secondView && layoutAttribute.secondView.superview && [layoutAttribute.secondView.superview isKindOfClass:[UIView class]]) {
//        layoutAttribute.secondView.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    
//    UIView *sup = self.sponsorView.superview;
//    
//    if (self.sponsorView.superview == layoutAttribute.secondView.superview) {
//        sup = self.sponsorView.superview;
//    } else if (self.sponsorView.superview == layoutAttribute.secondView) {
//        sup = self.sponsorView.superview;
//    } else if (self == layoutAttribute.secondView.superview) {
//        sup = self;
//    }
//    
//    [sup addConstraint:[NSLayoutConstraint constraintWithItem:self.sponsorView attribute:type
//                                                    relatedBy:NSLayoutRelationEqual
//                                                       toItem:layoutAttribute.secondView
//                                                    attribute:layoutAttribute.secondlayoutAttribute
//                                                   multiplier:layoutAttribute.pri_multiplier
//                                                     constant:layoutAttribute.pri_constant]];
//    return self;
//}
//
//@end
//
//
//
//@implementation AUUEdgeSubLayoutConstraints (AUUVFLEdge)
//
//- (AUUEdgeSubLayoutConstraints *)top {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeTop];
//}
//- (AUUEdgeSubLayoutConstraints *)left {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeLeft];
//}
//- (AUUEdgeSubLayoutConstraints *)bottom {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeBottom];
//}
//- (AUUEdgeSubLayoutConstraints *)right {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeRight];
//}
//-(AUUEdgeSubLayoutConstraints *)width {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeWidth];
//}
//- (AUUEdgeSubLayoutConstraints *)height {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeHeight];
//}
//- (AUUEdgeSubLayoutConstraints *)centerX {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeCenterX];
//}
//- (AUUEdgeSubLayoutConstraints *)centerY {
//    return [AUUEdgeSubLayoutConstraints layoutAttributeWithView:self.sponsorView attribute:NSLayoutAttributeCenterY];
//}
//
//@end
