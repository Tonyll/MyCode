//
//  LoginViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/13/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "LoginViewController.h"
#import "CEENetWork.h"
#import "UserModel.h"
#import "UserInfoViewController.h"
#import "RegistViewController.h"

@interface LoginViewController ()
{
    BOOL _isSelected;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdShowBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwd;

@property (nonatomic, strong) UIBarButtonItem *itemRight;

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
    
    [self.loginBtn.layer setCornerRadius:(self.loginBtn.frame.size.height / 2)];
    [self.loginBtn.layer setMasksToBounds:YES];
    
//    self.usernameText.text = @"13322260852";
//    self.passwordText.text = @"111111";
    
    _itemRight = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registAction)];
    _itemRight.tintColor = CEECountDownFontColor;
    
    self.navigationItem.rightBarButtonItem = _itemRight;
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
        [aButton setImage:[UIImage imageNamed:@"login_eye_hide"] forState:UIControlStateNormal];
        _passwordText.secureTextEntry = YES;
        [_passwordText becomeFirstResponder];
    }
}
- (IBAction)loginAction:(id)sender {
    if ([CEEUtils NoNetFunc]) {
        MB_NONETCONECTING;
        return;
    }
    if (![self isMobileNumber:_usernameText.text]) {
        [MBProgressHUD show:@"请输入正确的手机号!" toView:self.view];
        return;
    } else if(_passwordText.text.length < 6){
        [MBProgressHUD show:@"密码长度不能小于6位!" toView:self.view];
        return;
    } else if(_passwordText.text.length > 16){
        [MBProgressHUD show:@"密码长度不能大于16位!" toView:self.view];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view endEditing:YES];

    NSDictionary * dic = @{
                           @"username":_usernameText.text,
                           @"password":_passwordText.text,
                           };
    [MBProgressHUD showMessag:@"正在登录中..." toView:self.view AfterDelay:30.0f];
    [[CEENetWork sharedManager] requestWithMethod:POST WithPath:URL_USER_LOGIN WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"errorcode"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSString *errMsg  = [CEEUtils errorCodeHandle:[[dic objectForKey:@"errorcode"] integerValue]];
            [MBProgressHUD show:errMsg toView:self.view];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            return;
        }
        NSDictionary * data = [dic objectForKey:@"data"];
        UserModel *model = [UserModel yy_modelWithDictionary:data];
        model.userMobileNum = self.usernameText.text;
        
        LOCAL_SET_ISLOGIN(YES);
        LOCAL_SYNCHRONIZE;
        [CEEUtils saveUserInfoToLocal:[model yy_modelToJSONString]];
        [self.navigationController popViewControllerAnimated:YES];
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)registAction{
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.vcType = 1;
    [self.navigationController pushViewController:registVC animated:YES];
}
- (IBAction)findPwd:(id)sender {
    RegistViewController *registVC = [[RegistViewController alloc] init];
    registVC.vcType = 2;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)doRac{
    // 设置用户名是否合法的信号
    // map用于改变信号返回的值，在信号中判断后，返回bool值
    WeakSelf;
    RACSignal *usernameSignal = [self.usernameText.rac_textSignal map:^id(NSString *usernameText) {
        if ([weakSelf isMobileNumber:usernameText]) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RACSignal *passwordSignal = [self.passwordText.rac_textSignal map:^id(NSString *usernameText) {
        
        NSUInteger length = usernameText.length;
        
        if (length >= 6 && length <= 16) {
            return @(YES);
        }
        return @(NO);
    }];
    
    [self.usernameText.rac_textSignal subscribeNext:^(NSString *number) {
        if (number.length >= 11) {
            self.usernameText.text = [number substringToIndex:11];
        }
    }];
    
    [self.passwordText.rac_textSignal subscribeNext:^(NSString *number) {
        if (number.length >= 16) {
            self.passwordText.text = [number substringToIndex:16];
        }
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

@end
