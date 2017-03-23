//
//  AUULayoutAttribute.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import "AUULayoutAttribute.h"
#import "AUULayoutAttribute+AUUPrivate.h"

@implementation AUULayoutAttribute

- (AUULayoutAttribute *(^)(CGFloat))u_multiplier
{
    return [^(CGFloat multiplier){
        self.multiplier = multiplier;
        return self;
    } copy];
}

- (AUULayoutAttribute *(^)(CGFloat))u_constant
{
    return [^(CGFloat constant){
        self.constant = constant;
        return self;
    } copy];
}

@end
