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

- (AUULayoutAttribute *(^)(CGFloat))u_margin
{
    return [^(CGFloat margin){
        self.margin = margin;
        return self;
    } copy];
}

@end
