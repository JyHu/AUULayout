//
//  UIView+AUUVFLEdge.h
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import <UIKit/UIKit.h>



/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 这里的两个category里的方法是用来描述两个视图间的相对关系。
 
 AUUVFLEdgeEqual 发起对齐方式的比较
 AUUVFLEdge      返回被比较视图的被比较的位置
 
 eg：
 
 
 [self.Vert.nextTo(view1.topEqual(view2.u_top)) end];
 
 在这里使用topEqual来描述view1的顶部与view2的顶部对齐
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */




@class AUULayoutAttribute;

/*
 子视图调用的比较方法，用于设置其边界属性的对齐
 */
@interface UIView (AUUVFLEdgeEqual)

@property (copy, nonatomic, readonly) UIView *(^topEqual)    (AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^leftEqual)   (AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^bottomEqual) (AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^rightEqual)  (AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^widthEqual)  (AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^heightEqual) (AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^centerXEqual)(AUULayoutAttribute *layoutAttribute);
@property (copy, nonatomic, readonly) UIView *(^centerYEqual)(AUULayoutAttribute *layoutAttribute);

@end

/*
 被动比较的视图调用的方法，用于返回对齐的属性
 */
@interface UIView (AUUVFLEdge)

@property (retain, nonatomic, readonly) AUULayoutAttribute *u_top;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_left;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_bottom;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_right;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_width;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_height;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_centerX;
@property (retain, nonatomic, readonly) AUULayoutAttribute *u_centerY;

@end
