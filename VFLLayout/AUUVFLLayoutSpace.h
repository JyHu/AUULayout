//
//  AUUVFLLayoutSpace.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <UIKit/UIKit.h>

extern NSString *const H;
extern NSString *const V;

@class AUUVFLConstraints;

@interface NSString (AUUVFL)

@property (retain, nonatomic) AUUVFLConstraints *VFL;

@end

@class AUUSubVFLConstraints;

@interface UIView (AUUVFL)

@property (retain, nonatomic) AUUSubVFLConstraints *VFL;

@end





@interface AUUVFLLayoutSpace : NSObject
@end
