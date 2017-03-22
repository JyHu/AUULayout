//
//  UIView+AUUVFLEdge.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import <UIKit/UIKit.h>

@interface AUULayoutAttribute : NSObject

+ (instancetype)layoutAttributeWithView:(UIView *)view attribute:(NSLayoutAttribute)layoutAttribute;

@property (weak, nonatomic, readonly) UIView *view;

@property (assign, nonatomic, readonly) NSLayoutAttribute layoutAttribute;

@end

@interface UIView (AUUVFLEdge)

@property (retain, nonatomic, readonly) AUULayoutAttribute *u_top;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_left;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_bottom;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_right;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_width;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_height;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_centerX;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_centerY;

@end

@interface UIView (AUUVFLEdgeEqual)

@property (copy, nonatomic, readonly) UIView *(^topEqual)(AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^leftEqual)(AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^bottomEqual)(AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^rightEqual)(AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^centerXEqual)(AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^centerYEqual)(AUULayoutAttribute *layoutAttribute);

@property (copy, nonatomic, readonly) UIView *(^topMarginEqual)(AUULayoutAttribute *layoutAttribute, CGFloat margin);
@property (copy, nonatomic, readonly) UIView *(^leftMarginEqual)(AUULayoutAttribute *layoutAttribute, CGFloat margin);
@property (copy, nonatomic, readonly) UIView *(^bottomMarginEqual)(AUULayoutAttribute *layoutAttribute, CGFloat margin);
@property (copy, nonatomic, readonly) UIView *(^rightMarginEqual)(AUULayoutAttribute *layoutAttribute, CGFloat margin);
@property (copy, nonatomic, readonly) UIView *(^centerXMarginEqual)(AUULayoutAttribute *layoutAttribute, CGFloat margin);
@property (copy, nonatomic, readonly) UIView *(^centerYMarginEqual)(AUULayoutAttribute *layoutAttribute, CGFloat margin);

@end
