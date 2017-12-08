//
//  AUUCase05ViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import "AUUCase05ViewController.h"

@implementation AUUCase05ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label1 = [UILabel generateWithTtile:@"我的优先级为100，我的优先级为100"];
    UILabel *label2 = [UILabel generateWithTtile:@"我的优先级为200，我的优先级为200"];
    UILabel *label3 = [UILabel generateWithTtile:@"我的优先级为200，我的优先级为200"];
    UILabel *label4 = [UILabel generateWithTtile:@"我的优先级为100，我的优先级为100"];
    
    label1.backgroundColor = [UIColor generate];
    label2.backgroundColor = [UIColor generate];
    label3.backgroundColor = [UIColor generate];
    label4.backgroundColor = [UIColor generate];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    
    if (self.testCaseType == AUUTestCaseTypePackVFL) {
        H[10][label1[AUUPriorityConstraints(100, 100)]][5][label2[AUUPriorityConstraints(200, 100)]][10].end();
        H[10][label3[AUUPriorityConstraints(200, 100)]][5][label4[AUUPriorityConstraints(100, 100)]][10].end();
        
        
#if 1
        VA[100][@[label1, label2]][100][@[label3, label4]].cut();
#else
        V[100][label1][100][label3].cut();
        V[100][label2][100][label4].cut();
#endif
        
    }
    else if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.top.equalTo(self.view.mas_top).offset(100);
            make.width.equalTo(@100).priority(MASLayoutPriorityDefaultHigh);
            make.right.equalTo(label2.mas_left).offset(-5);
        }];
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100).priority(MASLayoutPriorityDefaultLow);
            make.top.equalTo(label1.mas_top);
            make.right.equalTo(self.view.mas_right).offset(-10);
        }];
        
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(10);
            make.top.equalTo(label1.mas_bottom).offset(100);
            make.width.equalTo(@100).priority(MASLayoutPriorityDefaultLow);
            make.right.equalTo(label4.mas_left).offset(-5);
        }];
        
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@100).priority(MASLayoutPriorityDefaultHigh);
            make.top.equalTo(label3.mas_top);
            make.right.equalTo(self.view.mas_right).offset(-10);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        label1.translatesAutoresizingMaskIntoConstraints = NO;
        label2.translatesAutoresizingMaskIntoConstraints = NO;
        label3.translatesAutoresizingMaskIntoConstraints = NO;
        label4.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(label1, label2, label3, label4);
        
        for (NSString *vfl in @[@"H:|-10-[label1(100@100)]-5-[label2(100@200)]-10-|",
                                @"H:|-10-[label3(100@200)]-5-[label4(100@100)]-10-|",
                                @"V:|-100-[label1]-100-[label3]",
                                @"V:|-100-[label2]-100-[label4]"]) {
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
    }
}

@end
