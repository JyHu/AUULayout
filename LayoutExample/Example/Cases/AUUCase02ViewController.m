//
//  AUUCase02ViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import "AUUCase02ViewController.h"

@implementation AUUCase02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [UIView generateView];
    [self.view addSubview:view1];
    
    UIView *view2 = [UIView generateView];
    [view1 addSubview:view2];
    
    self.view.repetitionLayoutConstrantsReporter = ^BOOL(UIView *correlationView, NSLayoutConstraint *repetitionLayoutConstrant) {
        return NO;
    };
    
    if (self.testCaseType == AUUTestCaseTypePackVFL) {
        H[20][view1][20].end();
        V[84][view1][20].end();
        V[64][view1][20].end();
        view2.edge(UIEdgeInsetsMake(40, 40, 40, 40));
        //        H[0][view2][0].end();
    }
    else if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(20);
            make.top.equalTo(self.view.mas_top).offset(84);
            make.right.equalTo(self.view.mas_right).offset(-20);
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view1).insets(UIEdgeInsetsMake(40, 40, 40, 40));
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        view1.translatesAutoresizingMaskIntoConstraints = NO;
        view2.translatesAutoresizingMaskIntoConstraints = NO;
        
        for (NSString *vfl in @[@"H:|-20-[view1]-20-|",
                                @"V:|-84-[view1]-20-|"]) {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask
                                                                              metrics:nil views:NSDictionaryOfVariableBindings(view1)]];
        }
        
        for (NSString *vfl in @[@"H:|-40-[view2]-40-|",
                                @"V:|-40-[view2]-40-|"]) {
            [view1 addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask
                                                                          metrics:nil views:NSDictionaryOfVariableBindings(view2)]];
        }
    }
}

@end
