//
//  AUUTest4ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest4ViewController.h"

@interface AUUTest4ViewController ()

@end

@implementation AUUTest4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view1 = [UIView generateView];
    UIView *view2 = [UIView generateView];
    UIView *view3 = [UIView generateView];
    
    [self.view addSubview:view1];
    [view1 addSubview:view2];
    [view2 addSubview:view3];
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    view1.edge(UIEdgeInsetsMake(100, 20, 20, 20));
    view2.edge(UIEdgeInsetsMake(30, 40, 50, 60));
    
    // 在父视图居中，并固定大小为100
    view3.alignmentCenter().fixedSize(CGSizeMake(100, 100));
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ 在返回后被释放", NSStringFromClass([self class]));
}

@end
