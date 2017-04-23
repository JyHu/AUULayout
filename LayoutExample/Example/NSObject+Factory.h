//
//  NSObject+Factory.h
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import <UIKit/UIKit.h>

@interface NSObject (Factory)

@end

@interface UIView (Factory)

+ (instancetype)generateView;

@end

@interface UILabel (Factory)

+ (instancetype)generateWithTtile:(NSString *)title;
+ (instancetype)generate;

@end

@interface NSArray (Factory)

+ (NSArray *)mapNumber:(NSUInteger)num map:(id (^)(void))map;

@end

@interface UIColor (Factory)

+ (UIColor *)generate;

@end
