//
//  AUUSubVFLConstraints.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/25.
//
//

#import <UIKit/UIKit.h>

NSString *priority(CGFloat length, CGFloat priority);
NSString *between(CGFloat minLength, CGFloat maxLength);

@interface AUUSubVFLConstraints : NSObject

- (instancetype)objectAtIndexedSubscript:(NSUInteger)idx;
- (instancetype)objectForKeyedSubscript:(id)key;

@property (copy, nonatomic) AUUSubVFLConstraints *(^priority)(CGFloat priority);

@end
