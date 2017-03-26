//
//  AUUCase08ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase08ViewController.h"

@implementation AUUCase08ViewController

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
            make.top.equalTo(view2.mas_bottom);
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
    else
    {
        
#if kUseVFLLayout
        
        H.VFL[10][view1.VFL[60]][view2.VFL[80]][view3.VFL[100]][view4.VFL[120]].endL();
        V.VFL[64][view1.VFL[60]][view2.VFL[80]][view3.VFL[100]][view4.VFL[120]].endL();

//        H.VFL[10][view1.VFL.rightEqual(view2.VFL[80].rightEqual(view3.VFL[100].rightEqual(view4.VFL[120].left).left).left)].endL();
//        V.VFL[64][view1.VFL.bottomEqual(view2.VFL[80].bottomEqual(view3.VFL[100].bottomEqual(view4.VFL[120].top).top).top)].endL();
#else
        
    #if 1       // 级联的写法
        
        [H.interval(10).nextTo(view1.lengthIs(60)).nextTo(view2.lengthIs(80)).nextTo(view3.lengthIs(100)).nextTo(view4.lengthIs(120)) endL];
        [V.interval(64).nextTo(view1.lengthIs(60)).nextTo(view2.lengthIs(80)).nextTo(view3.lengthIs(100)).nextTo(view4.lengthIs(120)) endL];
        
    #elif 0
        
        [H.interval(10).nextTo(view1.rightEqual(view2.rightEqual(view3.rightEqual(view4.u_left).u_left).u_left)) endL];
        [V.interval(64).nextTo(view1.bottomEqual(view2.bottomEqual(view3.bottomEqual(view4.u_top).u_top).u_top)) endL];
        view1.fixedSize(60, 60);
        view2.fixedSize(80, 80);
        view3.fixedSize(100, 100);
        view4.fixedSize(120, 120);
        
    #else       // 单个分开着写
        
        [H.interval(10).nextTo(view1.lengthIs(60)) endL];
        [V.interval(64).nextTo(view1.lengthIs(60)) endL];
        
        view2.leftEqual(view1.u_right);
        view2.topEqual(view1.u_bottom);
        view2.fixedSize(80, 80);
    ew 
        view3.leftEqual(view2.u_right).topEqual(view2.u_bottom).fixedSize(100, 100);
        
        [H.nextTo(view4.leftEqual(view3.u_right).topEqual(view3.u_bottom).lengthIs(120)) endL];
        [V.nextTo(view4.lengthIs(120)) endL];
        
    #endif
       
#endif
    }
    
}

@end
