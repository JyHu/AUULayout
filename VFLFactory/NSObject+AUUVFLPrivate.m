//
//  NSObject+AUUVFLPrivate.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "NSObject+AUUVFLPrivate.h"
#import <objc/runtime.h>

@implementation NSString (Private)

const char *kBaseAssociatedKey = (void *)@"kBaseAssociatedKey";

- (void)setBase:(UIView *)base
{
    objc_setAssociatedObject(self, kBaseAssociatedKey, base, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)base
{
    return objc_getAssociatedObject(self, kBaseAssociatedKey);
}

- (NSString *)matchWithPattern:(NSString *)pattern
{
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *textCheckingResult = [reg firstMatchInString:self options:NSMatchingCompleted range:NSMakeRange(0, self.length)];
    if (textCheckingResult && textCheckingResult.range.location != NSNotFound) {
        return [self substringWithRange:textCheckingResult.range];
    }
    return nil;
}

- (NSArray *)matchesWithPattern:(NSString *)pattern
{
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [reg matchesInString:self options:NSMatchingCompleted range:NSMakeRange(0, self.length)];
    NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:matches.count];
    if (matches) {
        for (NSTextCheckingResult *tcr in matches) {
            if (tcr.range.location != NSNotFound) {
                [res addObject:[self substringWithRange:tcr.range]];
            }
        }
    }
    return res;
}

@end

@implementation UIView (Private)

const char *kLayoutKitsAssociatedKey = (void *)@"kLayoutKitsAssociatedKey";

- (void)setLayoutKits:(NSMutableDictionary *)layoutKits {
    objc_setAssociatedObject(self, kLayoutKitsAssociatedKey, layoutKits, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)layoutKits {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, kLayoutKitsAssociatedKey);
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
        [self setLayoutKits:dict];
    }
    return dict;
}

const char *kReleationAssociateKey = (void *)@"kReleationAssociateKey";

- (void)setReleation:(NSString *)releation {
    objc_setAssociatedObject(self, kReleationAssociateKey, releation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)releation {
    return objc_getAssociatedObject(self, kReleationAssociateKey);
}

- (NSString *)hashKey {
    NSAssert1(self.superview, @"没有添加到父视图 %@", self);
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *hashKey = [NSString stringWithFormat:@"%@%@", NSStringFromClass([self class]), @([self hash])];
    if (![self.superview.layoutKits objectForKey:hashKey]) {
        [self.superview.layoutKits setObject:self forKey:hashKey];
    }
    
    return hashKey;
}

@end
