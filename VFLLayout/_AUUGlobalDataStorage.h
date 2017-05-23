//
//  _AUUGlobalDataStorage.h
//  AUULayout
//
//  Created by JyHu on 2017/5/23.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/NSLayoutConstraint.h>

@interface _AUUGlobalDataStorage : NSObject

+ (instancetype)sharedStorage;

@property (assign, nonatomic) BOOL needAutoCoverRepetitionLayoutConstrants;

@property (copy, nonatomic) void (^errorLayoutConstrantsReporter)(NSLayoutConstraint *oldLayoutConstrant, NSLayoutConstraint *newLayoutConstrant, NSLayoutAttribute layoutAttribute);

@end
