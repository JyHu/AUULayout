//
//  AUUVFLLayout+AUUAssist.m
//  AUULayout
//
//  Created by JyHu on 2017/5/21.
//
//

#import "AUUVFLLayout+AUUAssist.h"



@interface AUUEdgeLayoutParam ()

@property (weak, nonatomic) UIView *pri_bindingView;

@property (assign, nonatomic) NSLayoutAttribute pri_layoutAttribute;

@property (assign, nonatomic) CGFloat pri_multiple;

@property (assign, nonatomic) CGFloat pri_offset;

@end

@implementation AUUEdgeLayoutParam

- (instancetype)init
{
    if (self = [super init]) {
        self.pri_multiple = 1.0;
        self.pri_offset = 0.0;
    }
    return self;
}

+ (AUUEdgeLayoutParam *)paramWithView:(UIView *)view layoutAttribute:(NSLayoutAttribute)attribute
{
    AUUEdgeLayoutParam *param = [[self alloc] init];
    param.pri_bindingView = view;
    param.pri_layoutAttribute = attribute;
    return param;
}

- (AUUEdgeLayoutParam *(^)(CGFloat))offset
{
    return [^(CGFloat offset){
        self.pri_offset = offset;
        return self;
    } copy];
}

- (AUUEdgeLayoutParam *(^)(CGFloat))multiple
{
    return [^(CGFloat multiple){
        self.pri_multiple = multiple;
        return self;
    } copy];
}

@end


@interface AUUEdgeLayout ()

@property (weak, nonatomic) UIView *pri_bindingView;

@property (assign, nonatomic) NSLayoutAttribute pri_latestLayoutAttribute;

@end

@implementation AUUEdgeLayout

+ (instancetype)edgeLayoutWithBindingView:(UIView *)view
{
    AUUEdgeLayout *edgeLayout = [[self alloc] init];
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

- (AUUEdgeLayout *(^)(id))equal
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationEqual releatedItem:element];
    } copy];
}

- (AUUEdgeLayout *(^)(id))greaterThan
{
    return [^(id element){
        return [self layoutConstrantWithRelation:NSLayoutRelationGreaterThanOrEqual releatedItem:element];
    } copy];
}

- (AUUEdgeLayout *(^)(id))lessThan
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
    } else if ([item isKindOfClass:[AUUEdgeLayoutParam class]]) {
        AUUEdgeLayoutParam *param = (AUUEdgeLayoutParam *)item;
        layoutConstrant = [NSLayoutConstraint constraintWithItem:self.pri_bindingView attribute:self.pri_latestLayoutAttribute
                                            relatedBy:relation toItem:param.pri_bindingView attribute:param.pri_layoutAttribute
                                           multiplier:param.pri_multiple constant:param.pri_offset];
    } else {
        NSLog(@"错误的信息");
    }
    
    if (layoutConstrant) {
        [self.pri_bindingView.superview addConstraint:layoutConstrant];
    }
    
    return self;
}

- (UIView *)bindingView
{
    return self.pri_bindingView;
}

@end

@implementation AUUEdgeLayout (AUUEdgeLayout)

- (AUUEdgeLayout *(^)(id))topEqual
{
    return [^(id element){
        return self.top.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))leftEqual
{
    return [^(id element){
        return self.left.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))bottomEqual
{
    return [^(id element){
        return self.bottom.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))rightEqual
{
    return [^(id element){
        return self.right.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))centerXEqual
{
    return [^(id element){
        return self.centerX.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))centerYEqual
{
    return [^(id element){
        return self.centerY.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))widthEqual
{
    return [^(id element){
        return self.width.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(id))heightEqual
{
    return [^(id element){
        return self.height.equal(element);
    } copy];
}

- (AUUEdgeLayout *(^)(CGSize))sizeEqual
{
    return [^(CGSize size){
        self.widthEqual(@(size.width));
        self.heightEqual(@(size.height));
        return self;
    }copy];
}

- (AUUEdgeLayout *(^)(UIView *))centerEqual
{
    return [^(UIView *view) {
        self.centerXEqual(view);
        self.centerYEqual(view);
        return self;
    } copy];
}

@end

@implementation UIView (AUUAssist)

- (AUUEdgeLayout *)auu_layout
{
    return [AUUEdgeLayout edgeLayoutWithBindingView:self];
}

- (AUUEdgeLayoutParam *)auu_top
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (AUUEdgeLayoutParam *)auu_left
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (AUUEdgeLayoutParam *)auu_bottom
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (AUUEdgeLayoutParam *)auu_right
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (AUUEdgeLayoutParam *)auu_centerX
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (AUUEdgeLayoutParam *)auu_centerY
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (AUUEdgeLayoutParam *)auu_width
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (AUUEdgeLayoutParam *)auu_height
{
    return [AUUEdgeLayoutParam paramWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

@end


