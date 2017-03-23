//
//  AUUCase03ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/22.
//
//

#import "AUUCase03ViewController.h"

@implementation AUUCase03ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:1 inView:self.view];
    UIView *view2 = [self generateViewWithTag:2 inView:self.view];
    UIView *view3 = [self generateViewWithTag:3 inView:self.view];
    UIView *view4 = [self generateViewWithTag:4 inView:self.view];
    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.top.equalTo(self.view.mas_top).offset(74);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
        }];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(74);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
        }];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
        }];
        
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        view1.translatesAutoresizingMaskIntoConstraints = NO;
        view2.translatesAutoresizingMaskIntoConstraints = NO;
        view3.translatesAutoresizingMaskIntoConstraints = NO;
        view4.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(view1, view2, view3, view4);
        
        for (NSString *vfl in @[@"H:|-10-[view1(100)]",
                                @"V:|-74-[view1(100)]",
                                @"H:[view2(100)]-10-|",
                                @"V:|-74-[view2(100)]",
                                @"H:[view3(100)]-10-|",
                                @"V:[view3(100)]-10-|",
                                @"H:|-10-[view4(100)]",
                                @"V:[view4(100)]-10-|"]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
    }
    else
    {
        ////////////////////////////////////////////////////
        //              封装的VFL方法
        ////////////////////////////////////////////////////
        
        
        [H.interval(10).nextTo(view1.lengthEqual(@100)) endL];
        [V.interval(74).nextTo(view1.lengthIs(100)) endL];
        
        [H.nextTo(view2.lengthIs(100)).interval(10) end];
        [V.interval(74).nextTo(view2.lengthIs(100)) endL];
        
        [H.nextTo(view3.lengthIs(100)).interval(10) end];
        [V.nextTo(view3.lengthIs(100)).interval(10) end];
        
        [H.interval(10).nextTo(view4) endL];
        [V.nextTo(view4).interval(10) end];
        view4.fixedSize(100, 100);
    }
}

@end
