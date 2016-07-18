//
//  FastRegistrationNewViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/18/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "FastRegistrationNewViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

#if TESTAPI || ONLINETEST
NSString * const K_PEOPLE_NEW_URL = @"http://jiemo.jiemo.net/proc/AppKuaiZhu/second";
NSString * const K_RESOURCE_INFO =  @"http://jiemo.jiemo.net/AppKuaiZhu/student_list";
#else
NSString * const K_PEOPLE_NEW_URL = @"http://www.jiemo.net/appKuaiZhu/second";
NSString * const K_RESOURCE_INFO = @"http://www.jiemo.net/AppKuaiZhu/student_list";
#endif

@protocol JSObjcDelegate <JSExport>

- (void)invokeToIM:(NSString *)teacherData;

- (void)invokeClose;

- (void)invokeToAsk;

- (void)invokeTitleBar;

@end

@interface FastRegistrationNewViewController ()<UIWebViewDelegate,JSObjcDelegate>

@property (nonatomic, strong) NSURL *webUrl;

@property (nonatomic, strong) UIBarButtonItem *itemRight;
@property (nonatomic, strong) UIBarButtonItem *backItem;

@property (nonatomic, assign) BOOL buttonLeftFunction;
@property (nonatomic, retain) NSString *buttonRightFunction;

@end

@implementation FastRegistrationNewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView.delegate = self;
    
    _itemRight = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(postFrom:)];
    _itemRight.tintColor = CEECountDownFontColor;
    _itemRight.enabled = NO;
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 44, 44)];
    [backButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:CEECountDownFontColor forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTintColor:CEECountDownFontColor];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = _backItem;
    
    self.navigationItem.rightBarButtonItem = _itemRight;
    
    [self setCookies];
    [self loadWebView];
}
-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //清除cookies
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //    清除webView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
-(void)backAction:(id) sender
{
    if (_buttonLeftFunction) {
        [self.webView goBack];
        [self setCookies];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  点击提交按钮
 *
 *  @param sender <#sender description#>
 */
-(void) postFrom:(id) sender
{
    [self.view endEditing:YES];
    
    [[_webView stringByEvaluatingJavaScriptFromString:_buttonRightFunction] objectFromJSONString];
}

- (void) loadWebView
{
    _webUrl = [NSURL URLWithString:K_PEOPLE_NEW_URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:_webUrl];
    [_webView loadRequest:request];
}
-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"load finished");
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self JSMonitor];
    [[_webView stringByEvaluatingJavaScriptFromString:@"getTitleBarInfo()"] objectFromJSONString];
}

- (void)invokeClose{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)invokeToAsk{
    WeakSelf;
    [CEEAlertView showAlertWithTitle:@"温馨提示"
                             message:@"咨询顾问正在受理您的信息，您可以通过qq咨询或下载官方专业版(APP：聚留学)获取更多留学资讯!"
                     completionBlock:^(NSUInteger buttonIndex, CEEAlertView *alertView) {
                         if (buttonIndex == 1) {
                             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ju-liu-xue-mian-fei-chu-guo/id996848715?mt=8"]];
                         }
                         if (buttonIndex == 0) {
                             if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
                                 [weakSelf openQQ];
                                 
                             }else{
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [MBProgressHUD show:@"请安装qq!" toView:self.view];
                                 });
                             }
                         }
                     } cancelButtonTitle:@"qq咨询"
                   otherButtonTitles:@"秒下聚留学", nil];
}

- (void)invokeToIM:(NSString *)teacherData{
    WeakSelf;
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [weakSelf openQQ];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD show:@"请安装qq!" toView:self.view];
        });
    }
}

-(void)openQQ{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=2851198689&version=1&src_type=web"]];
}

- (void)invokeTitleBar{
    NSArray *args = [JSContext currentArguments];
    NSDictionary * dic = [NSDictionary dictionary];
    
    for (JSValue *jsVal in args) {
        NSLog(@"%@", jsVal.toString);
    }
    
    dic = ((JSValue *)args[0]).toDictionary;
    NSLog(@"invokeTitleBar is :%@",dic);
    
    _itemRight.title = [[dic objectForKey:@"data"] objectForKey:@"btnTitle"];
    _itemRight.enabled = [[[dic objectForKey:@"data"] objectForKey:@"btnShow"] boolValue];
    _buttonRightFunction = [[dic objectForKey:@"data"] objectForKey:@"rtFunc"];
    _buttonLeftFunction = [[[dic objectForKey:@"data"] objectForKey:@"ifFunc"] boolValue];
    self.title = [[dic objectForKey:@"data"] objectForKey:@"title"];
}


- (void)JSMonitor{
    JSContext *jsContext = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof (self) weakSelf = self;
    jsContext[@"ios"] = weakSelf;
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

- (void)changeUI:(NSDictionary *)dic{
    
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    if(!self.netWorkVC.view.superview)
//        [self.view addSubview:self.netWorkVC.view];
//    [self.netWorkVC showLoadingView:KLoadingFalse];
}
-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) viewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) setCookies
{
    _webUrl = [NSURL URLWithString:K_PEOPLE_NEW_URL];
    NSString *userId = _userInfo.userId;
    NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:[NSDictionary dictionaryWithObject:
                                                                              [[NSString alloc] initWithFormat:@"%@=%@",@"userid",userId] forKey:@"Set-Cookie"] forURL:_webUrl];
    
    // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                       forURL:_webUrl
                                              mainDocumentURL:nil];
    {
        NSArray *headeringCookie = [NSHTTPCookie cookiesWithResponseHeaderFields:[NSDictionary dictionaryWithObject:
                                                                                  [[NSString alloc] initWithFormat:@"%@=%@",@"dt",@"2"] forKey:@"Set-Cookie"] forURL:_webUrl];
        
        // 通过setCookies方法，完成设置，这样只要一访问URL为HOST的网页时，会自动附带上设置好的header
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:headeringCookie
                                                           forURL:_webUrl
                                                  mainDocumentURL:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
