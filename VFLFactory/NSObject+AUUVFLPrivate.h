//
//  NSObject+AUUVFLPrivate.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AUULayoutAttribute.h"

@interface NSString (Private)

/**
 当前需要设置vfl的所有视图的父视图，因为在vfl的出口处(end endL)摆脱不掉，所以需要这个属性
 */
@property (weak, nonatomic) UIView *base;

/**
 使用正则表达式截取字符串中的某一部分

 @param pattern 正则表达式
 @return 截取出的部分，截取不到的，返回nil
 */
- (NSString *)matchesWithPattern:(NSString *)pattern;

@end

@interface UIView (Private)

/**
 保存涉及到的需要自动布局的视图
 */
@property (retain, nonatomic) NSMutableDictionary *layoutKits;

/**
 保存子视图在设置宽度的时候的设置比对方式
 */
@property (retain, nonatomic) NSString *releation;

/**
 保存视图并生成key
 */
- (NSString *)addHashKey:(UIView *)view;

@end
