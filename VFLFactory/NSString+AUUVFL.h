//
//  NSString+AUUVFL.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (AUUVFL)

/**
 和下一个view的间距
 */
@property (copy, nonatomic, readonly) NSString *(^interval)(CGFloat len);

/**
 相邻的下一个view
 */
@property (copy, nonatomic, readonly) NSString *(^nextTo)(UIView *view);

/**
 标准的间距，8      H:|-0-[view]-[label]-0-|
 */
@property (retain, nonatomic, readonly) NSString *standardInterval;

/**
 以父视图即'|'结尾，比如  H:|-0-[view]-0-|
 */
@property (retain, nonatomic, readonly) NSString *end;

/**
 以最后一个视图结尾，比如  H:|-0-[view(label)]-[label(200)]
 */
@property (retain, nonatomic, readonly) NSString *endL;

@end
