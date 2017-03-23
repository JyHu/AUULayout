//
//  AUUCase02ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/22.
//
//

#import "AUUCase02ViewController.h"

@implementation AUUCase02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [UIView generateView];
    [self.view addSubview:view1];
    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(20);
            make.top.equalTo(self.view.mas_top).offset(84);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        view1.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSString *vfl in @[@"H:|-20-[view1]-20-|",
                                @"V:|-84-[view1]-20-|"]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask
                                                                              metrics:nil views:NSDictionaryOfVariableBindings(view1)]];
        }
    }
    else
    {
        [H.interval(20).nextTo(view1).interval(20) end];
        NSString *vfl = V.interval(84).nextTo(view1).interval(20).end;
        NSLog(@"vfl : %@", vfl);
    }
    
    
    
    
    
    
    
    
    UIView *view2 = [UIView generateView];
    [view1 addSubview:view2];
    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view1).insets(UIEdgeInsetsMake(40, 40, 40, 40));
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        view2.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSString *vfl in @[@"H:|-40-[view2]-40-|",
                                @"V:|-40-[view2]-40-|"]) {
            [view1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask
                                                                          metrics:nil views:NSDictionaryOfVariableBindings(view2)]];
        }
    }
    else
    {
        ////////////////////////////////////////////////////
        //              封装的VFL方法
        ////////////////////////////////////////////////////
        
        
        NSArray *vfls = view2.edge(UIEdgeInsetsMake(40, 40, 40, 40));
        NSLog(@"vfls %@", vfls);
    }

}

@end
