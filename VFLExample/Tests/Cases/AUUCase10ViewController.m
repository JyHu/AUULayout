//
//  AUUCase10ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/23.
//
//

#import "AUUCase10ViewController.h"

@implementation AUUCase10ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self views].avgLayoutD(AUULayoutDirectionHorizontal);
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
