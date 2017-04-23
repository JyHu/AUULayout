//
//  AUUVFLLayout.h
//  AUULayout
//
//  Created by JyHu on 2017/3/31.
//  Copyright © 2017年 JyHu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AUUVFLLayoutDirection) {
    AUUVFLLayoutDirectionUnknow,
    AUUVFLLayoutDirectionHorizontal,
    AUUVFLLayoutDirectionVertical
};

// VFL横向布局的开始，必须(封装的一些方法除外)以其开头
#define H ([[[AUUVFLConstraints alloc] init] resetWithDirection:AUUVFLLayoutDirectionHorizontal])
// VFL纵向布局的开始，必须(封装的一些方法除外)以其开头
#define V ([[[AUUVFLConstraints alloc] init] resetWithDirection:AUUVFLLayoutDirectionVertical])

@interface AUUVFLLayoutConstrants : NSObject
- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;
- (instancetype)objectForKeyedSubscript:(id)key;
@end

/*
 外部VFL的命名空间，用于VFL相关属性的设置、管理
 */

@interface AUUVFLConstraints : AUUVFLLayoutConstrants

// VFL语句的初始化方法，在宏定义中已经使用，外部不需要调用这个方法，由于使用了宏定义无法设置私有属性才放出这个方法。
- (AUUVFLConstraints *)resetWithDirection:(AUUVFLLayoutDirection)direction;

// 以父视图的右边或者底部结束VFL布局，比如 `H[10][view][10].end();` ，这时候不需要为view设置宽高属性
@property (copy, nonatomic, readonly) NSString * (^end)();

// 以设置的最后一个视图结束VFL布局，比如 `H[10][view.VFL[100]].endL();` 就是以view作为最后的结尾，这种情况需要为view设置宽高属性。
@property (copy, nonatomic, readonly) NSString * (^cut)();

@end

/*
 用于View相关的命名空间，设置子视图的宽高、优先级属性
 */


@interface AUUSubVFLConstraints : AUUVFLLayoutConstrants
NSString *priority(CGFloat length, CGFloat priority);       // 优先级属性的生成
NSString *between(CGFloat minLength, CGFloat maxLength);    // 宽高区间范围的生成
NSString *greaterThan(CGFloat length);                      // 最低宽高的生成
NSString *lessThan(CGFloat length);                         // 设置最大的宽高
@end


/**
 为UIView单独做一个命名空间是为了减少对view的扩充，避免过多的属性、方法的扩充导致与其他库或者使用者各自需求的冲突
 */

@interface UIView (AUUVFLSpace)

/*
 如果外部文件有内容跟这里的方法有冲突的话，可以在引用当前文件之前一行代码的地方加入一下宏定义即可
 #define kUseVFLSubscriptLayout 0
 然后就会禁止掉当前VFL布局方法里的下标法。
 此时可以使用 .VFL 空间名去做VFL布局
 */

#ifndef kUseVFLSubscriptLayout
#define kUseVFLSubscriptLayout 1
#endif
#if kUseVFLSubscriptLayout
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (id)objectForKeyedSubscript:(id)key;
#endif

// 如果禁止掉kUseVFLSubscriptLayout后，所有VFL语句中(封装的方法除外)，对view视图的处理都必须以接入此属性开始，比如 `H[view.VFL[100]].end();`，设置view的宽度为100。
@property (retain, nonatomic) AUUSubVFLConstraints *VFL;

@end


/*
 对UIView的一些通用方法做的封装
 */

@interface UIView (AUUVFLLayout)

// 设置视图在父视图上距离上下左右的位置
@property (copy, nonatomic, readonly) NSArray *(^edge)(UIEdgeInsets insets);

// 设置为指定的大小
@property (copy, nonatomic, readonly) UIView *(^fixedSize)(CGFloat width, CGFloat height);
@end

@interface NSArray (AUUVFLLayout)

@end


