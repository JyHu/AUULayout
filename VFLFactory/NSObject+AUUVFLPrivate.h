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

@property (weak, nonatomic) UIView *base;

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
