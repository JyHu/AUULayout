//
//  AUULayoutAssistant.m
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import "AUULayoutAssistant.h"
#import "_AUULayoutAssistant.h"
#import <objc/runtime.h>

@implementation AUULayoutAssistant

+ (void)enableDebugLog:(BOOL)enable
{
    [AUUGlobalDataStorage sharedStorage].needDebugLod = enable;
}

@end

@implementation UIView (AUUAssistant)

+ (void)setNeedAutoCoverRepetitionLayoutConstrants:(BOOL)autoCover {
    [AUUGlobalDataStorage sharedStorage].needAutoCoverRepetitionLayoutConstrants = autoCover;
}

+ (void)setErrorLayoutConstrantsReporter:(void (^)(NSLayoutConstraint *, NSLayoutConstraint *))reporter {
    [AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter = reporter;
}

const char *__repetitionLayoutConstrantsReporterAssociatedKey = (void *)@"com.auu.__repetitionLayoutConstrantsReporterAssociatedKey";

- (void)setRepetitionLayoutConstrantsReporter:(BOOL (^)(UIView *, NSLayoutConstraint *))repetitionLayoutConstrantsReporter {
    objc_setAssociatedObject(self, __repetitionLayoutConstrantsReporterAssociatedKey, repetitionLayoutConstrantsReporter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIView *, NSLayoutConstraint *))repetitionLayoutConstrantsReporter {
    return objc_getAssociatedObject(self, __repetitionLayoutConstrantsReporterAssociatedKey);
}

- (void)removeAllConstrants {
    for (NSLayoutConstraint *layoutConstrant in self.constraints) {
        layoutConstrant.active = NO;
    }
    
    [self removeConstraints:self.constraints];
}

- (UIView *)rootResponderView {
    UIResponder *rootResponder = self;
    while (rootResponder.nextResponder) {
        rootResponder = rootResponder.nextResponder;
        if ([rootResponder isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    
    return rootResponder ? ([rootResponder isKindOfClass:[UIViewController class]] ? [(UIViewController *)rootResponder view] : (UIView *)rootResponder) : nil;
}


@end
