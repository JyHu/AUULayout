//
//  AUUTest10ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/22.
//
//

#import "AUUTest10ViewController.h"

@interface AUUTest10ViewController ()

@end

@implementation AUUTest10ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:0];
    [self.view addSubview:view1];
    
    UIView *view2 = [self generateViewWithTag:1];
    [self.view addSubview:view2];
    
    [H.interval(100).nextTo(view1.lengthEqual(@100)) endL];
    [V.interval(200).nextTo(view1.lengthEqual(@100)) endL];
    
    [V.nextTo(view2.bottomEqual(view1.u_top).lengthEqual(@100)) endL];
    [H.nextTo(view2.leftEqual(view1.u_right.u_constant(20)).lengthEqual(@100)) endL];
    
    UIView *view3 = [self generateViewWithTag:3];
    [self.view addSubview:view3];
    UIView *view4 = [self generateViewWithTag:4];
    [self.view addSubview:view4];
    
    [H.nextTo(view3.rightEqual(self.view.u_centerX.u_constant(-20)).lengthEqual(@100)).interval(40).nextTo(view4.lengthEqual(@100)) endL];
    [V.nextTo(view3.topEqual(self.view.u_top.u_constant(300)).lengthEqual(@100)) endL];
    [V.nextTo(view4.topEqual(view3.u_top).lengthEqual(@100)) endL];
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
