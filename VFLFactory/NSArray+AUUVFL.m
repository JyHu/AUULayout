//
//  NSArray+AUUVFL.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "NSArray+AUUVFL.h"
#import "UIView+AUUVFL.h"
#import "NSString+AUUVFL.h"

@implementation NSArray (AUUVFL)

- (NSArray *(^)(AUULayoutDirection))avgLayoutD
{
    return [^(AUULayoutDirection direction){
        return self.avgLayoutDE(direction, UIEdgeInsetsZero);
    } copy];
}

- (NSArray *(^)(AUULayoutDirection, UIEdgeInsets))avgLayoutDE
{
    return [^(AUULayoutDirection direction, UIEdgeInsets insets){
        return self.avgLayoutDEM(direction, insets, 0);
    } copy];
}

- (NSArray *(^)(AUULayoutDirection, CGFloat))avgLayoutDM
{
    return [^(AUULayoutDirection direction, CGFloat margin){
        return self.avgLayoutDEM(direction, UIEdgeInsetsZero, margin);
    } copy];
}

- (NSArray *(^)(AUULayoutDirection, UIEdgeInsets, CGFloat))avgLayoutDEM
{
    return [^(AUULayoutDirection direction, UIEdgeInsets insets, CGFloat margin){
        NSAssert1(margin >= 0, @"设置间距非法 %@", self);
        NSMutableArray *vfls = [[NSMutableArray alloc] initWithCapacity:self.count + 1];
        
        // 如果只有一个元素，那么直接就能设置其布局的vfl
        if (self.count == 1) {
            UIView *view = self.firstObject;
            NSAssert1(view.superview, @"没有添加到父视图 %@", view);
            return @[view.superview.Hori.interval(insets.left).nextTo(view).interval(insets.right).end,
                     view.superview.Vert.interval(insets.top).nextTo(view).interval(insets.bottom).end];
        }
        // 如有多个元素，需要遍历去设置其横竖的vfl
        else if (self.count >= 2) {
            NSString *LVFL;     // 最长的一个vfl，需要遍历完最后一个才能完结
            UIView *lastView;   // 记录上一个视图，用于设置前后两个视图的宽度或者高度相等
            BOOL isHorizontal = direction == AUULayoutDirectionHorizontal;
            for (NSInteger i = 0; i < self.count; i ++) {
                UIView *view = [self objectAtIndex:i];
                NSAssert1(view.superview, @"没有添加到父视图 %@", view);
                
                // 设置较短的vfl，只需要设置好上下、或左右即可的视图
                if (isHorizontal) {
                    [vfls addObject:view.superview.Vert.interval(insets.top).nextTo(view).interval(insets.bottom).end];
                } else {
                    [vfls addObject:view.superview.Hori.interval(insets.left).nextTo(view).interval(insets.right).end];
                }
                
                // 如果是第一个，就使用这个视图去初始化最长的vfl
                if (i == 0) {
                    LVFL = (isHorizontal ? view.superview.Hori : view.superview.Vert).interval(isHorizontal ? insets.left : insets.top).nextTo(view);
                    lastView = view;
                } else {
                    // 其他情况下需要补上与上一个视图的间距
                    LVFL = LVFL.interval(margin).nextTo(view.lengthEqual(lastView));
                    
                    if (i == self.count - 1) {
                        // 如果是最后一个视图的话，就完结这个vfl
                        LVFL = LVFL.interval(isHorizontal ? insets.right : insets.bottom).end;
                    }
                }
            }
            
            [vfls addObject:LVFL];
        }
        return (NSArray *)vfls;
    } copy];
}

- (NSArray *(^)(CGFloat, CGFloat, CGFloat))absHoriLayout
{
    return [^(CGFloat width, CGFloat height, CGFloat margin){
        return self.absLayout(AUULayoutDirectionHorizontal, width, height, margin);
    } copy];
}

- (NSArray *(^)(CGFloat, CGFloat, CGFloat))absVertLayout
{
    return [^(CGFloat width, CGFloat height, CGFloat margin){
        return self.absLayout(AUULayoutDirectionVertical, width, height, margin);
    } copy];
}

- (NSArray *(^)(AUULayoutDirection, CGFloat, CGFloat, CGFloat))absLayout
{
    return [^(AUULayoutDirection direction, CGFloat width, CGFloat height, CGFloat margin){
        NSMutableArray *vfls = [[NSMutableArray alloc] initWithCapacity:self.count + 1];
        NSAssert1(margin >= 0, @"设置间距非法 %@", self);
        BOOL isHorizontal = direction == AUULayoutDirectionHorizontal;
        
        // 如果只有一个视图，那么可以直接对其设置vfl布局属性
        if (self.count == 1) {
            UIView *view = self.firstObject;
            NSAssert1(view.superview, @"没有添加到父视图 %@", view);
            
            if (width) {
                [vfls addObject:view.superview.Hori.nextTo(view.lengthEqual(@(width))).endL];
            } else {
                [vfls addObject:view.superview.Hori.nextTo(view).end];
            }
            if (height) {
                [vfls addObject:view.superview.Vert.nextTo(view.lengthEqual(@(height))).endL];
            } else {
                [vfls addObject:view.superview.Vert.nextTo(view).end];
            }
        }
        else if (self.count >= 2)
        {
            NSString *LVFL;
            UIView *lastView;
            for (NSInteger i = 0; i < self.count; i ++) {
                UIView *view = [self objectAtIndex:i];
                NSAssert1(view.superview, @"没有添加到父视图 %@", view);
                if (isHorizontal) {
                    NSAssert1(width > 0, @"横向布局的时候宽度设置非法 %@", view);
                    // 如果是横向布局的话，这时候如果设置了高度，那么就设定其指定的高度，否则就会在纵向填充满父视图
                    if (height > 0) {
                        [vfls addObject:view.superview.Vert.interval(0).nextTo(view.lengthEqual(@(height))).endL];
                    } else {
                        [vfls addObject:view.superview.Vert.interval(0).nextTo(view).end];
                    }
                } else {
                    NSAssert1(height > 0, @"纵向布局的时候高度设置非法 %@", view);
                    // 如果是纵向布局的话，这时候如果设置了宽度，那么就设定其指定的宽度，否则就会在横向填充满其父视图
                    if (width > 0) {
                        [vfls addObject:view.superview.Hori.interval(0).nextTo(view.lengthEqual(@(width))).endL];
                    } else {
                        [vfls addObject:view.superview.Hori.interval(0).nextTo(view).end];
                    }
                }
                
                // 在第一个视图的时候初始化最长的VFL
                if (i == 0) {
                    if (isHorizontal) {
                        LVFL = view.superview.Hori.interval(0).nextTo(view.lengthEqual(@(width)));
                    } else {
                        LVFL = view.superview.Vert.interval(0).nextTo(view.lengthEqual(@(height)));
                    }
                    lastView = view;
                } else {
                    LVFL = LVFL.interval(margin).nextTo(view.lengthEqual(@(isHorizontal ? width : height)));
                    if (i == self.count - 1) {
                        LVFL = LVFL.endL;
                    }
                }
            }
            [vfls addObject:LVFL];
        }
        
        return vfls;
    } copy];
}

@end
