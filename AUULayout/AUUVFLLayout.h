//
//  AUUVFLLayout.h
//  AUULayout
//
//  Created by JyHu on 2017/3/31.
//  Copyright © 2017年 JyHu. All rights reserved.
//

#import <UIKit/UIKit.h>



// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//  Useage Documentation 使用说明
//  https://github.com/JyHu/AUULayout/blob/master/README.md
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



typedef NS_ENUM(NSUInteger, AUUVFLLayoutDirection) {
    AUUVFLLayoutDirectionUnknow,        // 未知
    AUUVFLLayoutDirectionHorizontal,    // 横向
    AUUVFLLayoutDirectionVertical,      // 纵向
};

// VFL横向布局的开始，必须(封装的一些方法除外)以其开头
#define H ([[[AUUVFLConstraints alloc] init] resetWithDirection:AUUVFLLayoutDirectionHorizontal])
// VFL纵向布局的开始，必须(封装的一些方法除外)以其开头
#define V ([[[AUUVFLConstraints alloc] init] resetWithDirection:AUUVFLLayoutDirectionVertical])
// 批量的横向布局的开始
#define HA (@[H].VFL)
// 批量的纵向布局的开始
#define VA (@[V].VFL)


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 为布局扩展下标法的基类
#pragma mark -
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


@interface AUUVFLLayout : NSObject
/*
 扩充的下标法，这里不用id是因为这里在使用的时候最好不要去强制转换、判断数据类型。
 */
- (instancetype)objectAtIndexedSubscript:(NSInteger)idx;
- (instancetype)objectForKeyedSubscript:(id)key;

@property (weak, nonatomic, readonly) UIView *sponsorView;

@end

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 对主VFL语句设置属性的类
#pragma mark -
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 外部VFL的命名空间，用于VFL相关属性的设置、管理
 */

@interface AUUVFLConstraints : AUUVFLLayout

// VFL语句的初始化方法，在宏定义中已经使用，外部不需要调用这个方法，由于使用了宏定义无法设置私有属性才放出这个方法。
- (AUUVFLConstraints *)resetWithDirection:(AUUVFLLayoutDirection)direction;

// 以父视图的右边或者底部结束VFL布局，比如 `H[10][view][10].end();` ，这时候不需要为view设置宽高属性
@property (copy, nonatomic, readonly) NSString * (^end)();

// 以设置的最后一个视图结束VFL布局，比如 `H[10][view[100]].cut();` 就是以view作为最后的结尾，这种情况需要为view设置宽高属性。
@property (copy, nonatomic, readonly) NSString * (^cut)();

@end


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 对子视图设置VFL布局的类，及对UIView扩充的一些方法
#pragma mark -
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
 用于View相关的命名空间，设置子视图的宽高、优先级属性
 */
@interface AUUSubVFLConstraints : AUUVFLLayout
NSString *priority(CGFloat length, CGFloat priority);       // 优先级属性的生成
NSString *between(CGFloat minLength, CGFloat maxLength);    // 宽高区间范围的生成
NSString *greaterThan(CGFloat length);                      // 视图间距、宽高的最小值
NSString *lessThan(CGFloat length);                         // 视图间距、宽高的最大值
@end


/**
 为UIView单独做一个命名空间是为了减少对view的扩充，避免过多的属性、方法的扩充导致与其他库或者使用者各自需求的冲突
 */

@interface UIView (AUUVFLSpace)

/*
 如果外部文件有内容跟这里的方法有冲突的话，可以在引用当前文件之前一行代码的地方加入一下宏定义即可
 #define kUIViewUseVFLSubscriptLayout 0
 然后就会禁止掉当前VFL布局方法里的下标法。
 此时可以使用 .VFL 空间名去做VFL布局
 */

#ifndef kUIViewUseVFLSubscriptLayout
#define kUIViewUseVFLSubscriptLayout 1
#endif
#if kUIViewUseVFLSubscriptLayout
/*
 对UIView扩充的下标法，这里不用instance是因为返回的数据类型有改变
 */
- (id)objectAtIndexedSubscript:(NSInteger)idx;
- (id)objectForKeyedSubscript:(id)key;
#endif

// 如果禁止掉kUseVFLSubscriptLayout后，所有VFL语句中(封装的方法除外)，对view视图的处理都必须以接入此属性开始，比如 `H[view.VFL[100]].end();`，设置view的宽度为100。
@property (retain, nonatomic, readonly) AUUSubVFLConstraints *VFL;

@end

/*
 对UIView的一些通用方法做的封装
 */

@interface UIView (AUUVFLLayout)
// 设置视图在父视图上距离上下左右的位置
@property (copy, nonatomic, readonly) NSArray *(^edge)(UIEdgeInsets insets);
// 设置为指定的大小
@property (copy, nonatomic, readonly) NSArray *(^fixedSize)(CGFloat width, CGFloat height);
@end

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#pragma mark - 对批量属性操作的类及辅助方法
#pragma mark -
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

@interface AUUGroupVFLConstrants : AUUVFLLayout
@property (copy, nonatomic, readonly) NSArray * (^end)();   // 结束语句，会返回一个vfl语句的数组
@property (copy, nonatomic, readonly) NSArray * (^cut)();   // 结束语句，会返回一个vfl语句的数组
@end

/*
 可操作的数组元素有 AUUVFLLayout及其子类、UIView及其子类
 */
@interface NSArray (AUUVFLSpace)
// 对数组扩充命名空间，因为数组本身就实现了下标法，所以为了避免调用冲突，就为其增加了一个命名空间，所有对于批量属性操作数组都必须调用这个属性
@property (retain, nonatomic, readonly) AUUGroupVFLConstrants *VFL;
@end
