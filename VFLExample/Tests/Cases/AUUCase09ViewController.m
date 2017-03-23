//
//  AUUCase09ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase09ViewController.h"
#import <Masonry/Masonry.h>

@implementation AUUCase09ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:1 inView:self.view];
    UIView *view2 = [self generateViewWithTag:2 inView:self.view];
    UIView *view3 = [self generateViewWithTag:3 inView:self.view];
    UIView *view4 = [self generateViewWithTag:4 inView:self.view];
    
    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_right).offset(20).multipliedBy(0.8);
            make.top.equalTo(view1.mas_bottom).offset(30).multipliedBy(0.8);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(80, 80)]);
        }];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view2.mas_right).offset(20).multipliedBy(1.1);
            make.top.equalTo(view2.mas_bottom).offset(10).multipliedBy(0.9);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(90, 90)]);
        }];
        
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view3.mas_right).offset(20).multipliedBy(0.8);
            make.top.equalTo(view3.mas_bottom).offset(50).multipliedBy(0.8);
            make.width.equalTo(view3.mas_width).offset(10).multipliedBy(1.2);
            make.height.equalTo(view3.mas_height).offset(10).multipliedBy(0.6);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"VFL无法做到等比例属性的设置" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        
#if 1       // 单个的散着写
        
        [H.interval(10).nextTo(view1.lengthIs(60)) endL];
        [V.interval(64).nextTo(view1.lengthIs(60)) endL];
        
        // 第一种设置方式
        view2.leftEqual(view1.u_right.u_constant(20).u_multiplier(0.8));
        view2.topEqual(view1.u_bottom.u_constant(30).u_multiplier(0.8));
        view2.fixedSize(80, 80);
        
        // 第二种设置方式
        view3.leftEqual(view2.u_right.u_constant(20).u_multiplier(1.1))
        .topEqual(view2.u_bottom.u_constant(10).u_multiplier(0.9)).fixedSize(90, 90);
        
        // 第三种设置方式
        view4.leftEqual(view3.u_right.u_constant(40).u_multiplier(0.8))
        .topEqual(view3.u_bottom.u_constant(50).u_multiplier(0.8))
        .widthEqual(view3.u_width.u_multiplier(1.2).u_constant(10))
        .heightEqual(view3.u_height.u_multiplier(0.6).u_constant(10));
        
#else       // 多个级联着写
        
        [H.interval(10).nextTo(view1.rightEqual(view2.rightEqual(view3.rightEqual(view4.widthEqual(view3.widthEqual(view2.widthEqual(view1.u_width.u_multiplier(1.5)).u_width.u_multiplier(1.5)).u_width.u_multiplier(1.5)).u_left).u_left).u_left)) endL];
        [V.interval(74).nextTo(view1.bottomEqual(view2.bottomEqual(view3.bottomEqual(view4.heightEqual(view3.heightEqual(view2.heightEqual(view1.u_height.u_multiplier(1.5)).u_height.u_multiplier(1.5)).u_height.u_multiplier(1.5)).u_top).u_top).u_top)) endL];
#endif
        
    }
    
}

@end
