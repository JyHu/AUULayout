//
//  AUUCase11ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase11ViewController.h"

@implementation AUUCase11ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self views].avgLayoutDEM(AUULayoutDirectionHorizontal, UIEdgeInsetsMake(74, 10, 10, 10), 20);
}

- (NSArray *)views
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *view = [self generateViewWithTag:i inView:self.view];
        [views addObject:view];
    }
    
    return views;
}

@end
