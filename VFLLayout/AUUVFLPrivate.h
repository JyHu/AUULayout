//
//  AUUVFLPrivate.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <UIKit/UIKit.h>
#import "AUUVFLConstraints.h"
#import "AUUSubVFLConstraints.h"

@interface AUUVFLPrivate : NSObject

@end

typedef NS_ENUM(NSUInteger, AUULayoutDirection) {
    AUULayoutDirectionUnknown,
    AUULayoutDirectionHorizontal,
    AUULayoutDirectionVertical
};

typedef NS_ENUM(NSUInteger, AUULayoutInstallType) {
    AUULayoutInstallTypeUnknown,
    AUULayoutInstallTypeInstall,
    AUULayoutInstallTypeUninstall,
    AUULayoutInstallTypeUpdate
};

@interface AUUVFLConstraints (__AUUPrivate)

@property (assign, nonatomic) AUULayoutDirection layoutDirection;

@property (assign, nonatomic) AUULayoutInstallType layoutInstallType;

@property (weak, nonatomic) UIView *containerView;

@property (retain, nonatomic) NSMutableString *VFLString;

@property (retain, nonatomic) NSMutableDictionary *layoutKits;

- (NSString *)cacheView:(UIView *)view;

@end

@interface AUUSubVFLConstraints (__AUUPrivate)

@property (weak, nonatomic) UIView *sponsorView;

@property (retain, nonatomic) NSMutableString *relationSubVFL;

@property (retain, nonatomic) NSMutableDictionary *layoutKits;

- (NSString *)cacheView:(UIView *)view;

@end

@interface NSString (__AUUPrivate)

/**
 使用正则表达式截取字符串中的某一部分
 
 @param pattern 正则表达式
 @return 截取出的部分，截取不到的，返回nil
 */
- (NSString *)matchWithPattern:(NSString *)pattern;
- (NSArray *)matchesWithPattern:(NSString *)pattern;

@end

@interface UIView (__AUUPrivate)

- (NSString *)hashKey;

@end
