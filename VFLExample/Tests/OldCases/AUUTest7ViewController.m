//
//  AUUTest7ViewController.m
//  VFLFactory
//
//  Created by JyHu on 2017/3/21.
//
//

#import "AUUTest7ViewController.h"

@interface AUUTest7ViewController ()

@end

@implementation AUUTest7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *horiContainer = [UIView generateView];
    [self.view addSubview:horiContainer];
    
    
// VFL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
#if kUseVFLLayout
    
#else
    
    [H.interval(10).nextTo(horiContainer).interval(10) end];
    [V.interval(74).nextTo(horiContainer.lengthEqual(@250)) endL];
    [self viewsWithContainer:horiContainer].absHoriLayout(80, 200, 10);
    
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
