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
    
    [self.Hori.interval(100).nextTo(view1.lengthEqual(@100)) endL];
    [self.Vert.interval(200).nextTo(view1.lengthEqual(@100)) endL];
    
    [self.Vert.nextTo(view2.bottomEqual(view1.u_top).lengthEqual(@100)) endL];
    [self.Hori.nextTo(view2.leftMarginEqual(view1.u_right, 20).lengthEqual(@100)) endL];
    
    UIView *view3 = [self generateViewWithTag:3];
    [self.view addSubview:view3];
    UIView *view4 = [self generateViewWithTag:4];
    [self.view addSubview:view4];
    
    [self.Hori.nextTo(view3.rightMarginEqual(self.view.u_centerX, -20).lengthEqual(@100)).interval(40).nextTo(view4.lengthEqual(@100)) endL];
    [self.Vert.nextTo(view3.topMarginEqual(self.view.u_top, 300).lengthEqual(@100)) endL];
    [self.Vert.nextTo(view4.topEqual(view3.u_top).lengthEqual(@100)) endL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
