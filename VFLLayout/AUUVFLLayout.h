//
//  AUUVFLLayout.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <UIKit/UIKit.h>


@interface AUUVFLLayoutConstrants : NSObject

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;
- (instancetype)objectForKeyedSubscript:(id)key;

@end

/*
 外部VFL的命名空间，用于VFL相关属性的设置、管理
 */

@interface AUUVFLConstraints : AUUVFLLayoutConstrants

@property (copy, nonatomic) NSString * (^end)();
@property (copy, nonatomic) NSString * (^endL)();

@end


/*
 用于View相关的命名空间，设置子视图的宽高、优先级属性
 */

NSString *priority(CGFloat length, CGFloat priority);
NSString *between(CGFloat minLength, CGFloat maxLength);
NSString *greaterThan(CGFloat length);

@interface AUUSubVFLConstraints : AUUVFLLayoutConstrants
@end

/*
 VFL语句的开始，后面需要承接其对应的命名空间，然后才能进行属性的设置和多视图的级联
 */
extern NSString *const H;
extern NSString *const V;

/**
 为VFL起始的字符串做的命名空间，所有单条的VFL设置都从这里开始
 */
@interface NSString (AUUVFLSpace)
@property (retain, nonatomic) AUUVFLConstraints *VFL;
@end

@interface UIView (AUUVFLSpace)
@property (retain, nonatomic) AUUSubVFLConstraints *VFL;
@end


/*
 对UIView的一些通用方法做的封装
 */

@interface UIView (AUUVFLLayout)

@property (copy, nonatomic) NSArray *(^edge)(UIEdgeInsets insets);

@property (copy, nonatomic) UIView *(^fixedSize)(CGFloat width, CGFloat height);

@end

