//
//  AUUEdge02ViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/5/21.
//
//

#import "AUUEdge02ViewController.h"

@interface AUUEdge02ViewController ()

@end

@implementation AUUEdge02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self ambiguousLayouts];
    
    UIView *v1 = [UIView generateView];
    UIView *v2 = [UIView generateView];
    
    [self.view addSubview:v1];
    [self.view addSubview:v2];
    
    v1.auu_layout.leftEqual(self.view.auu_left.offset(10)).topEqual(self.view.auu_top.offset(74)).sizeEqual(CGSizeMake(100, 100));
    v2.auu_layout.leftEqual(v1).topEqual(v1.auu_bottom).rightEqual(v1).heightEqual(v1);
    
    // 这是一个重复的约束
    v1.auu_layout.width.equal(@50);
}

- (void)ambiguousLayouts
{
    UIView *view1 = [UIView generateView];
    UIView *view2 = [UIView generateView];
    UIView *view3 = [UIView generateView];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    
    for (UIView *view in @[view1, view2, view3]) {
        NSLog(@"constrants : %@", view.constraints);
    }
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(74);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    for (NSString *vfl in @[@"H:|-10-[view2(50)]", @"V:|-134-[view2(50)]"]) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:NSDictionaryOfVariableBindings(view2)]];
    }
    
    view3.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:194]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]];
    
    for (UIView *view in @[view1, view2, view3]) {
        if (view.hasAmbiguousLayout) {
            NSLog(@"view : %@", view);
            NSLog(@"horizontal : %@", [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisHorizontal]);
            NSLog(@"vertical : %@", [view constraintsAffectingLayoutForAxis:UILayoutConstraintAxisVertical]);
            NSLog(@"\n\n\n------------------------------------------------------------------\n\n");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

