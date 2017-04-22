//
//  AUUCase04ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/22.
//
//

#import "AUUCase04ViewController.h"

@implementation AUUCase04ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:01 inView:self.view];
    UIView *view2 = [self generateViewWithTag:02 inView:self.view];
    UIView *view3 = [self generateViewWithTag:03 inView:self.view];
    UIView *view4 = [self generateViewWithTag:04 inView:self.view];
    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.top.equalTo(self.view.mas_top).offset(74);
            make.right.equalTo(view2.mas_left).offset(-30);
            make.height.equalTo(@100);
            make.bottom.equalTo(view4.mas_top).offset(-30);
        }];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_top);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.width.equalTo(@100);
            make.bottom.equalTo(view3.mas_top).offset(-30);
        }];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view4.mas_right).offset(30);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@100);
        }];
        
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.width.equalTo(@100);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        NSDictionary *dict = NSDictionaryOfVariableBindings(view1, view2, view3,view4);
        
        view1.translatesAutoresizingMaskIntoConstraints = NO;
        view2.translatesAutoresizingMaskIntoConstraints = NO;
        view3.translatesAutoresizingMaskIntoConstraints = NO;
        view4.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSString *vfl in @[@"H:|-10-[view1]-30-[view2(100)]-10-|",
                                @"V:|-74-[view2]-30-[view3(100)]-10-|",
                                @"H:|-10-[view4(100)]-30-[view3]-10-|",
                                @"V:|-74-[view1(100)]-30-[view4]-10-|"]) {
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
    }
    else
    {
        ////////////////////////////////////////////////////
        //              封装的VFL方法
        ////////////////////////////////////////////////////
        
        H[10][view1][30][view2[100]][10].end();
        V[74][view2][30][view3[100]][10].end();
        H[10][view4[100]][30][view3][10].end();
        V[74][view1[100]][30][view4][10].end();
        
        for (NSLayoutConstraint *layoutConstrant in view1.constraints) {
            
        }
    }
}

@end
