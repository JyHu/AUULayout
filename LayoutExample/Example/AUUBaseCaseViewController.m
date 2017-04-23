//
//  AUUBaseCaseViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/4/23.
//
//

#import "AUUBaseCaseViewController.h"
#import <Nimbus/NimbusModels.h>
#import "ViewController.h"

@interface AUUBaseCaseViewController ()<NIActionsDataTransition>

@end

@implementation AUUBaseCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)transitionFrom:(ViewController *)controller withObject:(id)object userInfo:(id)info {
    if ([object isKindOfClass:[NITitleCellObject class]]) {
        self.title = ((NITitleCellObject *)object).title;
    }
    self.testCaseType = controller.caseType;
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
