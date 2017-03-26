//
//  AUUVFLConstraints.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/25.
//
//

#import <Foundation/Foundation.h>

@interface AUUVFLConstraints : NSObject

@property (copy, nonatomic) NSString * (^end)();
@property (copy, nonatomic) NSString * (^endL)();

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;
- (instancetype)objectForKeyedSubscript:(id)key;

@end
