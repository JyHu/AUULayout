//
//  AUUTest8ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest8ViewController.h"

@interface AUUTest8ViewController ()

@end

@implementation AUUTest8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *horiContainer = [UIView generateView];
    [self.view addSubview:horiContainer];
    
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
#if kUseVFLLayout
    
#else
    
    [H.interval(10).nextTo(horiContainer).interval(10) end];
    [V.interval(74).nextTo(horiContainer.lengthEqual(@400)) endL];
    [self viewsWithContainer:horiContainer].absVertLayout(-1, 100, 10);
    
#endif
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ 在返回后被释放", NSStringFromClass([self class]));
}

@end
