//
//  UIView+AUUEdgeSpace.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <UIKit/UIKit.h>

@class AUUEdgeLayoutConstraints;

@interface UIView (AUUEdgeSpace)

@property (retain, nonatomic) AUUEdgeLayoutConstraints *U;

@property (retain, nonatomic, readonly) void (^viewEdge)(UIView *top, UIView *left, UIView *bottom, UIView *right);

@end
