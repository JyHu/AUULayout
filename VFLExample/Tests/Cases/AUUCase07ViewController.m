//
//  AUUCase07ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase07ViewController.h"

@implementation AUUCase07ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view1 = [UIView generateView];
    UIView *view2 = [UIView generateView];
    [self.view addSubview:view1];
    [view1 addSubview:view2];

    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(74, 20, 20, 20));
        }];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view1.mas_centerX);
            make.centerY.equalTo(view1.mas_centerY);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(180, 180)]);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"VFL没法设置中心位置，需要配合NSLayoutConstraint" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        view1.translatesAutoresizingMaskIntoConstraints = NO;
        view2.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(view1, view2);
        
        for (NSString *vfl in @[@"H:|-10-[view1]-10-|", @"V:|-74-[view1]-10-|", @"H:[view2(180)]", @"V:[view2(180)]"]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual toItem:view2
                                                              attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual toItem:view2
                                                              attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    else
    {
        ////////////////////////////////////////////////////
        //              封装的VFL方法
        ////////////////////////////////////////////////////
        view1.edge(UIEdgeInsetsMake(84, 20, 20, 20));
        view2.alignmentCenter().fixedSize(180, 180);
    }
    
}

@end
