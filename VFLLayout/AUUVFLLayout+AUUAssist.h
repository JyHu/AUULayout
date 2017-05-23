//
//  AUUVFLLayout+AUUAssist.h
//  AUULayout
//
//  Created by JyHu on 2017/5/21.
//
//

#import <UIKit/UIKit.h>


/**
 发起自动布局的类，保存了需要自动布局的视图，和自动布局时第一个视图的属性
 */
@interface AUUEdgeLayout : NSObject

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

@property (copy, nonatomic, readonly) AUUSponsorParam *(^equal)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^greaterThan)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^lessThan)(id element);

@property (weak, nonatomic, readonly) UIView *bindingView;

@end

/**
 对AUUEdgeLayout的扩充方法，对基础属性做二次封装
 */
@interface AUUSponsorParam (AUUEdgeLayout)

@property (copy, nonatomic, readonly) AUUSponsorParam *(^topEqual)    (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^leftEqual)   (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^bottomEqual) (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^rightEqual)  (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerXEqual)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerYEqual)(id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^widthEqual)  (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^heightEqual) (id element);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^sizeEqual)   (CGSize size);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^centerEqual) (UIView *view);
@property (copy, nonatomic, readonly) AUUSponsorParam *(^edgeEqual)   (UIEdgeInsets insets);

@end

@interface AUUPassivelyParam : AUUEdgeLayout

@property (copy, nonatomic, readonly) AUUPassivelyParam *(^offset)(CGFloat offset);
@property (copy, nonatomic, readonly) AUUPassivelyParam *(^multiple)(CGFloat multiple);

@end


/**
 扩充UIView，用于设置被动比较的视图的对比属性
 */
@interface UIView (AUUAssist)

/**
 暂时的设计
 
 设置是否需要自动的使用新的布局属性去覆盖旧的布局属性，默认是yes，也就是说可以随便的写控制属性而不需要担心有重复冲突
 */
+ (void)setNeedAutoCoverRepetitionLayoutConstrants:(BOOL)autoCover;

/**
 暂时的设计
 
 全局的截取布局冲突的属性
 */
+ (void)setErrorLayoutConstrantsReporter:(void (^)(NSLayoutConstraint *oldLayoutConstrant, NSLayoutConstraint *newLayoutConstrant, NSLayoutAttribute layoutAttribute))reporter;

@property (retain, nonatomic, readonly) AUUSponsorParam *auu_layout;

@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_top;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_left;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_bottom;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_right;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_centerX;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_centerY;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_width;
@property (retain, nonatomic, readonly) AUUPassivelyParam *auu_height;

/**
 暂时的设计
 
 用于布局的父视图，比如:
 [self.view addSubView:view1];
 view1.... // 添加一系列的控制属性
 这时候可以用 self.view 使用这个属性，用于获取当前视图中重复的布局属性
 */
@property (copy, nonatomic) BOOL (^repetitionLayoutConstrantsReporter)(UIView *correlationView, NSLayoutConstraint *repetitionLayoutConstrant);

/**
 移除所有的布局控制属性
 */
- (void)removeAllConstrants;

/**
 获取根容器视图
 */
- (UIView *)rootResponderView;

@end
