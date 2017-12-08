//
//  _AUULayoutAssistant.h
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (AUUAssistant)

- (BOOL)similarTo:(NSLayoutConstraint *)layoutConstrant;

@end

@interface AUUGlobalDataStorage : NSObject

+ (instancetype)sharedStorage;

@property (assign, nonatomic) BOOL needDebugLod;

@property (assign, nonatomic) BOOL needAutoCoverRepetitionLayoutConstrants;

@property (copy, nonatomic) void (^errorLayoutConstrantsReporter)(NSLayoutConstraint *oldLayoutConstrant, NSLayoutConstraint *newLayoutConstrant);

@end

@interface NSArray (__AUUPrivate)

- (NSArray *)map:(id (^)(id obj, NSUInteger index))map checkClass:(Class)cls;

@end

