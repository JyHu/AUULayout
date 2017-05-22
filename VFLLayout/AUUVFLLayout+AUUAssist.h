//
//  AUUVFLLayout+AUUAssist.h
//  AUULayout
//
//  Created by JyHu on 2017/5/21.
//
//

#import <UIKit/UIKit.h>

@interface AUUEdgeLayoutParam : NSObject

@property (copy, nonatomic, readonly) AUUEdgeLayoutParam *(^offset)(CGFloat offset);
@property (copy, nonatomic, readonly) AUUEdgeLayoutParam *(^multiple)(CGFloat multiple);

@end

@interface AUUEdgeLayout : NSObject

@property (retain, nonatomic, readonly) AUUEdgeLayout *top;
@property (retain, nonatomic, readonly) AUUEdgeLayout *left;
@property (retain, nonatomic, readonly) AUUEdgeLayout *bottom;
@property (retain, nonatomic, readonly) AUUEdgeLayout *right;
@property (retain, nonatomic, readonly) AUUEdgeLayout *centerX;
@property (retain, nonatomic, readonly) AUUEdgeLayout *centerY;
@property (retain, nonatomic, readonly) AUUEdgeLayout *width;
@property (retain, nonatomic, readonly) AUUEdgeLayout *height;

@property (copy, nonatomic, readonly) AUUEdgeLayout *(^equal)(id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^greaterThan)(id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^lessThan)(id element);

@property (weak, nonatomic, readonly) UIView *bindingView;

@end

@interface AUUEdgeLayout (AUUEdgeLayout)

@property (copy, nonatomic, readonly) AUUEdgeLayout *(^topEqual)    (id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^leftEqual)   (id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^bottomEqual) (id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^rightEqual)  (id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^centerXEqual)(id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^centerYEqual)(id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^widthEqual)  (id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^heightEqual) (id element);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^sizeEqual)   (CGSize size);
@property (copy, nonatomic, readonly) AUUEdgeLayout *(^centerEqual) (UIView *view);

@end

@interface UIView (AUUAssist)

@property (retain, nonatomic, readonly) AUUEdgeLayout *auu_layout;

@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_top;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_left;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_bottom;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_right;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_centerX;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_centerY;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_width;
@property (retain, nonatomic, readonly) AUUEdgeLayoutParam *auu_height;

@end
