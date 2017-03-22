//
//  ViewController.m
//  VFLExample
//
//  Created by JyHu on 2017/3/21.
//
//

#import "ViewController.h"
#import <Nimbus/NIActions.h>
#import <Nimbus/NimbusModels.h>
#import <SafariServices/SafariServices.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NITableViewModel *tableModel;

@property (retain, nonatomic) NITableViewActions *tableActions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VFL测试";
    
    self.tableActions = [[NITableViewActions alloc] initWithTarget:self];
    
    NSArray *objects = @[
                         @"VFL资料",
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"Visual Format Language -- Apple"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                             SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1"]];
                             [self.navigationController pushViewController:sf animated:YES];
                             return YES;
                         }],
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"VFL学习资料"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                             SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.auu.space/2016/06/02/Visual-Formate-Language-VFL"]];
                             [self.navigationController pushViewController:sf animated:YES];
                             return YES;
                         }],
                         [self.tableActions attachToObject:[NISubtitleCellObject objectWithTitle:@"一个VFL使用错误" subtitle:@"[App] if we're in the real pre-commit handler we can't actually add any new fences due"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                             SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"http://blog.csdn.net/ws1836300/article/details/52957056"]];
                             [self.navigationController pushViewController:sf animated:YES];
                             return YES;
                         }],
                         @"测试案例",
                         [self objectWithTitle:@"简单测试" subTitle:@"单个视图简单布局" vc:@"AUUTest1ViewController"],
                         [self objectWithTitle:@"简单测试" subTitle:@"两个视图相对布局，视图等宽等高" vc:@"AUUTest2ViewController"],
                         [self objectWithTitle:@"测试指定大小" subTitle:@"设置视图的宽高" vc:@"AUUTest3ViewController"],
                         [self objectWithTitle:@"测试设置边距" subTitle:@"使用edge添加上下左右边距" vc:@"AUUTest4ViewController"],
                         [self objectWithTitle:@"多视图测试" subTitle:@"多个视图散乱布局" vc:@"AUUTest5ViewController"],
                         [self objectWithTitle:@"平均布局测试" subTitle:@"多个视图纵横均匀布局" vc:@"AUUTest6ViewController"],
                         [self objectWithTitle:@"平均布局测试" subTitle:@"多个视图横向指定宽或高" vc:@"AUUTest7ViewController"],
                         [self objectWithTitle:@"平均布局测试" subTitle:@"多个视图纵向指定宽或高" vc:@"AUUTest8ViewController"],
                         [self objectWithTitle:@"优先级测试" subTitle:@"根据label上文字的压缩来测试优先级" vc:@"AUUTest9ViewController"],
                         [self objectWithTitle:@"测试边界Equal" subTitle:@"测试VFL混合Constrants设定边界相等" vc:@"AUUTest10ViewController"],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
                         ];
    
    self.tableModel = [[NITableViewModel alloc] initWithSectionedArray:objects delegate:(id)[NICellFactory class]];
    
    self.tableView.dataSource = self.tableModel;
    self.tableView.delegate = self.tableActions;
}

- (NICellObject *)objectWithTitle:(NSString *)title subTitle:(NSString *)subTitle vc:(NSString *)vc
{
    return [self.tableActions attachToObject:[NISubtitleCellObject objectWithTitle:title subtitle:subTitle]
                             navigationBlock:NIPushControllerAction(NSClassFromString(vc))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
