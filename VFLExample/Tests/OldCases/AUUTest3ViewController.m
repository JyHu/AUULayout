//
//  AUUTest3ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest3ViewController.h"

@interface AUUTest3ViewController ()

@end

@implementation AUUTest3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view1 = [UIView generateView];
    UIView *view2 = [UIView generateView];
    UIView *view3 = [UIView generateView];
    UIView *view4 = [UIView generateView];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    [self.view addSubview:view3];
    [self.view addSubview:view4];
    
#if kUseVFLLayout
    
#else
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    // 父视图的左边 --20-- view1(宽度为100) -- view2(宽度为200)
    [H.interval(20).nextTo(view1.lengthEqual(@100)).interval(-20).nextTo(view2.lengthEqual(@200)) endL];
    [V.interval(100).nextTo(view1.lengthEqual(@200)) endL];
    [V.interval(100).nextTo(view2.lengthEqual(@100)) endL];
    
    [H.nextTo(view3.lengthEqual(@200)).nextTo(view4.lengthEqual(@100)).interval(10) end];
    [V.nextTo(view3.lengthEqual(@100)).interval(10) end];
    [V.nextTo(view4.lengthEqual(@200)).interval(10) end];
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
#endif
    
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
