//
//  UIView+AUUVFLLayout.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import "UIView+AUUVFLLayout.h"
#import "AUUVFLLayoutSpace.h"
#import "AUUVFLConstraints.h"
#import "AUUSubVFLConstraints.h"

@implementation UIView (AUUVFLLayout)

- (NSArray *(^)(UIEdgeInsets))edge
{
    return [^(UIEdgeInsets insets){
        return @[H.VFL[@(insets.left)][self][@(insets.right)].end(),
                 V.VFL[@(insets.top)][self][@(insets.bottom)].end()];
    } copy];
}

- (UIView *(^)(CGFloat, CGFloat))fixedSize
{
    return [^(CGFloat width, CGFloat height){
        H.VFL[self.VFL[@(width)]].endL();
        V.VFL[self.VFL[@(height)]].endL();
        return self;
    } copy];
}

@end
