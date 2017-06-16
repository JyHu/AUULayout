//
//  AUUEdge02ViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/5/21.
//
//

#import "AUUEdge02ViewController.h"

@interface AUUEdge02ViewController ()

@end

@implementation AUUEdge02ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v1 = [UIView generateView];
    UIView *v2 = [UIView generateView];
    
    [self.view addSubview:v1];
    [v1 addSubview:v2];
    
    v1.auu_layout.left.equal(self.view.auu_left.offset(20).multiple(1.5)).top.equal(self.view.auu_top.offset(84).multiple(1.5)).rightEqual(self.view.auu_right.offset(-20)).bottomEqual(self.view.auu_bottom.offset(-20));
    
    v2.auu_layout.centerEqual(v1).sizeEqual([NSValue valueWithCGSize:CGSizeMake(100, 100)]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

