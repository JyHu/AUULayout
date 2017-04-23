//
//  ViewController.m
//  LayoutExample
//
//  Created by JyHu on 2017/4/23.
//
//

#import "ViewController.h"
#import <Nimbus/NIActions.h>
#import <Nimbus/NimbusModels.h>
#import <SafariServices/SafariServices.h>
#import "AUUBaseCaseViewController.h"

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
    self.caseType = AUUTestCaseTypePackVFL;
    
    NICellObject * (^PushAction)(NSString *title, NSString *tarVC) = ^NICellObject * (NSString *title, NSString *tarVC) {
        return [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:title]
                                 navigationBlock:NIPushControllerAction(NSClassFromString(tarVC))];
    };
    
    NSArray *objects = @[
                         @"VFL资料",
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"Visual Format Language -- Apple"]
                                                  tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                                                      return [self showWebPageWithURLString:@"https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1"];
                                                  }],
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"VFL学习资料"]
                                                  tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                                                      return [self showWebPageWithURLString:@"http://www.auu.space/2016/06/02/Visual-Formate-Language-VFL"];
                                                  }],
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"一个转屏时出现的错误"]
                                                  tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                                                      return [self showWebPageWithURLString:@"http://blog.csdn.net/ws1836300/article/details/52957056"];
                                                  }],
                         @"Setting",
                         [self.tableActions attachToObject:[NISubtitleCellObject objectWithTitle:@"设置测试自动布局的方式" subtitle:nil]
                                                  tapBlock:^BOOL(NISubtitleCellObject *object, id target, NSIndexPath *indexPath) {
                                                      return [self resetLayoutTypeWithObject:object indexPath:indexPath];
                                                  }],
                         @"Cases",
                         [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"语法的开始"]
                                                  tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
                                                      return [self showBegging];
                                                  }],
                         PushAction(@"02-设置边距", @"AUUCase02ViewController"),
                         PushAction(@"03-指定宽高", @"AUUCase03ViewController"),
                         PushAction(@"04-相对位置", @"AUUCase04ViewController"),
                         PushAction(@"05-设置优先级", @"AUUCase05ViewController"),
                         PushAction(@"06-设置宽高范围", @"AUUCase06ViewController"),
                         PushAction(@"07-设置边界相对位置关系", @"AUUCase07ViewController")
                         ];
    
    self.tableModel = [[NITableViewModel alloc] initWithSectionedArray:objects delegate:(id)[NICellFactory class]];
    
    self.tableView.dataSource = self.tableModel;
    self.tableView.delegate = self.tableActions;
}

- (BOOL)resetLayoutTypeWithObject:(NISubtitleCellObject *)object indexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择自动布局的方式" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"VFLFactory" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.caseType = AUUTestCaseTypePackVFL;
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
}

- (BOOL)showWebPageWithURLString:(NSString *)urlString
{
    SFSafariViewController *sf = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.navigationController pushViewController:sf animated:YES];
    return YES;
}

- (BOOL)showBegging
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"语法的开始" message:@"这个库主要使用VFL，辅助使用NSLayoutConstraint来实现的，写起来跟VFL的流程类似，只不过VFL是纯字符串的写法，而这里封装了后，对VFL的流程加强了一下，就可以使用面向对象的方式来写自动布局的方式。\n所有的单独的属性设置都必须以V、H开始，跟VFL里的写法一个样，V表示纵向布局的开始，H表示横向布局的开始，对于封装的方法的话，那就另当别论了，根据具体的封装方式来进行调用。" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
