//
//  NITableHeaderFooterFactory.h
//  Nimbus
//
//  Created by JyHu on 2017/3/10.
//
//

#import <Foundation/Foundation.h>
#import "NITableViewModel.h"
#import <UIKit/UIKit.h>
#import "NITableHeaderFooterView.h"


@protocol NITableHeaderFooterObject <NSObject>
@required
- (Class)headerFooterClass;
@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 NITableHeaderFooterObject所有的表视图的头和尾的基类。
 
 headerCass/footerClass 表头、表尾的视图的class，为UITableHeaderFooterView或其子类
 userInfo 附带的其他个人信息
 
 返回值 NITableHeaderFooterObject
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@interface NITableHeaderFooterObject : NSObject <NITableHeaderFooterObject>

- (instancetype)initWithHeaderClass:(Class)headerClass userInfo:(id)userInfo;
- (instancetype)initWithHeaderClass:(Class)headerClass;

+ (instancetype)objectWithHeaderClass:(Class)headerClass userInfo:(id)userInfo;
+ (instancetype)objectWithHeaderClass:(Class)headerClass;

- (instancetype)initWithFooterClass:(Class)footerClass userInfo:(id)userInfo;
- (instancetype)initWithFooterClass:(Class)footerClass;

+ (instancetype)objectWithFooterClass:(Class)footerClass userInfo:(id)userInfo;
+ (instancetype)objectWithFooterClass:(Class)footerClass;

+ (instancetype)objectWithHeaderFooterClass:(Class)headerFooterClass userInfo:(id)userInfo type:(NITableViewHeaderFooterType)type;
- (instancetype)initWithHeaderFooterClass:(Class)headerFooterClass userInfo:(id)userInfo type:(NITableViewHeaderFooterType)type;

@property (nonatomic, strong) id userInfo;
@property (assign, nonatomic) NITableViewHeaderFooterType type;

@end

/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 只有文字的表头视图的object
 
 title 表头的标题
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@interface NITitleHeaderObject : NITableHeaderFooterObject

+ (instancetype)objectWithTitle:(NSString *)title;
+ (instancetype)objectWithTitle:(NSString *)title headerClass:(Class)cls userInfo:(id)userInfo;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title headerClass:(Class)cls userInfo:(id)userInfo;

@property (retain, nonatomic) NSString *title;

@end

/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 只有文字的表尾视图的object
 
 title  表尾的标题
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@interface NITitleFooterObject : NITableHeaderFooterObject

+ (instancetype)objectWithTitle:(NSString *)title;
+ (instancetype)objectWithTitle:(NSString *)title footerClass:(Class)cls userInfo:(id)userInfo;
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title footerClass:(Class)cls userInfo:(id)userInfo;

@property (retain, nonatomic) NSString *title;

@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 带有detail的表头视图
 
 title 表头的标题
 detail 附带的信息
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */


@interface NISubTitleHeaderObject : NITitleHeaderObject

+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail;
+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail headerClass:(Class)cls userInfo:(id)userInfo;
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail;
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail headerClass:(Class)cls userInfo:(id)userInfo;

@property (retain, nonatomic) NSString *detail;

@end



/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 带有detail的表尾视图
 
 title 表尾的标题
 detail 附带的信息
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@interface NISubTitleFooterObject : NITitleFooterObject

+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail;
+ (instancetype)objectWithTitle:(NSString *)title detail:(NSString *)detail footerClass:(Class)cls userInfo:(id)userInfo;
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail;
- (instancetype)initWithTitle:(NSString *)title detail:(NSString *)detail footerClass:(Class)cls userInfo:(id)userInfo;

@property (retain, nonatomic) NSString *detail;

@end

/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 使用自定义视图的表头视图
 
 view 自定义的表头视图
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@interface NICommonHeaderViewObject : NITableHeaderFooterObject

+ (instancetype)objectWithCommonView:(UIView *)view;
+ (instancetype)objectWithCommonView:(UIView *)view headerClass:(Class)cls userInfo:(id)userInfo;
- (instancetype)initWithCommonView:(UIView *)view;
- (instancetype)initWithCommonView:(UIView *)view headerClass:(Class)cls userInfo:(id)userInfo;

@property (retain, nonatomic) UIView *commonView;

@end


/*
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 使用自定义视图的表尾视图
 
 view 自定义的表尾视图
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 */

@interface NICommonFooterViewObject : NITableHeaderFooterObject

+ (instancetype)objectWithCommonView:(UIView *)view;
+ (instancetype)objectWithCommonView:(UIView *)view footerClass:(Class)cls userInfo:(id)userInfo;
- (instancetype)initWithCommonView:(UIView *)view;
- (instancetype)initWithCommonView:(UIView *)view footerClass:(Class)cls userInfo:(id)userInfo;

@property (retain, nonatomic) UIView *commonView;

@end


@interface NITableHeaderFooterFactory : NSObject <NITableViewModelViewsDelegate>

+ (UITableViewHeaderFooterView *)headerFooterForTable:(UITableView *)tableView
                                            inSection:(NSUInteger)section
                                   withTableViewModel:(NITableViewModel *)taleViewModel
                                               object:(id)object;

@end
