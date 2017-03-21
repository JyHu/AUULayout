//
//  UIView+AUUVFL.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <UIKit/UIKit.h>

#pragma mark - 子视图封装的多属性布局方式
#pragma mark -

@interface UIView (AUUVFL)

/**
 设置其在父视图上得上下左右边距
 */
@property (copy, nonatomic, readonly) NSArray *(^edge)(UIEdgeInsets);

@end


#pragma mark - 子视图级联的单个宽高属性
#pragma mark -

/*
 
 子视图级联的单个属性，必须由子视图调用
 
 比如 [A addSubview:B]
 
 此时B是子视图，其要在A上进行自动布局，则就必须用B来调用下列方法。
 
 下列方法是用于设置子视图的宽高和优先级，只能在 `NSString+AUUVFL.h` 的 `NSString *(^nextTo)(UIView *)` 方法中使用
 
 比如： `self.Hori.interval(20).nextTo(view1.equalTo(view2))`
 
 */

@interface UIView (AUUSub)

/**
 设置view的长宽   H:|-0-[view(80)]-0-|        H:|-0-[view(label)]-0-|
 
 t 要相等的对象，可以是number、uiview
 */
- (UIView *(^)(id t))equalTo;

/**
 设置与某个视图相等的长宽 H:|-0-[view(==label)]-0-|  其中的 (==label)
 
 view 要设置相等的视图
 */
- (UIView *(^)(UIView *view))equalToV;

/**
 长宽最小是多少      H:|-0-[view(>=20)]-0-|      其中的(>=20)
 
 len 长宽的最小值
 */
- (UIView *(^)(CGFloat len))greaterThan;

/**
 设置宽高和优先级     H:|-0-[view(100@20)]-0-|        其中的 (100@20)
 
 len 可被压缩到得最小的宽高值
 priority 优先级的高低，优先级高的先背压缩
 
 */
- (UIView *(^)(CGFloat len, CGFloat priority))priority;

/**
 设置长宽在某个区间      H:|-0-[view(>=80,<=100)]-0-|        其中的(>=80,<=100)
 
 lenMin 宽度的最小值
 lenMax 宽度的最大值
 */
- (UIView *(^)(CGFloat lenMin, CGFloat lenMax))between;

@end


#pragma mark - VFL的开始语句
#pragma mark -

/*
 
 VFL的开始语句，必须由一个view发起，而且必须是要自动布局的视图的父视图
 
 比如 [A addSubview:B]
 
 那么此时A视图就是父视图，VFL语句的开始就必须从A开始，这样才能对其上得所有视图比如B做自动布局的设定
 
 */

@interface UIView (AUUVFLStarting)

/**
 horizontal vfl
 */
@property (retain, nonatomic, readonly) NSString *Hori;

/**
 vertical vfl
 */
@property (retain, nonatomic, readonly) NSString *Vert;

@end

/*
 
 给 UIViewController 添加的辅助属性，其实内部使用的是 UIViewController 的 view 来做的。
 
 */

@interface UIViewController (AUUVFLStarting)

/**
 horizontal vfl
 */
@property (retain, nonatomic, readonly) NSString *Hori;

/**
 vertical vfl
 */
@property (retain, nonatomic, readonly) NSString *Vert;

@end
