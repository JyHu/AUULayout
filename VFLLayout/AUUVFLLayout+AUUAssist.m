//
//  AUUVFLLayout+AUUAssist.m
//  AUULayout
//
//  Created by JyHu on 2017/5/21.
//
//

#import "AUUVFLLayout+AUUAssist.h"
#import "_AUUGlobalDataStorage.h"
#import <objc/runtime.h>

@implementation AUUEdgeLayout

@end

@interface AUUPassivelyParam ()

@property (weak, nonatomic) UIView *pri_bindingView;

@property (assign, nonatomic) NSLayoutAttribute pri_layoutAttribute;

@property (assign, nonatomic) CGFloat pri_multiple;

@property (assign, nonatomic) CGFloat pri_offset;

@end

@implementation AUUPassivelyParam

- (instancetype)init
{
    if (self = [super init]) {
        self.pri_multiple = 1.0;
        self.pri_offset = 0.0;
    }
    return self;
}

+ (AUUPassivelyParam *)paramWithView:(UIView *)view layoutAttribute:(NSLayoutAttribute)attribute
{
    AUUPassivelyParam *param = [[self alloc] init];
    param.pri_bindingView = view;
    param.pri_layoutAttribute = attribute;
    return param;
}

- (AUUPassivelyParam *(^)(CGFloat))offset
{
    return [^(CGFloat offset){
        self.pri_offset = offset;
        return self;
    } copy];
}

- (AUUPassivelyParam *(^)(CGFloat))multiple
{
    return [^(CGFloat multiple){
        self.pri_multiple = multiple;
        return self;
    } copy];
}

@end

@interface AUUSponsorParam ()

@property (weak, nonatomic) UIView *pri_bindingView;

@property (assign, nonatomic) NSLayoutAttribute pri_latestLayoutAttribute;


@end

@implementation AUUSponsorParam

+ (instancetype)edgeLayoutWithBindingView:(UIView *)view
{
    AUUSponsorParam *edgeLayout = [[self alloc] init];
    edgeLayout.pri_bindingView = view;
    return edgeLayout;
}

- (AUUEdgeLayout *)top
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeTop;
    return self;
}

- (AUUEdgeLayout *)left
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeLeft;
    return self;
}

- (AUUEdgeLayout *)bottom
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeBottom;
    return self;
}

- (AUUEdgeLayout *)right
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeRight;
    return self;
}

- (AUUEdgeLayout *)centerX
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeCenterX;
    return self;
}

- (AUUEdgeLayout *)centerY
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeCenterY;
    return self;
}

- (AUUEdgeLayout *)width
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeWidth;
    return self;
}

- (AUUEdgeLayout *)height
{
    self.pri_latestLayoutAttribute = NSLayoutAttributeHeight;
    return self;
}

- (AUUSponsorParam *(^)(id))equal
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationEqual releatedItem:element];
    } copy];
}

- (AUUSponsorParam *(^)(id))greaterThan
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationGreaterThanOrEqual releatedItem:element];
    } copy];
}

- (AUUSponsorParam *(^)(id))lessThan
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationLessThanOrEqual releatedItem:element];
    } copy];
}

