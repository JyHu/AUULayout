//
//  AUUTest2ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest2ViewController.h"

@interface AUUTest2ViewController ()

@end

@implementation AUUTest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view1 = [UIView generateView];
    UIView *view2 = [UIView generateView];
    
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
#if kUseVFLLayout
    
#else
    
    NSArray *vfls = @[
                      
                      
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      // 父视图的左边 --间距20-- view1(宽度和view2相同) --间距10-- view2 --间距20-- 父视图的右边
                      H.interval(20).nextTo(view1.lengthEqual(view2)).interval(10).nextTo(view2).interval(20).end,
                      
                      V.interval(100).nextTo(view1).interval(10).end,
                      V.interval(100).nextTo(view2).interval(10).end
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                      
                      
                      ];
    
    NSLog(@"收集到vfl \n %@", vfls);
    
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
