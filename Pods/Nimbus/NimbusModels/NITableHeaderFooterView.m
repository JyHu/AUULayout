//
//  NITableHeaderFooterView.m
//  Nimbus
//
//  Created by 胡金友 on 2017/3/1.
//
//

#import "NITableHeaderFooterView.h"
#import "NITableHeaderFooterFactory.h"
#import "NITableHeaderFooterView+Private.h"
#import "NIActions+Subclassing.h"

@interface NITableHeaderFooterView()

@property (retain, nonatomic) UITapGestureRecognizer *pri_tapGesture;

@end

@implementation NITableHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addGestureRecognizer:self.pri_tapGesture];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self addGestureRecognizer:self.pri_tapGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addGestureRecognizer:self.pri_tapGesture];
    }
    return self;
}

- (BOOL)shouldUpdateHeaderFooterWithObject:(id)object
{
    if ([object isKindOfClass:[NISubTitleHeaderObject class]])
    {
        NISubTitleHeaderObject *detailHeaderObject = (NISubTitleHeaderObject *)object;
        self.textLabel.text = detailHeaderObject.title;
        self.detailTextLabel.text = detailHeaderObject.detail;
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    else if ([object isKindOfClass:[NISubTitleFooterObject class]])
    {
        NISubTitleFooterObject *detailFooterObject = (NISubTitleFooterObject *)object;
        self.textLabel.text = detailFooterObject.title;
        self.detailTextLabel.text = detailFooterObject.detail;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    }
    else if ([object isKindOfClass:[NITitleHeaderObject class]])
    {
        NITitleHeaderObject *titleHeaderObject = (NITitleHeaderObject *)object;
        self.textLabel.text = titleHeaderObject.title;
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    else if ([object isKindOfClass:[NITitleFooterObject class]])
    {
        NITitleFooterObject *titleFooterObject = (NITitleFooterObject *)object;
        self.textLabel.text = titleFooterObject.title;
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return YES;
}

+ (CGFloat)heightForObject:(id)object atSection:(NSUInteger)section tableView:(UITableView *)tableView
{
    if ([object isKindOfClass:[NICommonHeaderViewObject class]]) {
        NICommonHeaderViewObject *commonHeaderViewObject = (NICommonHeaderViewObject *)object;
        return commonHeaderViewObject.commonView.frame.size.height;
    } else if ([object isKindOfClass:[NICommonFooterViewObject class]]) {
        NICommonFooterViewObject *commonFooterViewObject = (NICommonFooterViewObject *)object;
        return commonFooterViewObject.commonView.frame.size.height;
    } else if ([object isKindOfClass:[NISubTitleHeaderObject class]] || [object isKindOfClass:[NISubTitleFooterObject class]]) {
        return 60;
    } else if ([object isKindOfClass:[NITitleHeaderObject class]] || [object isKindOfClass:[NITitleFooterObject class]]) {
        return 30;
    }
    
    return tableView.sectionHeaderHeight;
}

- (UITapGestureRecognizer *)pri_tapGesture
{
    if (!_pri_tapGesture)
    {
        _pri_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(_handleForTap)];
    }
    
    return _pri_tapGesture;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
}

- (void)_handleForTap
{
    [self handleForTap];
    
    if (self.pri_delegate) {
        if (self.type == NITableViewHeaderFooterTypeHeader && [self.pri_delegate respondsToSelector:@selector(tableView:didSelectSectionHeaderAtIndex:)]) {
            [self.pri_delegate tableView:self.pri_tableView didSelectSectionHeaderAtIndex:self.pri_sectionIndex];
        }
        if (self.type == NITableViewHeaderFooterTypeFooter && [self.pri_delegate respondsToSelector:@selector(tableView:didSelectSectionFooterAtIndex:)]) {
            [self.pri_delegate tableView:self.pri_tableView didSelectSectionFooterAtIndex:self.pri_sectionIndex];
        }
    }
}

- (void)handleForTap {}

- (void)transmitHeaderInfo:(id)userInfo
{
    if (self.pri_delegate && [self.pri_delegate respondsToSelector:@selector(tableView:transmitUserInfo:atSectionHeaderWithIndex:)]) {
        [self.pri_delegate tableView:self.pri_tableView transmitUserInfo:userInfo atSectionHeaderWithIndex:self.pri_sectionIndex];
    }
}

- (void)transmitFooterInfo:(id)userInfo
{
    if (self.pri_delegate && [self.pri_delegate respondsToSelector:@selector(tableView:transmitUserInfo:atSectionFooterWithIndex:)]) {
        [self.pri_delegate tableView:self.pri_tableView transmitUserInfo:userInfo atSectionFooterWithIndex:self.pri_sectionIndex];
    }
}

- (UITapGestureRecognizer *)tapGesture
{
    return self.pri_tapGesture;
}

@end

@interface NITableCommonViewHeaderFooterView()

@property (retain, nonatomic) UIView *pri_commonView;

@end

@implementation NITableCommonViewHeaderFooterView

- (BOOL)shouldUpdateHeaderFooterWithObject:(id)object
{
    if ([object isKindOfClass:[NICommonHeaderViewObject class]])
    {
        NICommonHeaderViewObject *commonViewHeaderObject = (NICommonHeaderViewObject *)object;
        self.pri_commonView = commonViewHeaderObject.commonView;
        if (self.pri_commonView)
        {
            self.pri_commonView.frame = CGRectMake(0, 0, CGRectGetWidth(self.pri_commonView.frame), CGRectGetHeight(self.pri_commonView.frame));
            [self.contentView addSubview:self.pri_commonView];
        }
    }
    else if ([object isKindOfClass:[NICommonFooterViewObject class]])
    {
        NICommonFooterViewObject *commonFooterViewObject = (NICommonFooterViewObject *)object;
        self.pri_commonView = commonFooterViewObject.commonView;
        if (self.pri_commonView)
        {
            self.pri_commonView.frame = CGRectMake(0, 0, CGRectGetWidth(self.pri_commonView.frame), CGRectGetHeight(self.pri_commonView.frame));
            [self.contentView addSubview:self.pri_commonView];
        }
    }
    
    return [super shouldUpdateHeaderFooterWithObject:object];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.pri_commonView) {
        [self.pri_commonView removeFromSuperview];
    }
}

@end
