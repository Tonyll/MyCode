//
//  LoginViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/13/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "LoginViewController.h"
#import "CEENetWork.h"

@interface LoginViewController ()
{
    BOOL _isSelected;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdShowBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    
    _isSelected = NO;
    [self doRac];
}

- (void)initView{
    [self.view setBackgroundColor:CEEBackgroundColor];
    self.navigationItem.title = @"登录";
    
//    self.loginBtn.backgroundColor = [UIColor grayColor];//CEETabBarSelectColor;
    [self.loginBtn.layer setCornerRadius:(self.loginBtn.frame.size.height / 2)];
    [self.loginBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showPwd:(id)sender {
    UIButton * aButton = (UIButton *)sender;
    _isSelected = !_isSelected;
    if (_isSelected) {
        [aButton setImage:[UIImage imageNamed:@"login_eye_show"] forState:UIControlStateNormal];
        _passwordText.secureTextEntry = NO;
        [_passwordText becomeFirstResponder];
    }else{
        [aButton setImage:[UIImage imageNamed:@"login_sys_hide"] forState:UIControlStateNormal];
        _passwordText.secureTextEntry = YES;
        [_passwordText becomeFirstResponder];
    }
}
- (IBAction)loginAction:(id)sender {
    NSLog(@"do login");
    if ([CEEUtils NoNetFunc]) {
        MB_NONETCONECTING;
        return;
    }
    if (![self isMobileNumber:_usernameText.text]) {
        [MBProgressHUD showMessage:@"请输入正确的手机号!" toView:self.view];
        return;
    } else if(_passwordText.text.length < 6){
        [MBProgressHUD showMessage:@"密码长度不能小于6位!" toView:self.view];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled =NO;
    [self.view endEditing:YES];
//    [_telNumberTextField resignFirstResponder];
//    //手机号和用户名全部验证通过,提交手机号码和用户名进行网络请求
//    _username = _telNumberTextField.text;
//    _password = _pwdTextField.text;
    
    NSDictionary * dic = @{
                           @"username":_usernameText.text,
                           @"password":_passwordText.text,
                           };
    [[CEENetWork sharedManager] requestWithMethod:POST WithPath:@"http://innerapi1.jiemodou.net/User/Login" WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
//        Model *model = [MTLJSONAdapter modelOfClass:[Model class] fromJSONDictionary:dic error:nil];
//        NSLog(@"%@", model.origin);
    } WithFailurBlock:^(NSError *error) {
        
    }];
    
//    [MBProgressHUD showMessag:@"正在登录中..." toView:self.view AfterDelay:30.0f];
//    [[HttpTool sharedInstance] post_action_loginWithUserName:_username Password:_password Finish:^(id responseObject, NSError *error) {
//        if (error)
//        {
//            self.navigationItem.rightBarButtonItem.enabled =YES;
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            MB_NONETCONECTING;
//            return ;
//        }
//        self.navigationItem.rightBarButtonItem.enabled =YES;
//        if ([[responseObject objectForKey:@"errorcode"]integerValue]==9008) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [MBProgressHUD showError:@"手机号或密码错误!" toView:self.view];
//        }else if([[responseObject objectForKey:@"errorcode"]integerValue] == 9005){
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [MBProgressHUD showError:@"验证码错误!" toView:self.view];
//        }else if([[responseObject objectForKey:@"errorcode"]integerValue] == 9009){
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [MBProgressHUD showError:@"手机号码不存在!" toView:self.view];
//        }else{
//            NSLog(@"登录成功。。。");
//            [self finishLoginWithData:responseObject WithType:0];
//        }
//    }];
}

- (void)doRac{
    // 设置用户名是否合法的信号
    // map用于改变信号返回的值，在信号中判断后，返回bool值
//    WeakSelf;
    RACSignal *usernameSignal = [self.usernameText.rac_textSignal map:^id(NSString *usernameText) {
//        if ([weakSelf isMobileNumber:usernameText]) {
//            return @(YES);
//        }
        if (usernameText.length > 0) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RACSignal *passwordSignal = [self.passwordText.rac_textSignal map:^id(NSString *usernameText) {
        
        NSUInteger length = usernameText.length;
        
//        if (length >= 6 && length <= 16) {
//            return @(YES);
//        }
        if (length > 0) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RAC(self.loginBtn, enabled) = [RACSignal combineLatest:@[usernameSignal, passwordSignal] reduce:^id(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect){
        
        return @(isUsernameCorrect.boolValue && isPasswordCorrect.boolValue);
    }];
    
    RAC(self.loginBtn, backgroundColor) = [RACSignal combineLatest:@[usernameSignal, passwordSignal] reduce:^id(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect){
        
        if (isUsernameCorrect.boolValue && isPasswordCorrect.boolValue) {
            return CEETabBarSelectColor;
        } else {
            return [UIColor grayColor];
        }
    }];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:mobileNum]==YES) {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
