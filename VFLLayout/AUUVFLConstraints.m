//
//  AUUVFLConstraints.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/25.
//
//

#import "AUUVFLConstraints.h"
#import "AUUVFLPrivate.h"
#import "AUUVFLLayoutSpace.h"
#import "AUUSubVFLConstraints.h"

@implementation AUUVFLConstraints

- (NSString *(^)())end
{
    return [^(){
        [self.VFLString appendString:@"|"];
        return self.endL();
    } copy];;
}

- (NSString *(^)())endL
{
    return [^(){
        
        [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:self.VFLString options:NSLayoutFormatDirectionMask metrics:nil views:self.layoutKits]];
        
        return self.VFLString;
    } copy];
}

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self[@(idx)];
}

- (instancetype)objectForKeyedSubscript:(id)key
{
    if ([key isKindOfClass:[NSNumber class]]) {
        [self.VFLString appendFormat:@"%@-%@-", (self.VFLString && self.VFLString.length == 2 ? @"|" : @""), key];
    } else {
        if ([key isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)key;
            [self.VFLString appendFormat:@"[%@%@]", [self cacheView:key], view.VFL.relationSubVFL];
        } else if ([key isKindOfClass:[AUUSubVFLConstraints class]]) {
            AUUSubVFLConstraints *subConstrants = (AUUSubVFLConstraints *)key;
            [self.layoutKits addEntriesFromDictionary:subConstrants.layoutKits];
            [self.VFLString appendFormat:@"[%@%@]", [self cacheView:subConstrants.sponsorView], subConstrants.relationSubVFL];
        }
    }
    
    return self;
}

@end
