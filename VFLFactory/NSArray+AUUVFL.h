//
//  NSArray+AUUVFL.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AUULayoutDirection) {
    AUULayoutDirectionHorizontal,
    AUULayoutDirectionVertical
};

@interface NSArray (AUUVFL)

/**
 将一列视图均匀布局
 
 param direction 布局的方向
 param insets 上下左右的间距
 param margin 两个控件之间的间距
 */
@property (copy, nonatomic, readonly) NSArray *(^avgLayoutDEM)(AUULayoutDirection direction, UIEdgeInsets insets, CGFloat margin);
@property (copy, nonatomic, readonly) NSArray *(^avgLayoutDM) (AUULayoutDirection direction, CGFloat margin);
@property (copy, nonatomic, readonly) NSArray *(^avgLayoutDE) (AUULayoutDirection direction, UIEdgeInsets insets);
@property (copy, nonatomic, readonly) NSArray *(^avgLayoutD)  (AUULayoutDirection direction);


/**
 在横向按照指定的宽度布局
 
 param width 宽度，必须值，必须大于0，否则会报错
 param height 高度，非必须值，如果大于0则会对组件设置绝对的高度值，如果小于或等于0，则会在纵向填充满父视图
 param margin 间隔，两个view的横向间隔
 */
@property (copy, nonatomic, readonly) NSArray *(^absHoriLayout)(CGFloat width, CGFloat height, CGFloat margin);

/**
 在横向按照指定的宽度布局
 
 param width 宽度，非必须值，如果大于0则会对组件设置绝对的宽度值，如果小于或等于0，则会在横向填充满父视图
 param height 高度，必须值，必须大于0，否则会报错
 param margin 间隔，两个view的横向间隔
 */
@property (copy, nonatomic, readonly) NSArray *(^absVertLayout)(CGFloat width, CGFloat height, CGFloat margin);

@end
