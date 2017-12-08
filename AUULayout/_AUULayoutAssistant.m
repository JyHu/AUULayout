//
//  _AUULayoutAssistant.m
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import "_AUULayoutAssistant.h"
#import "AUULayoutAssistant.h"

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

@implementation AUUGlobalDataStorage

+ (instancetype)sharedStorage
{
    static AUUGlobalDataStorage *globalDataStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalDataStorage = [[AUUGlobalDataStorage alloc] init];
        globalDataStorage.needAutoCoverRepetitionLayoutConstrants = YES;
    });
    return globalDataStorage;
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