- (AUUEdgeLayout *)layoutConstrantWithRelation:(NSLayoutRelation)relation releatedItem:(id)item
{
    self.pri_bindingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *layoutConstrant;
    
    if ([item isKindOfClass:[UIView class]]) {
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_latestLayoutAttribute
                                                       relatedBy:relation toItem:item attribute:self.pri_latestLayoutAttribute multiplier:1 constant:0];
    } else if ([item isKindOfClass:[NSNumber class]]) {
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_latestLayoutAttribute
                                                       relatedBy:relation toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1 constant:[item doubleValue]];
    } else if ([item isKindOfClass:[AUUPassivelyParam class]]) {
        AUUPassivelyParam *param = (AUUPassivelyParam *)item;
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_latestLayoutAttribute
                                                       relatedBy:relation toItem:param.pri_bindingView attribute:param.pri_layoutAttribute
                                                      multiplier:param.pri_multiple constant:param.pri_offset];
    } else {
        NSLog(@"错误的信息");
    }
    
    if (layoutConstrant) {
        /*
         暂时的设计
         
         这样的判断还是有逻辑问题
         */
        for (NSLayoutConstraint *oldLayoutConstrant in self.pri_bindingView.superview.constraints) {
            if ([oldLayoutConstrant.firstItem isEqual:self.pri_bindingView] &&
                oldLayoutConstrant.firstAttribute == layoutConstrant.firstAttribute &&
                oldLayoutConstrant.active) {
                
                if (self.pri_bindingView.superview.repetitionLayoutConstrantsReporter) {
                    oldLayoutConstrant.active = self.pri_bindingView.superview.repetitionLayoutConstrantsReporter(self.pri_bindingView, oldLayoutConstrant);
                } else if ([_AUUGlobalDataStorage sharedStorage].needAutoCoverRepetitionLayoutConstrants) {
                    oldLayoutConstrant.active = NO;
                }
                
                if ([_AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter) {
                    [_AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter(oldLayoutConstrant, layoutConstrant, layoutConstrant.firstAttribute);
                }
            }
            if (layoutConstrant.secondItem && oldLayoutConstrant.active &&
                [oldLayoutConstrant.secondItem isEqual:layoutConstrant.secondItem] &&
                oldLayoutConstrant.secondAttribute == layoutConstrant.secondAttribute) {
                
                if (self.pri_bindingView.superview.repetitionLayoutConstrantsReporter) {
                    oldLayoutConstrant.active = self.pri_bindingView.superview.repetitionLayoutConstrantsReporter(self.pri_bindingView, oldLayoutConstrant);
                } else if ([_AUUGlobalDataStorage sharedStorage].needAutoCoverRepetitionLayoutConstrants) {
                    oldLayoutConstrant.active = NO;
                }
                
                if ([_AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter) {
                    [_AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter(oldLayoutConstrant, layoutConstrant, layoutConstrant.secondAttribute);
                }
            }
        }
        
        [self.pri_bindingView.superview addConstraint:layoutConstrant];
    }
    
    return self;
}

- (UIView *)bindingView
{
    return self.pri_bindingView;
}

@end

@implementation AUUSponsorParam (AUUEdgeLayout)

- (AUUSponsorParam *(^)(id))topEqual
{
    return [^(id element){
        return self.top.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))leftEqual
{
    return [^(id element){
        return self.left.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))bottomEqual
{
    return [^(id element){
        return self.bottom.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))rightEqual
{
    return [^(id element){
        return self.right.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerXEqual
{
    return [^(id element){
        return self.centerX.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))centerYEqual
{
    return [^(id element){
        return self.centerY.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))widthEqual
{
    return [^(id element){
        return self.width.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(id))heightEqual
{
    return [^(id element){
        return self.height.equal(element);
    } copy];
}

- (AUUSponsorParam *(^)(CGSize))sizeEqual
{
    return [^(CGSize size){
        return self.widthEqual(@(size.width)).heightEqual(@(size.height));
    }copy];
}

- (AUUSponsorParam *(^)(UIView *))centerEqual
{
    return [^(UIView *view) {
        return self.centerEqual(view).centerYEqual(view);
    } copy];
}

- (AUUSponsorParam *(^)(UIEdgeInsets))edgeEqual
{
    return [^(UIEdgeInsets insets) {
        return self.topEqual(@(insets.top)).leftEqual(@(insets.left)).bottomEqual(@(insets.bottom)).rightEqual(@(insets.right));
    } copy];
}

@end

@implementation UIView (AUUAssist)

+ (void)setNeedAutoCoverRepetitionLayoutConstrants:(BOOL)autoCover
{
    [_AUUGlobalDataStorage sharedStorage].needAutoCoverRepetitionLayoutConstrants = autoCover;
}

+ (void)setErrorLayoutConstrantsReporter:(void (^)(NSLayoutConstraint *, NSLayoutConstraint *, NSLayoutAttribute))reporter
{
    [_AUUGlobalDataStorage sharedStorage].errorLayoutConstrantsReporter = reporter;
}

- (AUUSponsorParam *)auu_layout
{
    return [AUUSponsorParam edgeLayoutWithBindingView:self];
}

- (AUUPassivelyParam *)auu_top
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (AUUPassivelyParam *)auu_left
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (AUUPassivelyParam *)auu_bottom
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (AUUPassivelyParam *)auu_right
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (AUUPassivelyParam *)auu_centerX
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (AUUPassivelyParam *)auu_centerY
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (AUUPassivelyParam *)auu_width
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (AUUPassivelyParam *)auu_height
{
    return [AUUPassivelyParam paramWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

const char *__repetitionLayoutConstrantsReporterAssociatedKey = (void *)@"com.auu.__repetitionLayoutConstrantsReporterAssociatedKey";

- (void)setRepetitionLayoutConstrantsReporter:(BOOL (^)(UIView *, NSLayoutConstraint *))repetitionLayoutConstrantsReporter
{
    objc_setAssociatedObject(self, __repetitionLayoutConstrantsReporterAssociatedKey, repetitionLayoutConstrantsReporter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UIView *, NSLayoutConstraint *))repetitionLayoutConstrantsReporter
{
    return objc_getAssociatedObject(self, __repetitionLayoutConstrantsReporterAssociatedKey);
}

- (void)removeAllConstrants
{
    for (NSLayoutConstraint *layoutConstrant in self.constraints) {
        layoutConstrant.active = NO;
    }
    
    [self removeConstraints:self.constraints];
}

- (UIView *)rootResponderView
{
    UIResponder *rootResponder = self;
    while (rootResponder.nextResponder) {
        rootResponder = rootResponder.nextResponder;
        if ([rootResponder isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    
    return rootResponder ? ([rootResponder isKindOfClass:[UIViewController class]] ? [(UIViewController *)rootResponder view] : (UIView *)rootResponder) : nil;
}

@end


