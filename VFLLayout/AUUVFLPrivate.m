//
//  AUUVFLPrivate.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import "AUUVFLPrivate.h"
#import <objc/runtime.h>

@implementation AUUVFLPrivate

@end

@implementation AUUVFLConstraints(__AUUPrivate)


const char *__kLayoutDirectionAssociatedKey = (void *)@"com.auu.vfl.__kLayoutDirectionAssociatedKey";

- (void)setLayoutDirection:(AUULayoutDirection)layoutDirection
{
    objc_setAssociatedObject(self, __kLayoutDirectionAssociatedKey, @(layoutDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AUULayoutDirection)layoutDirection
{
    id obj = objc_getAssociatedObject(self, __kLayoutDirectionAssociatedKey);
    return obj ? (AUULayoutDirection)[obj integerValue] : AUULayoutDirectionUnknown;
}

const char *__kLayoutInstallTypeAssociatedKey = (void *)@"com.auu.vfl.__kLayoutInstallTypeAssociatedKey";

- (void)setLayoutInstallType:(AUULayoutInstallType)layoutInstallType
{
    objc_setAssociatedObject(self, __kLayoutInstallTypeAssociatedKey, @(layoutInstallType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AUULayoutInstallType)layoutInstallType
{
    id obj = objc_getAssociatedObject(self, __kLayoutInstallTypeAssociatedKey);
    return obj ? (AUULayoutInstallType)[obj integerValue] : AUULayoutInstallTypeUnknown;
}

const char *__kContainerViewAssociatedKey = (void *)@"com.auu.vfl.__kContainerViewAssociatedKey";

- (void)setContainerView:(UIView *)containerView
{
    objc_setAssociatedObject(self, __kContainerViewAssociatedKey, containerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)containerView
{
    return objc_getAssociatedObject(self, __kContainerViewAssociatedKey);
}

const char *__kVFLStringAssociatedKey = (void *)@"com.auu.vfl.__kVFLStringAssociatedKey";

- (void)setVFLString:(NSMutableString *)VFLString
{
    objc_setAssociatedObject(self, __kVFLStringAssociatedKey, VFLString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableString *)VFLString
{
    NSMutableString *vfl = objc_getAssociatedObject(self, __kVFLStringAssociatedKey);
    if (!vfl) {
        vfl = [[NSMutableString alloc] init];
        [self setVFLString:vfl];
    }
    return vfl;
}

const char *__kLayoutKitsAssociatedKey = (void *)@"com.auu.vfl.__kLayoutKitsAssociatedKey";

- (void)setLayoutKits:(NSMutableDictionary *)layoutKits
{
    objc_setAssociatedObject(self, __kLayoutKitsAssociatedKey, layoutKits, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)layoutKits
{
    NSMutableDictionary *layoutKits = objc_getAssociatedObject(self, __kLayoutKitsAssociatedKey);
    if (!layoutKits) {
        layoutKits = [[NSMutableDictionary alloc] init];
        self.layoutKits = layoutKits;
    }
    return layoutKits;
}

- (NSString *)cacheView:(UIView *)view
{
    NSAssert(view, @"设置的view必须有效");
    NSAssert1(view.superview && [view.superview isKindOfClass:[UIView class]], @"视图%@没有添加到父视图上", view);
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.containerView = view.superview;
    
    NSString *hashKey = [view hashKey];
    
    if (![self.layoutKits objectForKey:hashKey]) {
        [self.layoutKits setObject:view forKey:hashKey];
    }
    
    return hashKey;
}

@end

@implementation AUUSubVFLConstraints (__AUUPrivate)

const char *__kRelationSubVFLAssociatedKey = (void *)@"com.auu.vfl.__kRelationSubVFLAssociatedKey";

- (void)setRelationSubVFL:(NSMutableString *)relationSubVFL
{
    objc_setAssociatedObject(self, __kRelationSubVFLAssociatedKey, relationSubVFL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableString *)relationSubVFL
{
    NSMutableString *vfl = objc_getAssociatedObject(self, __kRelationSubVFLAssociatedKey);
    if (!vfl) {
        vfl = [[NSMutableString alloc] init];
        self.relationSubVFL = vfl;
    }
    return vfl;
}

const char *__kSponsorAssociatedKey = (void *)@"com.auu.vfl.__kSponsorAssociatedKey";

- (void)setSponsorView:(UIView *)sponsorView
{
    objc_setAssociatedObject(self, __kSponsorAssociatedKey, sponsorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sponsorView
{
    return objc_getAssociatedObject(self, __kSponsorAssociatedKey);
}

const char *__kSubLayoutKitsAssociatedKey = (void *)@"com.auu.vfl.__kSubLayoutKitsAssociatedKey";

- (void)setLayoutKits:(NSMutableDictionary *)layoutKits
{
    objc_setAssociatedObject(self, __kSubLayoutKitsAssociatedKey, layoutKits, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)layoutKits
{
    NSMutableDictionary *layoutKits = objc_getAssociatedObject(self, __kLayoutKitsAssociatedKey);
    if (!layoutKits) {
        layoutKits = [[NSMutableDictionary alloc] init];
        self.layoutKits = layoutKits;
    }
    return layoutKits;
}

- (NSString *)cacheView:(UIView *)view
{
    NSAssert(view, @"设置的view必须有效");
    NSAssert1(view.superview && [view.superview isKindOfClass:[UIView class]], @"视图%@没有添加到父视图上", view);
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hashKey = [view hashKey];
    
    if (![self.layoutKits objectForKey:hashKey]) {
        [self.layoutKits setObject:view forKey:hashKey];
    }
    
    return hashKey;
}

@end

@implementation NSString (__AUUPrivate)

- (NSString *)matchWithPattern:(NSString *)pattern
{
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *textCheckingResult = [reg firstMatchInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    if (textCheckingResult && textCheckingResult.range.location != NSNotFound) {
        return [self substringWithRange:textCheckingResult.range];
    }
    return nil;
}

- (NSArray *)matchesWithPattern:(NSString *)pattern
{
    NSRegularExpression *reg = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
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

@implementation UIView (__AUUPrivate)

- (NSString *)hashKey
{
    return [NSString stringWithFormat:@"com_auu_vfl_%@%@", NSStringFromClass([self class]), @([self hash])];
}

@end
