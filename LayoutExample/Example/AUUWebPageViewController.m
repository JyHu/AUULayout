//
//  AUUWebPageViewController.m
//  AUULayout
//
//  Created by JyHu on 2017/4/24.
//
//

#import "AUUWebPageViewController.h"
#import <Nimbus/NimbusModels.h>
#import <WebKit/WebKit.h>

@interface AUUWebPageViewController () <WKNavigationDelegate>
@property (retain, nonatomic) WKWebView *webView;
@property (retain, nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation AUUWebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    self.webView.edge(UIEdgeInsetsZero);
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.indicatorView startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.indicatorView];
    
    if (self.transitionInfo) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.transitionInfo]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.indicatorView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.indicatorView.hidden = NO;
}

@end
