//
//  AUUCase07ViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import "AUUCase07ViewController.h"

@implementation AUUCase07ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:1 inView:self.view];
    UIView *view2 = [self generateViewWithTag:2 inView:self.view];
    UIView *view3 = [self generateViewWithTag:3 inView:self.view];
    UIView *view4 = [self generateViewWithTag:4 inView:self.view];
    
    if (self.testCaseType == AUUTestCaseTypePackVFL) {
#if 1
        // 利用对数组做的封装的写法
        @[H,V].VFL[@[@10, @64]][view1[60]][view2[70]][view3[80]][view4[90]].cut();
#else
        H[10][view1[60]][view2[70]][view3[80]][view4[90]].cut();
        V[64][view1[60]][view2[70]][view3[80]][view4[90]].cut();
#endif
    }
    else if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(60, 60)]);
        }];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_right);
            make.top.equalTo(view1.mas_bottom);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(80, 80)]);
        }];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view2.mas_right);
            make.top.equalTo(view2.mas_bottom);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
        }];
        
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view3.mas_right);
            make.top.equalTo(view3.mas_bottom);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(120, 120)]);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        NSDictionary *dict = NSDictionaryOfVariableBindings(view1, view2, view3,view4);
        
        view1.translatesAutoresizingMaskIntoConstraints = NO;
        view2.translatesAutoresizingMaskIntoConstraints = NO;
        view3.translatesAutoresizingMaskIntoConstraints = NO;
        view4.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSString *vfl in @[@"H:|-10-[view1(60)][view2(80)][view3(100)][view4(120)]",
                                @"V:|-64-[view1(60)][view2(80)][view3(100)][view4(120)]"]) {
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
    }
}

@end
