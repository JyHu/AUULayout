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
        
        if (self.count == 1) {
            UIView *view = self.firstObject;
            NSAssert1(view.superview, @"没有添加到父视图 %@", view);
            return @[view.superview.Hori.interval(insets.left).nextTo(view).interval(insets.right).end,
                     view.superview.Vert.interval(insets.top).nextTo(view).interval(insets.bottom).end];
        } else if (self.count >= 2) {
            NSString *LVFL;
            UIView *lastView;
            BOOL isHorizontal = direction == AUULayoutDirectionHorizontal;
            for (NSInteger i = 0; i < self.count; i ++) {
                UIView *view = [self objectAtIndex:i];
                NSAssert1(view.superview, @"没有添加到父视图 %@", view);
                if (isHorizontal) {
                    [vfls addObject:view.superview.Vert.interval(insets.top).nextTo(view).interval(insets.bottom).end];
                } else {
                    [vfls addObject:view.superview.Hori.interval(insets.left).nextTo(view).interval(insets.right).end];
                }
                if (i == 0) {
                    LVFL = (isHorizontal ? view.superview.Hori : view.superview.Vert).interval(isHorizontal ? insets.left : insets.top).nextTo(view);
                    lastView = view;
                } else {
                    LVFL = LVFL.interval(margin).nextTo(view.lengthEqual(lastView));
                    
                    if (i == self.count - 1) {
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
        else
        {
            NSString *LVFL;
            UIView *lastView;
            BOOL isHorizontal = direction == AUULayoutDirectionHorizontal;
            for (NSInteger i = 0; i < self.count; i ++) {
                UIView *view = [self objectAtIndex:i];
                NSAssert1(view.superview, @"没有添加到父视图 %@", view);
                if (isHorizontal) {
                    NSAssert1(width > 0, @"横向布局的时候宽度设置非法 %@", view);
                    if (height > 0) {
                        [vfls addObject:view.superview.Vert.interval(0).nextTo(view.lengthEqual(@(height))).endL];
                    } else {
                        [vfls addObject:view.superview.Vert.interval(0).nextTo(view).end];
                    }
                } else {
                    NSAssert1(height > 0, @"纵向布局的时候高度设置非法 %@", view);
                    if (width > 0) {
                        [vfls addObject:view.superview.Hori.interval(0).nextTo(view.lengthEqual(@(width))).endL];
                    } else {
                        [vfls addObject:view.superview.Hori.interval(0).nextTo(view).end];
                    }
                }
                
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
