//
//  NITableHeaderFooterFactory.m
//  Nimbus
//
//  Created by JyHu on 2017/3/10.
//
//

#import "NITableHeaderFooterFactory.h"
#import "NITableHeaderFooterFactory+Private.h"
#import "NITableHeaderFooterView+Private.h"

#import "NICellFactory.h"


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 NITableHeaderFooterObject所有的表视图的头和尾的基类
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NITableHeaderFooterObject

+ (instancetype)objectWithHeaderClass:(Class)headerClass {
    return [self objectWithHeaderClass:headerClass userInfo:nil];
}
+ (instancetype)objectWithHeaderClass:(Class)headerClass userInfo:(id)userInfo {
    return [self objectWithHeaderFooterClass:headerClass userInfo:userInfo type:NITableViewHeaderFooterTypeHeader];
}
- (instancetype)initWithHeaderClass:(Class)headerClass {
    return [self initWithHeaderClass:headerClass];
}
- (instancetype)initWithHeaderClass:(Class)headerClass userInfo:(id)userInfo {
    return [self initWithHeaderFooterClass:headerClass userInfo:userInfo type:NITableViewHeaderFooterTypeHeader];
}

+ (instancetype)objectWithFooterClass:(Class)footerClass {
    return [self objectWithFooterClass:footerClass userInfo:nil];
}
+ (instancetype)objectWithFooterClass:(Class)footerClass userInfo:(id)userInfo {
    return [self objectWithHeaderFooterClass:footerClass userInfo:userInfo type:NITableViewHeaderFooterTypeFooter];
}
- (instancetype)initWithFooterClass:(Class)footerClass {
    return [self initWithFooterClass:footerClass userInfo:nil];
}
- (instancetype)initWithFooterClass:(Class)footerClass userInfo:(id)userInfo {
    return [self initWithHeaderFooterClass:footerClass userInfo:userInfo type:NITableViewHeaderFooterTypeFooter];
}

+ (instancetype)objectWithHeaderFooterClass:(Class)headerFooterClass userInfo:(id)userInfo type:(NITableViewHeaderFooterType)type {
    return [[self alloc] initWithHeaderFooterClass:headerFooterClass userInfo:userInfo type:type];
}
- (instancetype)initWithHeaderFooterClass:(Class)headerFooterClass userInfo:(id)userInfo type:(NITableViewHeaderFooterType)type {
    if ((self = [super init])) {
        self.headerFooterClass = headerFooterClass;
        self.userInfo = userInfo;
        self.type = type;
    }
    return self;
}

@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 只有文字的表头视图的object
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NITitleHeaderObject

