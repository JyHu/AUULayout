//
//  AUUCase13ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase13ViewController.h"

@implementation AUUCase13ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIView *container = [UIView generateView];
    [self.view addSubview:container];
    
    container.edge(UIEdgeInsetsMake(74, 10, 10, 10));
    
    [self viewsWithContainer:container].absHoriLayout(100, -1, 20);
}

- (NSArray *)viewsWithContainer:(UIView *)container
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *view = [self generateViewWithTag:i inView:container];
        [views addObject:view];
    }
    
    return views;
}

@end
