//
//  UIView+AUUVFLLayout.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <UIKit/UIKit.h>

@interface UIView (AUUVFLLayout)

@property (copy, nonatomic) NSArray *(^edge)(UIEdgeInsets insets);

@property (copy, nonatomic) UIView *(^fixedSize)(CGFloat width, CGFloat height);

@end
