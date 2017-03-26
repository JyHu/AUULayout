//
//  AUUVFLEdgeLayoutConstraints.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import "AUUVFLEdgeLayoutConstraints.h"

@implementation AUUVFLEdgeLayoutConstraints

- (AUUVFLEdgeLayoutConstraints *(^)(CGFloat))u_multiplier
{
    return [^(CGFloat multiplier){
//        self.pri_multiplier = multiplier;
        return self;
    } copy];
}

- (AUUVFLEdgeLayoutConstraints *(^)(CGFloat))u_constant
{
    return [^(CGFloat constant){
//        self.pri_constant = constant;
        return self;
    } copy];
}

@end
