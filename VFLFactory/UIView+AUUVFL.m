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




NSString const *H = @"H:";
NSString const *V = @"V:";




@implementation UIView (AUUVFL)

- (NSArray *(^)(UIEdgeInsets))edge
{
    return [^(UIEdgeInsets insets){
        NSAssert1(self.superview, @"没有设置父视图 %@", self);
        return @[H.interval(insets.left).nextTo(self).interval(insets.right).end,
                 V.interval(insets.top).nextTo(self).interval(insets.bottom).end];
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

- (NSArray *(^)(CGFloat, CGFloat))fixedSize
{
    return [^(CGFloat width, CGFloat height){
        return @[H.nextTo(self.lengthEqual(@(width))).endL,
                 V.nextTo(self.lengthEqual(@(height))).endL];
    } copy];
}

@end

@implementation UIView (AUUSub)

- (UIView *(^)(id))lengthEqual {
    return [^(id obj){
        if (![obj isKindOfClass:[UIView class]]) {
            NSAssert1([obj floatValue] > 0, @"设置宽高关系错误，对于一个视图的宽高只能是一个非负的值", self);
        }
        if (self.releation) {
            NSString *priority = [self.releation matchWithPattern:@"(?<=\\()@[\\d\\.]+(?=\\))"];
            NSAssert1(priority, @"设置宽高关系错误，在设置宽高前仅可以设置priority或者不做任何设置 %@", self);
            NSAssert2([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]], @"设置宽高关系错误，如果之前设置了priority优先级属性的话，这里只能设置指定的宽高值，不可设置成有关系的视图 self:%@ releation:%@", self, self.releation);
            self.releation = [NSString stringWithFormat:@"(%@%@)", obj, priority];
        } else {
            self.releation = [NSString stringWithFormat:@"(%@)", [obj isKindOfClass:[UIView class]] ? [obj hashKey] : obj];
        }
        return self;
    } copy];
}

- (UIView *(^)(CGFloat))lengthIs {
    return [^(CGFloat len){
        return self.lengthEqual(@(len));
    } copy];
}

- (UIView *(^)(UIView *))equalToV {
    return [^(UIView *view){
        self.releation = [NSString stringWithFormat:@"(==%@)", [view hashKey]];
        return self;
    } copy];
}

- (UIView *(^)(CGFloat))greaterThan {
    return [^(CGFloat wid){
        self.releation = [NSString stringWithFormat:@"(>=%@)", @(wid)];
        return self;
    } copy];
}

- (UIView *(^)(CGFloat))priority {
    return [^(CGFloat pri){
        if (self.releation) {
            NSString *length = [self.releation matchWithPattern:@"(?<=\\()[\\d\\.]+(?=\\))"];
            NSAssert1(length, @"设置优先级错误，在设置优先级前仅可以设置lengthEqual或者lengthIs或者不做任何设置 %@", self);
            self.releation = [NSString stringWithFormat:@"(%@@%@)", length, @(pri)];
        } else {
            self.releation = [NSString stringWithFormat:@"(@%@)", @(pri)];
        }
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
- (NSString *)Hori { return H; }
- (NSString *)Vert { return V; }
@end
@implementation UIViewController (AUUVFLStarting)
- (NSString *)Hori { return self.view.Hori; }
- (NSString *)Vert { return self.view.Vert; }
@end

