//
//  ViewController.m
//  WKWebViewResearch
//
//  Created by 石川 on 2020/4/13.
//  Copyright © 2020 石川. All rights reserved.
//

#import "ViewController.h"
#import "other/DMProgressHUD.h"
#import "MainViewController.h"
#import <WebKit/WebKit.h>


// WKWebView 内存不释放的问题解决
@interface TmpJavaScriptDelegate : NSObject<WKScriptMessageHandler>
//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
@end
@implementation TmpJavaScriptDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
#pragma mark - WKScriptMessageHandler
//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([self.scriptDelegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end








@interface ViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>
{
    UIButton *b4;
}
@property(nonatomic,strong)WKWebView *wkWebView;
@end

@implementation ViewController
-(WKWebView *)wkWebView
{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self->b4.frame), screenW, screenH-CGRectGetMaxY(self->b4.frame)) configuration:[self wkWebViewConfiguration]];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DMProgressHUD *hud = [DMProgressHUD showTextHUDAddedTo:self.view];
//    hud.text = @"Here's info";

    
    
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeSystem];
    b1.frame = CGRectMake(10, 100, 100, 40);
    b1.layer.borderWidth = 1;
    b1.layer.borderColor = UIColor.blueColor.CGColor;
    b1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    [b1 addTarget:self action:@selector(b1Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b1];
    
    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeSystem];
    b2.frame = CGRectMake(10*2+100*1, 100, 100, 40);
    b2.layer.borderWidth = 1;
    b2.layer.borderColor = UIColor.blueColor.CGColor;
    b2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    [b2 addTarget:self action:@selector(b2Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b2];
    
    UIButton *b3 = [UIButton buttonWithType:UIButtonTypeSystem];
    b3.layer.borderWidth = 1;
    b3.layer.borderColor = UIColor.blueColor.CGColor;
    b3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    b3.frame = CGRectMake(10*3+100*2, 100,100, 40);
    [b3 addTarget:self action:@selector(b3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b3];
    
    
    UIButton *b4 = [UIButton buttonWithType:UIButtonTypeSystem];
    b4.layer.borderWidth = 1;
    b4.layer.borderColor = UIColor.blueColor.CGColor;
    b4.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.1];
    b4.frame = CGRectMake(10, 100+50*1,100, 40);
    [b4 addTarget:self action:@selector(b4Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b4];
    self->b4 = b4;
    
    
    [b1 setTitle:@"goBack" forState:UIControlStateNormal];
    [b2 setTitle:@"goForward" forState:UIControlStateNormal];
    [b3 setTitle:@"reloade" forState:UIControlStateNormal];
    [b4 setTitle:@"OC调用JS" forState:UIControlStateNormal];
    
    
    
    
    
    
   
    
    
    //加载本地的html
    NSString *path = [[NSBundle mainBundle] pathForResource:@"html.html" ofType:nil];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    
    [self.view addSubview:self.wkWebView];
    
    
}
-(void)b1Click
{
    [self.wkWebView goBack];
}
-(void)b2Click
{
    [self.wkWebView goForward];
}
-(void)b3Click
{
    [self.wkWebView reload];
}
//配置WKWebView
-(WKWebViewConfiguration *)wkWebViewConfiguration
{
    //创建网页配置对象
     WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
     
     // 创建设置对象
     WKPreferences *preference = [[WKPreferences alloc]init];
    
     //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
     preference.minimumFontSize = 0;
    
     //设置是否支持javaScript 默认是支持的
     preference.javaScriptEnabled = YES;
    
     // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
     preference.javaScriptCanOpenWindowsAutomatically = YES;
     config.preferences = preference;
     
     // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
     config.allowsInlineMediaPlayback = YES;
    
     //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
    config.mediaTypesRequiringUserActionForPlayback = YES;
    
     //设置是否允许画中画技术 在特定设备上有效
     config.allowsPictureInPictureMediaPlayback = YES;
    
     //设置请求的User-Agent信息中应用程序名称 iOS9后可用
     config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    
    
    
     //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
     TmpJavaScriptDelegate *tmpJavaScriptDelegate = [[TmpJavaScriptDelegate alloc] initWithDelegate:self];
     //这个类主要用来做native与JavaScript的交互管理
     WKUserContentController * wkUController = [[WKUserContentController alloc] init];
     //注册一个name为jsToOcNoPrams的js方法
     [wkUController addScriptMessageHandler:tmpJavaScriptDelegate  name:@"jsToOcWithPrams"];
     [wkUController addScriptMessageHandler:tmpJavaScriptDelegate  name:@"jsToOcWithPramsNet"];
     config.userContentController = wkUController;
    
    
    // addScriptMessageHandler 很容易导致循环引用
    // 控制器 强引用了WKWebView,WKWebView copy(强引用了）configuration， configuration copy （强引用了）userContentController
    // userContentController 强引用了 self （控制器）
   // [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    
    
    //以下代码适配文本大小
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    //用于进行JavaScript注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
    
    //添加静态JS
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"netJs.js" ofType:nil];
    NSString *scriptStr2 = [[NSString alloc]initWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
    WKUserScript *wkUScript2 = [[WKUserScript alloc] initWithSource:scriptStr2 injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript2];
    
    
    //添加静态的CSS
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"public.css" ofType:nil];
    NSString *addCSS = [[NSString alloc]initWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
    addCSS = [addCSS stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *addCSSjs =[NSString stringWithFormat:@"let head = document.getElementsByTagName('head')[0];var css = document.createElement('style');css.innerHTML = '%@';css.type = 'text/css';head.appendChild(css);",addCSS];
    
    WKUserScript *wkUScript3 = [[WKUserScript alloc] initWithSource:addCSSjs injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript3];
    
    
    return config;
}
    



#pragma mark-WKNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"页面开始加载时调用");
}
//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
   NSLog(@"页面加载失败时调用");
}
//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"当内容开始返回时调用");
}
//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
   NSLog(@"页面加载完成之后调用");
}
//提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
 NSLog(@"提交发生错误时调用");
}

