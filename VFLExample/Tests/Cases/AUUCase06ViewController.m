//
//  AUUCase06ViewController.m
//  VFLFactory
//
//  Created by 胡金友 on 2017/3/22.
//
//

#import "AUUCase06ViewController.h"

@interface AUUCase06ViewController ()

@property (retain, nonatomic) UILabel *label;

@end

@implementation AUUCase06ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundColor:[UIColor generate]];
    [addButton setTitle:@"增加内容" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    UIButton *reduceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reduceButton setBackgroundColor:[UIColor generate]];
    [reduceButton setTitle:@"减少内容" forState:UIControlStateNormal];
    [reduceButton addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reduceButton];
    
#if kUseVFLLayout
    
    H[100][addButton.VFL[reduceButton]][10][reduceButton][100].end();
    V[74][addButton.VFL[44]].cut();
    V[74][reduceButton.VFL[44]].cut();
    
#else
    
    [H.interval(100).nextTo(addButton.lengthEqual(reduceButton)).interval(10).nextTo(reduceButton).interval(100) end];
    [V.interval(74).nextTo(addButton.lengthIs(44)) endL];
    [V.interval(74).nextTo(reduceButton.lengthIs(44)) endL];
    
#endif
    
//              上面是设置button的，不是主要的，下面的才是
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//              主要的测试的内容
    
    self.label = [UILabel generateWithTtile:@"测试宽度的范围"];
    self.label.backgroundColor = [UIColor generate];
    self.label.numberOfLines = 0;
    self.label.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:self.label];
    
    if (self.testCaseType == AUUTestCaseTypeMasonry)
    {
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(20);
            make.top.equalTo(addButton.mas_bottom).offset(30);
            make.width.greaterThanOrEqualTo(@200);
            make.width.lessThanOrEqualTo(@300);
        }];
    }
    else if (self.testCaseType == AUUTestCaseTypeVFL)
    {
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        addButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dict = NSDictionaryOfVariableBindings(_label, addButton);
        
        for (NSString *vfl in @[@"H:|-20-[_label(>=200,<=300)]",
                                @"V:[addButton]-30-[_label]"])
        {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatDirectionMask metrics:nil views:dict]];
        }
    }
    else
    {
        ////////////////////////////////////////////////////
        //              封装的VFL方法
        ////////////////////////////////////////////////////
        
        H[20][self.label[between(200, 300)]].cut();
        V[addButton][20][self.label].cut();
    }
}

- (void)add
{
    self.label.text = [NSString stringWithFormat:@"%@ 加个字", self.label.text];
}

- (void)reduce
{
    if (self.label.text.length > 10) {
        self.label.text = [self.label.text substringToIndex:self.label.text.length - 4];
    }
}

@end
