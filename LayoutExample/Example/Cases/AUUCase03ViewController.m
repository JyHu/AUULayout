//
//  AUUCase03ViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
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
    
    if (self.testCaseType == AUUTestCaseTypePackVFL) {
        H[10][view1[100]].cut();
        V[74][view1[100]].cut();
        
        H[view2[100]][10].end();
        V[74][view2[100]].cut();
        
        H[view3[view1]][10].end();
        V[view3[view1]][10].end();
        
        H[10][view4[view1]].cut();
        V[view4[view1]][10].end();
    }
    else if (self.testCaseType == AUUTestCaseTypeMasonry)
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
}

@end
