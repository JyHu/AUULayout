//
//  AUUVFLLayoutSpace.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import "AUUVFLLayoutSpace.h"
#import "AUUVFLPrivate.h"
#import <objc/runtime.h>

NSString *const H = @"H:";
NSString *const V = @"V:";

@implementation NSString (AUUVFL)

const char *__kVFLAssociatedKey = (void *)@"com.auu.vfl.__kVFLAssociatedKey";

- (void)setVFL:(AUUVFLConstraints *)VFL
{
    objc_setAssociatedObject(self, __kVFLAssociatedKey, VFL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AUUVFLConstraints *)VFL
{
    AUUVFLConstraints *VFLConstrants = objc_getAssociatedObject(self, __kVFLAssociatedKey);
    if (!VFLConstrants) {
        VFLConstrants = [[AUUVFLConstraints alloc] init];
        self.VFL = VFLConstrants;
    }
    
    VFLConstrants.VFLString = [self mutableCopy];
    
    return VFLConstrants;
}

@end

@implementation UIView (AUUVFL)

const char *__kSubVFLAssociatedKey = (void *)@"com.auu.vfl.__kSubVFLAssociatedKey";

- (void)setVFL:(AUUSubVFLConstraints *)VFL
{
    objc_setAssociatedObject(self, __kSubVFLAssociatedKey, VFL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AUUSubVFLConstraints *)VFL
{
    AUUSubVFLConstraints *VFLConstrants = objc_getAssociatedObject(self, __kSubVFLAssociatedKey);
    if (!VFLConstrants) {
        VFLConstrants = [[AUUSubVFLConstraints alloc] init];
        /*
         这里对于每个视图都新建了一个AUUSubVFLConstraints，暂时的想法是能够为每个视图存储VFL属性，用于之后的约束更新和删除
         现在呢只能在每次使用的时候都对他做清除
         */
        self.VFL = VFLConstrants;
    }
    
    VFLConstrants.sponsorView = self;
    VFLConstrants.relationSubVFL = [@"" mutableCopy];
    
    return VFLConstrants;
}

@end

@implementation AUUVFLLayoutSpace
@end
