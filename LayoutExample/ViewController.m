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
    
    __weak ViewController *weakSelf = self;
    NICellObject * (^PushAction)(NSString *title, NSString *tarVC) = ^NICellObject * (NSString *title, NSString *tarVC) {
        __strong ViewController *strongSelf = weakSelf;
        return [strongSelf.tableActions attachToObject:[NITitleCellObject objectWithTitle:title]
                                       navigationBlock:NIPushControllerAction(NSClassFromString(tarVC))];
    };
    NICellObject * (^WebInfoAction)(NSString *title, NSString *urlStr) = ^NICellObject *(NSString *title, NSString *urlStr) {
        __strong ViewController *strongSelf = weakSelf;
        return [strongSelf.tableActions attachToObject:[NITitleCellObject objectWithTitle:title] navigationBlock:NIPushControllerWithInfoAction(NSClassFromString(@"AUUWebPageViewController"), urlStr)];
    };
    
    NSArray *objects = @[
                         @"资料",
                         WebInfoAction(@"Visual Format Language -- Apple",
                                       @"https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1"),
                         WebInfoAction(@"VFL学习资料", @"http://www.auu.space/2016/06/02/Visual-Formate-Language-VFL"),
                         WebInfoAction(@"一个转屏时出现的错误", @"http://blog.csdn.net/ws1836300/article/details/52957056"),
                         WebInfoAction(@"AUUVFLLayout的说明文档", @"https://github.com/JyHu/AUULayout/blob/master/Using/Using_v01.md"),
                         @"关于居中布局",
                         [self showCenterQuestionCellObject],
                         WebInfoAction(@"swiftcn", @"http://swiftcn.io/topics/56?f=w"),
                         WebInfoAction(@"Stackoverflow", @"http://stackoverflow.com/questions/12873372/centering-a-view-in-its-superview-using-visual-format-language?noredirect=1&lq=1"),
                         @"Setting",
                         [self resetLayoutTypeCellObject],
                         @"Cases",
                         [self showBeggingCellObject],
                         PushAction(@"02-设置边距", @"AUUCase02ViewController"),
                         PushAction(@"03-指定宽高", @"AUUCase03ViewController"),
                         PushAction(@"04-相对位置", @"AUUCase04ViewController"),
                         PushAction(@"05-设置优先级", @"AUUCase05ViewController"),
                         PushAction(@"06-设置宽高范围", @"AUUCase06ViewController"),
                         PushAction(@"07-设置边界相对位置关系", @"AUUCase07ViewController"),
                         PushAction(@"08-设置距离的最大最小值", @"AUUCase08ViewController"),
                         WebInfoAction(@"09-属性的批量操作", @"https://github.com/JyHu/AUULayout/blob/master/Using/Using_v01.md/#9-属性的批量操作"),
                         @"Edge",
                         PushAction(@"02-初始", @"AUUEdge02ViewController"),
                         ];
    
    self.tableModel = [[NITableViewModel alloc] initWithSectionedArray:objects delegate:(id)[NICellFactory class]];
    
    self.tableView.dataSource = self.tableModel;
    self.tableView.delegate = self.tableActions;
}

- (NICellObject *)resetLayoutTypeCellObject
{
    return [self.tableActions attachToObject:[NISubtitleCellObject objectWithTitle:@"设置测试自动布局的方式" subtitle:nil] tapBlock:^BOOL(NISubtitleCellObject *object, id target, NSIndexPath *indexPath) {
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
    }];
}

- (NICellObject *)showBeggingCellObject
{
    return [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"语法的开始"] tapBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"语法的开始" message:@"这个库主要使用VFL，辅助使用NSLayoutConstraint来实现的，写起来跟VFL的流程类似，只不过VFL是纯字符串的写法，而这里封装了后，对VFL的流程加强了一下，就可以使用面向对象的方式来写自动布局的方式。\n所有的单独的属性设置都必须以V、H开始，跟VFL里的写法一个样，V表示纵向布局的开始，H表示横向布局的开始，对于封装的方法的话，那就另当别论了，根据具体的封装方式来进行调用。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
        return YES;
    }];
}

- (NICellObject *)showCenterQuestionCellObject
{
    return [self.tableActions attachToObject:[NITitleCellObject objectWithTitle:@"使用VFL设定视图居中的说明"] navigationBlock:^BOOL(id object, id target, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"VFL居中的说明" message:@"关于使用VFL设置视图居中的方法，苹果并没有明确的给出说明，在网上虽然有不少的讨论，但是并非是苹果官方给出的说法，只能说是大家试出来的解决方案，所以，暂时还不打算加进来，如果需要居中的话，可以使用NSLayoutConstraint的设置方法来实现。\n下面有几个网页，是网上开发者们的讨论情况，可以参考。" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
        return YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
