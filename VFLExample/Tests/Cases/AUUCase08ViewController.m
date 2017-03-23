//
//  AUUCase08ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase08ViewController.h"

@implementation AUUCase08ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:1 inView:self.view];
    UIView *view2 = [self generateViewWithTag:2 inView:self.view];
    UIView *view3 = [self generateViewWithTag:3 inView:self.view];
    UIView *view4 = [self generateViewWithTag:4 inView:self.view];
    
    [H.interval(10).nextTo(view1.lengthIs(60)) endL];
    [V.interval(64).nextTo(view1.lengthIs(60)) endL];
    
    view2.leftEqual(view1.u_right);
    view2.topEqual(view1.u_bottom);
    view2.fixedSize(80, 80);
    
    view3.leftEqual(view2.u_right).topEqual(view2.u_bottom).fixedSize(100, 100);
    
    [H.nextTo(view4.leftEqual(view3.u_right).topEqual(view3.u_bottom).lengthIs(120)) endL];
    [V.nextTo(view4.lengthIs(120)) endL];
}

@end
