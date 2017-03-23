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
#import "AUUBaseViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NITableViewModel *tableModel;

@property (retain, nonatomic) NITableViewActions *tableActions;

@property (assign, nonatomic) AUUTestCaseType caseType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"VFL测试";
    
    self.tableActions = [[NITableViewActions alloc] initWithTarget:self];
    
    self.caseType = AUUTestCaseTypeFactory;
    
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
                         @"Setting",
                         [self.tableActions attachToObject:[NISubtitleCellObject objectWithTitle:@"设置测试自动布局的方式" subtitle:nil] tapBlock:^BOOL(NISubtitleCellObject *object, id target, NSIndexPath *indexPath) {
                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择自动布局的方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                             [alertController addAction:[UIAlertAction actionWithTitle:@"VFLFactory" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 self.caseType = AUUTestCaseTypeFactory;
                                 object.subtitle = @"下面测试的页面里使用的布局都是封装的VFL方法";
                                 [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                             }]];
                             [alertController addAction:[UIAlertAction actionWithTitle:@"Masonry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 self.caseType = AUUTestCaseTypeMasonry;
                                 object.subtitle = @"下面测试的页面里使用的布局方式都是Masonry";
                                 [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                             }]];
                             [alertController addAction:[UIAlertAction actionWithTitle:@"VFL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 self.caseType = AUUTestCaseTypeVFL;
                                 object.subtitle = @"下面测试的页面里使用的布局方式都是VFL";
                                 [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                             }]];
                             
                             [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                             
                             [self presentViewController:alertController animated:YES completion:nil];
                             
                             return YES;
                         }],
                         @"Cases",
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"语法的开始"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"语法的开始" message:@"这个库主要使用VFL，辅助使用NSLayoutConstraint来实现的，写起来跟VFL的流程类似，只不过VFL是纯字符串的写法，而这里封装了后，对VFL的流程加强了一下，就可以使用面向对象的方式来写自动布局的方式。\n所有的单独的属性设置都必须以V、H开始，跟VFL里的写法一个样，V表示纵向布局的开始，H表示横向布局的开始，对于封装的方法的话，那就另当别论了，根据具体的封装方式来进行调用。" preferredStyle:UIAlertControllerStyleAlert];
                             [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                             [self presentViewController:alert animated:YES completion:nil];
                             return YES;
                         }],
                         [self objectWithTitle:@"设置边距" subTitle:nil vc:@"AUUCase02ViewController"],
                         [self objectWithTitle:@"指定宽高" subTitle:nil vc:@"AUUCase03ViewController"],
                         [self objectWithTitle:@"相对位置" subTitle:nil vc:@"AUUCase04ViewController"],
                         [self objectWithTitle:@"设置优先级" subTitle:nil vc:@"AUUCase05ViewController"],
                         [self objectWithTitle:@"设置宽高范围" subTitle:nil vc:@"AUUCase06ViewController"],
                         [self objectWithTitle:@"设置中心对齐" subTitle:nil vc:@"AUUCase07ViewController"],
                         [self objectWithTitle:@"设置边界相对位置关系" subTitle:nil vc:@"AUUCase08ViewController"],
                         [self objectWithTitle:@"设置边界相对位置关系的偏移" subTitle:nil vc:@"AUUCase09ViewController"],
                         [self objectWithTitle:@"多视图简单均匀布局" subTitle:nil vc:@"AUUCase10ViewController"],
                         [self objectWithTitle:@"多视图带控制属性均匀布局" subTitle:nil vc:@"AUUCase11ViewController"],
                         [self objectWithTitle:@"绝对布局，多视图指定宽高均匀布局" subTitle:nil vc:@"AUUCase12ViewController"],
                         [self objectWithTitle:@"绝对布局，多视图忽略次要属性均匀布局" subTitle:nil vc:@"AUUCase13ViewController"],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],
//                         [self objectWithTitle:<#(NSString *)#> subTitle:<#(NSString *)#> vc:<#(NSString *)#>],

                         @"之前的测试案例",
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
                         ];
    
    self.tableModel = [[NITableViewModel alloc] initWithSectionedArray:objects delegate:(id)[NICellFactory class]];
    
    self.tableView.dataSource = self.tableModel;
    self.tableView.delegate = self.tableActions;
}

- (NICellObject *)objectWithTitle:(NSString *)title subTitle:(NSString *)subTitle vc:(NSString *)vc
{
    return [self.tableActions attachToObject:[NISubtitleCellObject objectWithTitle:title subtitle:subTitle] tapBlock:^BOOL(NITitleCellObject *object, id target, NSIndexPath *indexPath) {
        AUUBaseViewController *baseVC = [[NSClassFromString(vc) alloc] init];
        baseVC.testCaseType = self.caseType;
        baseVC.title = object.title;
        [self.navigationController pushViewController:baseVC animated:YES];
        
        return YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
