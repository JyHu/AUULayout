//
//  AUUEdgeLayout.h
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

/*
 view1.attr1 = view2.attr2 * multiplier + constant
 
 
 view1，发起约束请求的视图，在这里需要添加约束，需要调用 view1.auu_layout ，在[UIView (AUUSponsorParam)]中定义的
 attr1，要设置的视图的约束属性，即 AUUSponsorParam 里的一系列位置属性
 view2，被动比较的视图
 attr2，被动比较视图的约束属性，在[AUUSponsorParam]中定义
 multiplier，在AUUPassivelyParam中设置
 constant，在AUUPassivelyParam中设置
 
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
@property (retain, nonatomic, readonly) AUUSponsorParam *lastBaseline;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
@property (retain, nonatomic, readonly) AUUSponsorParam *firstBaseline NS_AVAILABLE_IOS(8_0);
#endif

/**
 element 可以是NSNumber、UIView、AUUPassivelyParam
 */
@property (copy, nonatomic, readonly) AUUSponsorParam *(^equal)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^greaterThan)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^lessThan)(id element);

@end

@interface UIView (AUUSponsorParam)

@property (retain, nonatomic, readonly) AUUSponsorParam *auu_layout;

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
@property (copy, nonatomic, readonly) AUUSponsorParam *(^sizeEqual)    (id element);     // == width.equal + height.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerEqual)  (id element);     // == centerX.equal + centerY.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^lastBaselineEqual) (id element);// == lastBaseline.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^edgeEqual)    (UIEdgeInsets insets);    // == top.equal + left.equal + bottom.equal + right.equal

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
@property (copy, nonatomic, readonly) AUUSponsorParam *(^firstBaselineEqual) (id element)   NS_AVAILABLE_IOS(8_0);
#endif

@end

@interface AUUPassivelyParam : AUUEdgeLayout

@property (copy, nonatomic, readonly) AUUPassivelyParam *(^offset)(CGFloat offset);
@property (copy, nonatomic, readonly) AUUPassivelyParam *(^multiple)(CGFloat multiple);

@end


/**
 扩充UIView，用于设置被动比较的视图的对比属性
 */
@interface UIView (AUUPassivelyParam)

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
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_lastBaseline;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_firstBaseline NS_AVAILABLE_IOS(8_0);
#endif

@end

#ifndef kUIViewUsePihyLayoutEqual
#define kUIViewUsePihyLayoutEqual 0
#endif
#if kUIViewUsePihyLayoutEqual

/*
 为UIView扩充的方法，UIView.topEqual == UIView.auu_layout.topEqual
 相当于是少了中间的一步
 
 在这里做的扩充是为了在写约束条件的时候可以少写一点点，如果这里的扩充跟你的project里有冲突的话，
 可以在 import 这个库的前面定义这么一个宏 
 #ifndef kUIViewUsePihyLayoutEqual 0
 这样就可以注销这里的扩充，这时候需要用 UIView.auu_layout... 去添加约束
 */

@interface UIView (AUUPihyAssistant)

@property (copy, nonatomic, readonly) AUUSponsorParam *(^topEqual)     (id element);     // == auu_layout.top.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^leftEqual)    (id element);     // == auu_layout.left.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^bottomEqual)  (id element);     // == auu_layout.bottom.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^rightEqual)   (id element);     // == auu_layout.right.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerXEqual) (id element);     // == auu_layout.centerX.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerYEqual) (id element);     // == auu_layout.centerY.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^leadingEqual) (id element);     // == auu_layout.leading.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^trailingEqual)(id element);     // == auu_layout.trailing.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^widthEqual)   (id element);     // == auu_layout.width.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^heightEqual)  (id element);     // == auu_layout.height.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^sizeEqual)    (id element);     // == auu_layout.width.equal + height.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerEqual)  (id element);     // == auu_layout.centerX.equal + centerY.equal
// == auu_layout.top.equal + auu_layout.left.equal + auu_layout.bottom.equal + auu_layout.right.equal
@property (copy, nonatomic, readonly) AUUSponsorParam *(^edgeEqual)    (UIEdgeInsets insets);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^lastBaselineEqual) (id element);

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000
@property (copy, nonatomic, readonly) AUUSponsorParam *(^firstBaselineEqual) (id element)   NS_AVAILABLE_IOS(8_0);
#endif

@end

#endif
