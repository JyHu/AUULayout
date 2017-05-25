//
//  AUUEdgeLayout.h
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//


#import <UIKit/UIKit.h>

/*
 使用方法：
 view1.auu_layout.top.equal(view2.auu_top.offset(10).multiple(1.5)).left......;
 可以级联着写下去
 
 跟VFL混合使用
 H[10][view1.auu_layout.left.equal(view2.auu_left).bindingView].cut();
 
 
 
 AUUSponsorParam.top = AUUSponsorParam.top * multiple + offset
 
 */


/**
 发起自动布局的类，保存了需要自动布局的视图，和自动布局时第一个视图的属性
 */
@interface AUUEdgeLayout : NSObject

@property (weak, nonatomic, readonly) UIView *bindingView;

@end

@interface AUUSponsorParam : AUUEdgeLayout

@property (retain, nonatomic, readonly) AUUSponsorParam *top;
@property (retain, nonatomic, readonly) AUUSponsorParam *left;
@property (retain, nonatomic, readonly) AUUSponsorParam *bottom;
@property (retain, nonatomic, readonly) AUUSponsorParam *right;
@property (retain, nonatomic, readonly) AUUSponsorParam *centerX;
@property (retain, nonatomic, readonly) AUUSponsorParam *centerY;
@property (retain, nonatomic, readonly) AUUSponsorParam *width;
@property (retain, nonatomic, readonly) AUUSponsorParam *height;
@property (retain, nonatomic, readonly) AUUSponsorParam *leading;
@property (retain, nonatomic, readonly) AUUSponsorParam *trailing;
@property (retain, nonatomic, readonly) AUUSponsorParam *lastBaseLine;
@property (retain, nonatomic, readonly) AUUSponsorParam *firstBaseLine NS_AVAILABLE_IOS(8_0);

/**
 element 可以是NSNumber、UIView、AUUPassivelyParam
 */
@property (copy, nonatomic, readonly) AUUSponsorParam *(^equal)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^greaterThan)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^lessThan)(id element);

@end

/**
 对AUUEdgeLayout的扩充方法，对基础属性做二次封装
 */
@interface AUUSponsorParam (AUUEdgeLayout)

@property (copy, nonatomic, readonly) AUUSponsorParam *(^topEqual)     (id element);     // == top.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^leftEqual)    (id element);     // == left.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^bottomEqual)  (id element);     // == bottom.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^rightEqual)   (id element);     // == right.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerXEqual) (id element);     // == centerX.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerYEqual) (id element);     // == centerY.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^leadingEqual) (id element);     // == leading.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^trailingEqual)(id element);     // == trailing.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^widthEqual)   (id element);     // == width.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^heightEqual)  (id element);     // == height.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^sizeEqual)    (CGSize size);    // == width.equal + height.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerEqual)  (UIView *view);   // == centerX.equal + centerY.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^edgeEqual)    (UIEdgeInsets insets);    // == top.equal + left.equal + bottom.equal + right.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^lastBaseLineEqual) (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^firstBaseLineEqual) (id element);

@end

@interface AUUPassivelyParam : AUUEdgeLayout

@property (copy, nonatomic, readonly) AUUPassivelyParam *(^offset)(CGFloat offset);
@property (copy, nonatomic, readonly) AUUPassivelyParam *(^multiple)(CGFloat multiple);

@end


/**
 扩充UIView，用于设置被动比较的视图的对比属性
 */
@interface UIView (AUUAssist)

@property (retain, nonatomic, readonly) AUUSponsorParam *auu_layout;

@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_top;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_left;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_bottom;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_right;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_centerX;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_centerY;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_leading;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_trailing;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_width;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_height;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_lastBaseLine;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_firstBaseLine;


@end
