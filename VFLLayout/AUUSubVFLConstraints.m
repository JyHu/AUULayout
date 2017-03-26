//
//  AUUSubVFLConstraints.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/25.
//
//

#import "AUUSubVFLConstraints.h"
#import "AUUVFLPrivate.h"

NSString *priority(CGFloat width, CGFloat priority)
{
    return [NSString stringWithFormat:@"(%@@%@)", @(width), @(priority)];
}

NSString *between(CGFloat minLength, CGFloat maxLength)
{
    return [NSString stringWithFormat:@"(>=%@,<=%@)", @(minLength), @(maxLength)];
}

@implementation AUUSubVFLConstraints

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self[@(idx)];
}

- (instancetype)objectForKeyedSubscript:(id)key
{
    if ([key isKindOfClass:[NSNumber class]]) {
        self.relationSubVFL = [[NSString stringWithFormat:@"(%@)", key] mutableCopy];
    } else if ([key isKindOfClass:[UIView class]]) {
        self.relationSubVFL = [[NSString stringWithFormat:@"(%@)", [self cacheView:key]] mutableCopy];
    } else if ([key isKindOfClass:[NSString class]]) {
        self.relationSubVFL = key;
    }
    
    return self;
}

@end
