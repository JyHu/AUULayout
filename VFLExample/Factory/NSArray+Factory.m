//
//  NSArray+Factory.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "NSArray+Factory.h"

@implementation NSArray (Factory)

+ (NSArray *)mapNumber:(NSUInteger)num map:(id (^)(void))map
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < num; i ++) {
        [res addObject:map()];
    }
    return res;
}

@end
