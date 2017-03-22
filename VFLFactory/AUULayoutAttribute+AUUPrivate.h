//
//  AUULayoutAttribute+AUUPrivate.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import <VFLFactory/VFLFactory.h>

@interface AUULayoutAttribute (AUUPrivate)

/**
 类方法，创建一个 AUULayoutAttribute
 
 @return self
 */
+ (instancetype)layoutAttributeWithView:(UIView *)view attribute:(NSLayoutAttribute)layoutAttribute;

/**
 第一个视图，发起比较的视图
 */
@property (weak, nonatomic) UIView *firstView;

/**
 第二个视图，被动比较的视图
 */
@property (weak, nonatomic) UIView *secondView;

/**
 第二个视图的布局属性
 */
@property (assign, nonatomic, readwrite) NSLayoutAttribute secondlayoutAttribute;

/**
 第一个视图的布局属性
 */
@property (assign, nonatomic, readwrite) NSLayoutAttribute firstLayoutAttribute;

/**
 间距
 */
@property (assign, nonatomic) CGFloat margin;

/**
 相对比例
 */
@property (assign, nonatomic) CGFloat multiplier;

@end
