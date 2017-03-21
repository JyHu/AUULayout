//
//  UILabel+Factory.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Factory)

+ (instancetype)generateWithTtile:(NSString *)title;
+ (instancetype)generate;

@end
