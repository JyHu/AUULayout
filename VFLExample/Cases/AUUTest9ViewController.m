//
//  AUUTest9ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest9ViewController.h"

@interface AUUTest9ViewController ()

@end

@implementation AUUTest9ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label1 = [UILabel generateWithTtile:@"我的优先级为100，我的优先级为100"];
    label1.backgroundColor = [UIColor generate];
    UILabel *label2 = [UILabel generateWithTtile:@"我的优先级为200，我的优先级为200"];
    label2.backgroundColor = [UIColor generate];
    
    UILabel *label3 = [UILabel generateWithTtile:@"我的优先级为200，我的优先级为200"];
    label3.backgroundColor = [UIColor generate];
    UILabel *label4 = [UILabel generateWithTtile:@"我的优先级为100，我的优先级为100"];
    label4.backgroundColor = [UIColor generate];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    // 父视图的左边 --10-- label1(最小宽度为100，优先级100) --5-- label2(最小宽度100，优先级200) --10-- 父视图的右边
    [self.Hori.interval(10).nextTo(label1.priority(100, 100)).interval(5).nextTo(label2.priority(100, 200)).interval(10) end];
    [self.Hori.interval(10).nextTo(label3.priority(100, 200)).interval(5).nextTo(label4.priority(100, 100)).interval(10) end];
    
    [self.Vert.interval(100).nextTo(label1).interval(100).nextTo(label3) endL];
    [self.Vert.interval(100).nextTo(label2).interval(100).nextTo(label4) endL];
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
