//
//  UIView+AUUVFL.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "UIView+AUUVFL.h"
#import "NSObject+AUUVFLPrivate.h"
#import "NSString+AUUVFL.h"
#import "UIView+AUUVFLEdge.h"

@implementation UIView (AUUVFL)

- (NSArray *(^)(UIEdgeInsets))edge
{
    return [^(UIEdgeInsets insets){
        NSAssert1(self.superview, @"没有设置父视图 %@", self);
        return @[self.superview.Hori.interval(insets.left).nextTo(self).interval(insets.right).end,
                 self.superview.Vert.interval(insets.top).nextTo(self).interval(insets.bottom).end];
    } copy];
}

- (UIView *(^)())alignmentCenter
{
    return [^(){
        NSAssert1(self.superview, @"没有设置父视图 %@", self);
        self.centerXEqual(self.superview.u_centerX);
        self.centerYEqual(self.superview.u_centerY);
        
        return self;
    } copy];
}

- (NSArray *(^)(CGSize))fixedSize
{
    return [^(CGSize size){
        return @[self.superview.Hori.nextTo(self.lengthEqual(@(size.width))).endL,
                 self.superview.Vert.nextTo(self.lengthEqual(@(size.height))).endL];
    } copy];
}

@end

@implementation UIView (AUUSub)

- (UIView *(^)(id))lengthEqual {
    return [^(id obj){
        self.releation = [NSString stringWithFormat:@"(%@)", [obj isKindOfClass:[UIView class]] ? [self addHashKey:obj] : obj];
        return self;
    } copy];
}

- (UIView *(^)(UIView *))equalToV {
    return [^(UIView *view){
        self.releation = [NSString stringWithFormat:@"(==%@)", [self.superview addHashKey:view]];
        return self;
    } copy];
}

- (UIView *(^)(CGFloat))greaterThan {
    return [^(CGFloat wid){
        self.releation = [NSString stringWithFormat:@"(>=%@)", @(wid)];
        return self;
    } copy];
}

- (UIView *(^)(CGFloat, CGFloat))priority {
    return [^(CGFloat wid, CGFloat pri){
        self.releation = [NSString stringWithFormat:@"(%@@%@)", @(wid), @(pri)];
        return self;
    } copy];
}

- (UIView *(^)(CGFloat, CGFloat))between {
    return [^(CGFloat min, CGFloat max){
        self.releation = [NSString stringWithFormat:@"(>=%@,<=%@)", @(min), @(max)];
        return self;
    } copy];
}

@end

@implementation UIView (AUUVFLStarting)

- (NSString *)Hori {
    NSString *H = @"H:";
    H.base = self;
    return H;
}

- (NSString *)Vert {
    NSString *V = @"V:";
    V.base = self;
    return V;
}

@end

@implementation UIViewController (AUUVFLStarting)

- (NSString *)Hori {
    return self.view.Hori;
}

- (NSString *)Vert {
    return self.view.Vert;
}

@end

