//
//  AUULayoutAssistant.h
//  AUULayout
//
//  Created by JyHu on 2017/5/25.
//
//

#import <UIKit/UIKit.h>

@interface AUULayoutAssistant : NSObject

@end


@interface UIView (AUUAssistant)

/**
 设置是否需要自动的使用新的布局属性去覆盖旧的布局属性，默认是yes，也就是说可以随便的写控制属性而不需要担心有重复冲突
 这个方法是全局的，默认是自动的覆盖
 */
+ (void)setNeedAutoCoverRepetitionLayoutConstrants:(BOOL)autoCover;

/**
 全局的截取布局冲突的属性
 */
+ (void)setErrorLayoutConstrantsReporter:(void (^)(NSLayoutConstraint *oldLayoutConstrant, NSLayoutConstraint *newLayoutConstrant))reporter;

/**
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
