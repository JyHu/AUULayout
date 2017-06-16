//
//  _AUULayoutAssistant.h
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface _AUULayoutAssistant : NSObject

@end


@interface NSLayoutConstraint (AUUAssistant)

- (BOOL)similarTo:(NSLayoutConstraint *)layoutConstrant;

@end

@interface AUUGlobalDataStorage : NSObject

+ (instancetype)sharedStorage;

@property (assign, nonatomic) BOOL needDebugLod;

@property (assign, nonatomic) BOOL needAutoCoverRepetitionLayoutConstrants;

@property (copy, nonatomic) void (^errorLayoutConstrantsReporter)(NSLayoutConstraint *oldLayoutConstrant, NSLayoutConstraint *newLayoutConstrant);

@end

@interface UIView (__AUUPrivate)

#ifdef DEBUG
- (id)recursiveDescription;
#endif

- (void)hierarchyLog;

@end

@interface NSArray (__AUUPrivate)

- (NSArray *)map:(id (^)(id obj, NSUInteger index))map checkClass:(Class)cls;

@end

@interface NSString (__AUUPrivate)

/**
 判断是否满足这个正则表达式
 
 @param pattern 正则表达式
 @return 是否满足条件
 */
- (BOOL)isLegalStringWithPattern:(NSString *)pattern;

/**
 判断是否满足其中的某个正则表达式
 
 @param patterns 正则表达式列表
 @return 是否满足条件
 */
- (BOOL)isLegalStringWithPatterns:(NSArray *)patterns;

/**
 判断是否满足所有这些正则表达式
 
 @param patterns 正则表达式列表
 @return 是否满足条件
 */
- (BOOL)isLegalStringAllMatchPatterns:(NSArray *)patterns;

/**
 使用正则匹配来查找字符串中有多少个匹配的内容
 
 @param pattern 用来匹配的正则表达式
 @return 匹配到的个数
 */
- (NSUInteger)numberOfMatchesWithPattern:(NSString *)pattern;

@end