+ (instancetype)objectWithTitle:(NSString *)title
{
    return [self objectWithTitle:title headerClass:[NITableHeaderFooterView class] userInfo:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title headerClass:(Class)cls userInfo:(id)userInfo
{
    return [[self alloc] initWithTitle:title headerClass:cls userInfo:userInfo];
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title headerClass:[NITableHeaderFooterView class] userInfo:nil];
}

- (instancetype)initWithTitle:(NSString *)title headerClass:(Class)cls userInfo:(id)userInfo
{
    if (self = [super initWithHeaderFooterClass:cls userInfo:userInfo type:NITableViewHeaderFooterTypeHeader]) {
        self.title = title;
    }
    return self;
}

@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 只有文字的表尾视图的object
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NITitleFooterObject

+ (instancetype)objectWithTitle:(NSString *)title
{
    return [self objectWithTitle:title footerClass:[NITableHeaderFooterView class] userInfo:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title footerClass:(__unsafe_unretained Class)cls userInfo:(id)userInfo
{
    return [[self alloc] initWithTitle:title footerClass:cls userInfo:userInfo];
}

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title footerClass:[NITableHeaderFooterView class] userInfo:nil];
}

- (instancetype)initWithTitle:(NSString *)title footerClass:(Class)cls userInfo:(id)userInfo
{
    if (self = [super initWithHeaderFooterClass:cls userInfo:userInfo type:NITableViewHeaderFooterTypeFooter]) {
        self.title = title;
    }
    return self;
}

@end



/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 带有detail的表头视图
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NISubTitleHeaderObject

+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail
{
    return [self objectWithTitle:title detail:detail headerClass:[NITableHeaderFooterView class] userInfo:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail headerClass:(Class)cls userInfo:(id)userInfo
{
    return [[self alloc] initWithTitle:title detail:detail headerClass:cls userInfo:userInfo];
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail
{
    return [self initWithTitle:title detail:detail headerClass:[NITableHeaderFooterView class] userInfo:nil];
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail headerClass:(Class)cls userInfo:(id)userInfo
{
    if (self = [super initWithTitle:title headerClass:cls userInfo:userInfo]) {
        self.detail = detail;
    }
    return self;
}

@end



/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 带有detail的表尾视图
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NISubTitleFooterObject

+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail
{
    return [self objectWithTitle:title detail:detail footerClass:[NITableHeaderFooterView class] userInfo:nil];
}

+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail footerClass:(Class)cls userInfo:(id)userInfo
{
    return [[self alloc] initWithTitle:title detail:detail footerClass:cls userInfo:userInfo];
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail
{
    return [self initWithTitle:title detail:detail footerClass:[NITableHeaderFooterView class] userInfo:nil];
}

- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail footerClass:(Class)cls userInfo:(id)userInfo
{
    if (self = [super initWithTitle:title footerClass:cls userInfo:userInfo]) {
        self.detail = detail;
    }
    return self;
}

@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 使用自定义视图的表头视图
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NICommonHeaderViewObject

+ (instancetype)objectWithCommonView:(UIView *)view
{
    return [self objectWithCommonView:view headerClass:[NITableCommonViewHeaderFooterView class] userInfo:nil];
}

+ (instancetype)objectWithCommonView:(UIView *)view headerClass:(Class)cls userInfo:(id)userInfo
{
    return [[self alloc] initWithCommonView:view headerClass:cls userInfo:userInfo];
}

- (instancetype)initWithCommonView:(UIView *)view
{
    return [self initWithCommonView:view headerClass:[NITableCommonViewHeaderFooterView class] userInfo:nil];
}

- (instancetype)initWithCommonView:(UIView *)view headerClass:(Class)cls userInfo:(id)userInfo
{
    if (self = [super initWithHeaderFooterClass:cls userInfo:userInfo type:NITableViewHeaderFooterTypeHeader]) {
        self.commonView = view;
    }
    return self;
}

@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 使用自定义视图的表尾视图
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@implementation NICommonFooterViewObject

+ (instancetype)objectWithCommonView:(UIView *)view
{
    return [self objectWithCommonView:view footerClass:[NITableCommonViewHeaderFooterView class] userInfo:nil];
}

+ (instancetype)objectWithCommonView:(UIView *)view footerClass:(Class)cls userInfo:(id)userInfo
{
    return [[self alloc] initWithCommonView:view footerClass:cls userInfo:userInfo];
}

- (instancetype)initWithCommonView:(UIView *)view
{
    return [self initWithCommonView:view footerClass:[NITableCommonViewHeaderFooterView class] userInfo:nil];
}

- (instancetype)initWithCommonView:(UIView *)view footerClass:(Class)cls userInfo:(id)userInfo
{
    if (self = [super initWithHeaderFooterClass:cls userInfo:userInfo type:NITableViewHeaderFooterTypeFooter]) {
        self.commonView = view;
    }
    return self;
}

@end


@implementation NITableHeaderFooterFactory

- (Class)headerFooterClassFromObject:(id)object
{
    if (object == nil) {
        return nil;
    }
    
    return nil;
}

- (UITableViewHeaderFooterView *)tableViewModel:(NITableViewModel *)tableViewModel
                             headerForTableView:(UITableView *)tableView
                                      inSection:(NSUInteger)section withObject:(id)object
{
    return [[self class] headerFooterForTable:tableView inSection:section withTableViewModel:tableViewModel object:object];
}

- (UITableViewHeaderFooterView *)tableViewModel:(NITableViewModel *)tableViewModel
                             footerForTableView:(UITableView *)tableView
                                      inSection:(NSUInteger)section withObject:(id)object
{
    return [[self class] headerFooterForTable:tableView inSection:section
                           withTableViewModel:tableViewModel object:object];
}

+ (UITableViewHeaderFooterView *)headerFooterForTable:(UITableView *)tableView
                                            inSection:(NSUInteger)section
                                   withTableViewModel:(NITableViewModel *)tableViewModel
                                               object:(id)object
{
    NITableHeaderFooterObject *headerFooterObject = (NITableHeaderFooterObject *)object;
    
    Class headerFooterClass = headerFooterObject.headerFooterClass;
    
    if (!headerFooterClass)
    {
        if ([headerFooterObject conformsToProtocol:@protocol(NITableHeaderFooterObject)]) {
            headerFooterClass = [headerFooterObject headerFooterClass];
        }
    }
    
    return [self headerFooterViewWithClass:headerFooterClass tableView:tableView object:object];
}

+ (UITableViewHeaderFooterView *)headerFooterViewWithClass:(Class)headerFooterClass
                                                 tableView:(UITableView *)tableView
                                                    object:(id)object
{
    NSString *identifier = NSStringFromClass(headerFooterClass);
    
    UITableViewHeaderFooterView *headerFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    if (headerFooterView == nil) {
        headerFooterView = [[headerFooterClass alloc] initWithReuseIdentifier:identifier];
    }
    
    if ([headerFooterView respondsToSelector:@selector(shouldUpdateHeaderFooterWithObject:)]) {
        [(id<NITableHeaderFooterView>)headerFooterView shouldUpdateHeaderFooterWithObject:object];
    }
    
    return headerFooterView;
}

- (UITableViewCell *)tableViewModel:(NITableViewModel *)tableViewModel cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    return [NICellFactory tableViewModel:tableViewModel cellForTableView:tableView atIndexPath:indexPath withObject:object];
}

@end