#pragma mark-WKScriptMessageHandler
//JS调用OC
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
     NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
    
    //用message.body获得JS传出的参数体
    NSDictionary * parameter = message.body;
    NSString *params = parameter[@"params"];
    NSLog(@"params=%@",params);
    
    if ([params isEqualToString:@"我是html的文字"]) {
        MainViewController *vc =  [[MainViewController alloc] init];
        vc.name = params;
        vc.view.backgroundColor = UIColor.greenColor;
       [self presentViewController: vc animated:YES completion:nil];
    }
}

//OC调用JS
NSString *htmlText = @"<div style=\"background-color:#0066FF;box-shadow:0px 1px 10px rgba(0,0,0,0.5);font-size: 20px;text-align: center;color: white;margin:10px;padding: 20px;border-radius: 5px\">我是OC里的文字</div>";
- (void)b4Click{
    //changeColor()是JS方法名，completionHandler是异步回调block
    htmlText =  [htmlText stringByAppendingString:htmlText];
    NSString *jsString = [NSString stringWithFormat:@"changeColor('%@')",htmlText];
    [self.wkWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable data, NSError * _Nullable error) {
    }];
}







// 根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
     NSString * urlStr = navigationAction.request.URL.absoluteString;
      NSLog(@"发送跳转请求：%@",urlStr);
      //自己定义的协议头
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 根据客户端受到的服务器响应头以及response相关信息来决定是否可以跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
#pragma mark - WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"HTML的弹出框" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 输入框
//JavaScript调用prompt方法后回调的方法 prompt是js中的输入框 需要在block中把用户输入的信息传入
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 页面是弹出窗口 _blank 处理
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}





- (void)dealloc{
    //移除注册的js方法
    [[self.wkWebView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcWithPrams"];
    [[self.wkWebView configuration].userContentController removeScriptMessageHandlerForName:@"jsToOcWithPramsNet"];
}
@end
