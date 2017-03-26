//
//  AUUVFLEdgeLayoutConstraints.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <UIKit/UIKit.h>

@class AUUVFLEdgeLayoutConstraints;

@interface AUUVFLEdgeLayoutConstraints : NSObject

/**
 设置间距
 */
@property (retain, nonatomic, readonly) AUUVFLEdgeLayoutConstraints *(^constant)(CGFloat constant);

/**
 设置相对比例
 */
@property (retain, nonatomic, readonly) AUUVFLEdgeLayoutConstraints *(^multiplier)(CGFloat multiplier);

@end
