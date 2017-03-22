//
//  AUUTest1ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest1ViewController.h"

@interface AUUTest1ViewController ()

@end

@implementation AUUTest1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [UIView generateView];
    [self.view addSubview:view];
    
    // 简单的vfl使用
    // view的左边与父视图的左边相距30，右边与父视图的右边相距40
    // 由于最后的结尾 end 是一个只读property，所以只可以使用getter方法
    // 
    // 使用的含义在平面上可以理解成：
    // 父视图的左边 --30-- view --40-- 父视图的右边
    
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    // 可以直接使用get方法来设定
    [self.Hori.interval(30).nextTo(view).interval(40) end];
    // 也能接取get方法返回的vfl字符串
    NSString *vfl = self.Vert.interval(100).nextTo(view).interval(20).end;
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    NSLog(@"我拿到了一个VFL ： %@", vfl);
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
