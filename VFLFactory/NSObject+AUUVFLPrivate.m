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

- (NSString *)addHashKey:(UIView *)view {
    
    NSAssert1(view.superview, @"没有添加到父视图 %@", view);
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *hashKey = [NSString stringWithFormat:@"%@%@", NSStringFromClass([view class]), @([view hash])];
    if (![self.layoutKits objectForKey:hashKey]) {
        [self.layoutKits setObject:view forKey:hashKey];
    }
    
    return hashKey;
}

@end
