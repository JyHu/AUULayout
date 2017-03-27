//
//  AUUVFLLayout.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
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

- (AUUVFLConstraints *)resetWithDirection:(AUUVFLLayoutDirection)direction;     // VFL语句的初始化方法，在宏定义中已经使用，外部不需要调用这个方法，由于使用了宏定义无法设置私有属性才放出这个方法。
@property (copy, nonatomic) NSString * (^end)();    // 以父视图的右边或者底部结束VFL布局，比如 `H[10][view][10].end();` ，这时候不需要为view设置宽高属性
@property (copy, nonatomic) NSString * (^endL)();   // 以设置的最后一个视图结束VFL布局，比如 `H[10][view.VFL[100]].endL();` 就是以view作为最后的结尾，这种情况需要为view设置宽高属性。

@end

/*
 用于View相关的命名空间，设置子视图的宽高、优先级属性
 */


@interface AUUSubVFLConstraints : AUUVFLLayoutConstrants
NSString *priority(CGFloat length, CGFloat priority);       // 优先级属性的生成
NSString *between(CGFloat minLength, CGFloat maxLength);    // 宽高区间范围的生成
NSString *greaterThan(CGFloat length);                      // 最低宽高的生成
NSString *lessThan(CGFloat length);
@end


/**
 为UIView单独做一个命名空间是为了减少对view的扩充，避免过多的属性、方法的扩充导致与其他库或者使用者各自需求的冲突
 */
@interface UIView (AUUVFLSpace)
@property (retain, nonatomic) AUUSubVFLConstraints *VFL;    // 所有VFL语句中(封装的方法除外)，对view视图的处理都必须以接入此属性开始，比如 `H[view.VFL[100]].end();`，设置view的宽度为100。
@end


/*
 对UIView的一些通用方法做的封装
 */

@interface UIView (AUUVFLLayout)
@property (copy, nonatomic) NSArray *(^edge)(UIEdgeInsets insets);
@property (copy, nonatomic) UIView *(^fixedSize)(CGFloat width, CGFloat height);
@end

