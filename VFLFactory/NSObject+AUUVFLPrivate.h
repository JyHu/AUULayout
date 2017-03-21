//
//  NSObject+AUUVFLPrivate.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Private)

@property (weak, nonatomic) UIView *base;

@end

@interface UIView (Private)

@property (retain, nonatomic) NSMutableDictionary *layoutKits;

@property (retain, nonatomic) NSString *releation;

- (NSString *)addHashKey:(UIView *)view;

@end
