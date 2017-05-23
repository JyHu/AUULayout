//
//  _AUUGlobalDataStorage.m
//  AUULayout
//
//  Created by JyHu on 2017/5/23.
//
//

#import "_AUUGlobalDataStorage.h"

@implementation _AUUGlobalDataStorage

+ (instancetype)sharedStorage
{
    static _AUUGlobalDataStorage *globalDataStorage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalDataStorage = [[_AUUGlobalDataStorage alloc] init];
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
