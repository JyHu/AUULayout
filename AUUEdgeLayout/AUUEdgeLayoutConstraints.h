//
//  AUUEdgeLayoutConstraints.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/26.
//
//

#import <Foundation/Foundation.h>

@class AUUEdgeSubLayoutConstraints;

@interface AUUEdgeLayoutConstraints : NSObject

@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^topEqual)    (AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^leftEqual)   (AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^bottomEqual) (AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^rightEqual)  (AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^widthEqual)  (AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^heightEqual) (AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^centerXEqual)(AUUEdgeSubLayoutConstraints *layoutAttribute);
@property (copy, nonatomic, readonly) AUUEdgeLayoutConstraints *(^centerYEqual)(AUUEdgeSubLayoutConstraints *layoutAttribute);

@end

@interface AUUEdgeSubLayoutConstraints : NSObject

@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *top;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *left;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *bottom;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *right;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *width;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *height;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *centerX;
@property (retain, nonatomic, readonly) AUUEdgeSubLayoutConstraints *centerY;

@end
