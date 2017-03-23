//
//  AUUTest6ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest6ViewController.h"

@interface AUUTest6ViewController ()

@end

@implementation AUUTest6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    [self viewsWithContainer:self.view needSub:YES].avgLayoutDE(AUULayoutDirectionHorizontal, UIEdgeInsetsMake(64, 20, 20, 20));
    
    
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
}


- (NSArray *)viewsWithContainer:(UIView *)container needSub:(BOOL)need
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *view = [self generateViewWithTag:i inView:container];
        [views addObject:view];
        
        if (need && i == 0) {
            
            
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [self viewsWithContainer:view needSub:NO].avgLayoutDEM(AUULayoutDirectionVertical, UIEdgeInsetsMake(10, 10, 10, 10), 10);
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
        }
    }
    
    return views;
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
