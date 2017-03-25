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
    
    UIView *view = [UIView generateView];
    [self.view addSubview:view];

    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(180, 180)]);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"VFL没法设置中心位置，需要配合NSLayoutConstraint" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(view);
        
        for (NSString *vfl in @[@"H:[view(180)]", @"V:[view(180)]"]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual toItem:view
                                                              attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual toItem:view
                                                              attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    else
    {
        ////////////////////////////////////////////////////
        //              封装的VFL方法
        ////////////////////////////////////////////////////
        view.alignmentCenter().fixedSize(180, 180);
    }
    
}

@end
