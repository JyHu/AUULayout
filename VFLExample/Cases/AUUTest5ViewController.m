//
//  AUUTest5ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest5ViewController.h"

@interface AUUTest5ViewController ()

@end

@implementation AUUTest5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [self generateViewWithTag:1];
    UIView *view2 = [self generateViewWithTag:2];
    UIView *view3 = [self generateViewWithTag:3];
    UIView *view4 = [self generateViewWithTag:4];
    
    NSArray *vfls = @[
                      
                      
                      
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      self.Hori.interval(10).nextTo(view1.lengthEqual(view2)).interval(10).nextTo(view2).interval(20).end,
                      self.Vert.interval(100).nextTo(view1).interval(50).end,
                      self.Vert.interval(70).nextTo(view2.lengthEqual(@200)).endL,
                      self.Hori.nextTo(view1).nextTo(view3).end,
                      self.Vert.nextTo(view2).nextTo(view3.lengthEqual(@100)).endL,
                      self.Hori.interval(50).nextTo(view4.equalToV(view2)).endL,
                      self.Vert.nextTo(view3).nextTo(view4.lengthEqual(@100)).endL,
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      
                      
                      ];
    
    NSLog(@"当前页面布局的vfl %@", vfls);
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
