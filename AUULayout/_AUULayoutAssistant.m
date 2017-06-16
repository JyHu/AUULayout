//
//  _AUULayoutAssistant.m
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import "_AUULayoutAssistant.h"
#import "AUULayoutAssistant.h"

@implementation _AUULayoutAssistant

@end

@implementation NSLayoutConstraint (AUUAssistant)

- (BOOL)similarTo:(NSLayoutConstraint *)layoutConstrant
{
    // 如果第一个视图不一样则不类似
    if (![self.firstItem isEqual:layoutConstrant.firstItem]) {
        return NO;
    }
    
    // 如果第一个attribute不一样则不类似
    if (self.firstAttribute != layoutConstrant.firstAttribute) {
        return NO;
    }
    
    // 如果第二个视图都存在的话
    if (self.secondItem && layoutConstrant.secondItem) {
        
        // 如果第二个视图不相同则不类似
        if (![self.secondItem isEqual:layoutConstrant.secondItem]) {
            return NO;
        }
        
        // 如果第二个attribute不一样则不类似
        if (self.secondAttribute != layoutConstrant.secondAttribute) {
            return NO;
        }
    }
    
    return YES;
}

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"


@implementation UIView (__AUUPrivate)

- (void)hierarchyLog
{
#if DEBUG
    if ([AUUGlobalDataStorage sharedStorage].needDebugLod) {
        NSLog(@"\n"
              "|--------------------------------------------------------------------------------------------|\n"
              "|--------------------------------------------------------------------------------------------|\n"
              "|                                                                                            |\n"
              "|                           %@\n"
              "|                                                                                            |\n"
              "%@\n\n\n" , self, [self.rootResponderView recursiveDescription]);
    }
#endif
}

@end

#pragma clang diagnostic pop

@implementation AUUGlobalDataStorage

+ (instancetype)sharedStorage
{
    static AUUGlobalDataStorage *globalDataStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalDataStorage = [[AUUGlobalDataStorage alloc] init];
    });
    return globalDataStorage;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.needAutoCoverRepetitionLayoutConstrants = YES;
    }
    return self;
}

@end

@implementation NSString (__AUUPrivate)

/**
 判断是否满足这个正则表达式
 
 @param pattern 正则表达式
 @return 是否满足条件
 */
- (BOOL)isLegalStringWithPattern:(NSString *)pattern {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern] evaluateWithObject:self];
}

/**
 判断是否满足其中的某个正则表达式
 
 @param patterns 正则表达式列表
 @return 是否满足条件
 */
- (BOOL)isLegalStringWithPatterns:(NSArray *)patterns {
    for (NSString *pattern in patterns) {
        if ([self isLegalStringWithPattern:pattern]) {
            return YES;
        }
    }
    return NO;
}

/**
 判断是否满足所有这些正则表达式
 
 @param patterns 正则表达式列表
 @return 是否满足条件
 */
- (BOOL)isLegalStringAllMatchPatterns:(NSArray *)patterns {
    for (NSString *pattern in patterns) {
        if (![self isLegalStringWithPattern:pattern]) {
            return NO;
        }
    }
    return YES;
}
/**
 使用正则匹配来查找字符串中有多少个匹配的内容
 
 @param pattern 用来匹配的正则表达式
 @return 匹配到的个数
 */
- (NSUInteger)numberOfMatchesWithPattern:(NSString *)pattern {
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)].count;
}
@end

@implementation NSArray (__AUUPrivate)

/**
 操作数组中的所有元素，并重新返回一个数组
 
 @param map 数据转换的block
 @param cls 要判断的数据类型，如果为nil，则所有的数据类型都可进行操作
 @return 转换后的数组
 */
- (NSArray *)map:(id (^)(id obj, NSUInteger index))map checkClass:(Class)cls
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    if (self && self.count > 0) {
        for (NSUInteger i = 0; i < self.count; i ++) {
            id cur = self[i];
            if (!cls || (cls && [cur isKindOfClass:cls])) {
                id temp = map(cur, i);
                if (temp) {
                    [results addObject:temp];
                }
            }
        }
    }
    return results;
}
@end
