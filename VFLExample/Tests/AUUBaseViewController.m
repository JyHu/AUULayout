//
//  AUUBaseViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUBaseViewController.h"

@interface AUUBaseViewController ()

@end

@implementation AUUBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)transitionFrom:(id)controller withObject:(id)object userInfo:(id)info {
    if ([object isKindOfClass:[NITitleCellObject class]]) {
        self.title = ((NITitleCellObject *)object).title;
    }
    if (info) {
        self.testCaseType = [info integerValue];
    }
}

- (UIView *)generateViewWithTag:(NSUInteger)tag inView:(UIView *)container
{
    UIView *view = [UIView generateView];
    UILabel *label = [UILabel generateWithTtile:[NSString stringWithFormat:@"%@", @(tag)]];
    [view addSubview:label];
    
    
    // VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    label.edge(UIEdgeInsetsMake(20, 20, 20, 20));
    
    // VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    [container addSubview:view];
    
    return view;
}

- (UIView *)generateViewWithTag:(NSUInteger)tag
{
    UIView *view = [UIView generateView];
    UILabel *label = [UILabel generateWithTtile:[NSString stringWithFormat:@"%@", @(tag)]];
    [view addSubview:label];
    
    
    // VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    label.edge(UIEdgeInsetsMake(20, 20, 20, 20));
    
    // VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [self.view addSubview:view];
    
    return view;
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
