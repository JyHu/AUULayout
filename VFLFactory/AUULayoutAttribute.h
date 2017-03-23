//
//  AUULayoutAttribute.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import <UIKit/UIKit.h>

/*
 用于记录使用NSLayoutConstraint布局时的参数
 
 使用到的自动布局方法是:
 +(instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 
                         relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 
                         attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c;
 
 注意：
 
    这个类不提供外部初始化的能力，只可通过 `UIView+AUUVFLEdge` 里的方法获取实例
 */

@interface AUULayoutAttribute : NSObject

/**
 设置间距
 */
@property (retain, nonatomic, readonly) AUULayoutAttribute *(^u_constant)(CGFloat constant);

/**
 设置相对比例
 */
@property (retain, nonatomic, readonly) AUULayoutAttribute *(^u_multiplier)(CGFloat multiplier);

@end
