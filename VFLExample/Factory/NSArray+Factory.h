//
//  NSArray+Factory.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (Factory)

+ (NSArray *)mapNumber:(NSUInteger)num map:(id (^)(void))map;

@end
