//
//  RegistViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/18/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "RegistViewController.h"
#import "CEENetWork.h"
#import "LoginViewController.h"

@interface RegistViewController (){
    BOOL _isSelected;
    dispatch_source_t _timer;
}

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:CEEBackgroundColor];
    if (_vcType == 1) {
        self.navigationItem.title = @"注册";
        [self.registButton setTitle:@"注册" forState:UIControlStateNormal];
    } else {
        self.navigationItem.title = @"找回密码";
        [self.registButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    
    [self.registButton.layer setCornerRadius:(self.registButton.frame.size.height / 2)];
    [self.registButton.layer setMasksToBounds:YES];
    
    
    [self.captchaButton.layer setCornerRadius:(self.captchaButton.frame.size.height / 2)];
    [self.captchaButton.layer setMasksToBounds:YES];
    
    _isSelected = NO;
    
    [self doRac];
}

- (void)dealloc{
    if(_timer)
        dispatch_source_cancel(_timer);
}

- (IBAction)registAction:(id)sender{
    if ([CEEUtils NoNetFunc]) {
        MB_NONETCONECTING;
        return;
    }
    
    if (![self isMobileNumber:_telNumberTextField.text]) {
        [MBProgressHUD show:@"请输入正确的手机号!" toView:self.view];
        return;
    } else if(_captchaTextField.text.length != 4){
        [MBProgressHUD show:@"请输入正确的验证码!" toView:self.view];
        return;
    } else if(_pwdTextField.text.length < 6){
        [MBProgressHUD show:@"密码长度不能小于6位!" toView:self.view];
        return;
    } else if(_pwdTextField.text.length > 16){
        [MBProgressHUD show:@"密码长度不能大于16位!" toView:self.view];
        return;
    } else{
        NSDictionary * jsonParams = @{@"username":_telNumberTextField.text,@"type":_vcType == 1 ? @"1" : @"2",@"password":_pwdTextField.text,@"areaCode":@"0086",@"captcha":_captchaTextField.text};

        [MBProgressHUD showMessag:_vcType == 1 ? @"注册中..." : @"修改密码中..." toView:self.view AfterDelay:10.0f];
        
        [[CEENetWork sharedManager] requestWithMethod:POST WithPath:_vcType == 1 ? URL_USER_REGISTER : URL_USER_FINDPASS WithParams:jsonParams WithSuccessBlock:^(NSDictionary *responseObject) {
            NSLog(@"信息结果:%@",responseObject);
            MB_HIDEALL;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[responseObject objectForKey:@"errorcode"] integerValue]) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                NSString *errMsg  = [CEEUtils errorCodeHandle:[[responseObject objectForKey:@"errorcode"] integerValue]];
                [MBProgressHUD show:errMsg toView:self.view];
                self.navigationItem.rightBarButtonItem.enabled = YES;
                MB_HIDEALL;
            } else{
                MB_HIDEALL;
                
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
                for (UIViewController *vc in arr) {
                    if ([vc isKindOfClass:[RegistViewController class]] || [vc isKindOfClass:[LoginViewController class]]) {
                        [arr removeObject:vc];
                        break;
                    }
                }
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                self.navigationController.viewControllers = arr;
                if (_vcType == 1) {
                    [MBProgressHUD show:@"注册成功!" toView:[[[UIApplication sharedApplication] delegate] window]];
                } else {
                    [MBProgressHUD show:@"密码修改成功!" toView:[[[UIApplication sharedApplication] delegate] window]];
                }
                
                NSDictionary * data = [responseObject objectForKey:@"data"];
                UserModel *model = [UserModel yy_modelWithDictionary:data];
                model.userMobileNum = self.telNumberTextField.text;
                
                LOCAL_SET_ISLOGIN(YES);
                LOCAL_SYNCHRONIZE;
                [CEEUtils saveUserInfoToLocal:[model yy_modelToJSONString]];
            }
        } WithFailurBlock:^(NSError *error) {
            NSLog(@"错误信息是:%@",error);
            MB_HIDEALL;
            MB_NONETCONECTING;
        }];
    }
}
- (IBAction)showPwdAction:(id)sender{
    UIButton * aButton = (UIButton *)sender;
    _isSelected = !_isSelected;
    if (_isSelected) {
        [aButton setImage:[UIImage imageNamed:@"login_eye_show"] forState:UIControlStateNormal];
        _pwdTextField.secureTextEntry = NO;
        [_pwdTextField becomeFirstResponder];
    }else{
        [aButton setImage:[UIImage imageNamed:@"login_eye_hide"] forState:UIControlStateNormal];
        _pwdTextField.secureTextEntry = YES;
        [_pwdTextField becomeFirstResponder];
    }
}
- (IBAction)postAction:(id)sender{
    [self.view endEditing:YES];
    if (_telNumberTextField.text.length < 1) {
        [MBProgressHUD show:@"请先输入手机号码!"toView:self.view];
        return;
    }else if (_telNumberTextField.text.length <11){
        [MBProgressHUD show:@"手机号码格式不正确!" toView:self.view];
    }else{
        if ([CEEUtils NoNetFunc]) {
            MB_NONETCONECTING;
        }else{
            [MBProgressHUD showMessag:@"正在发送验证码..." toView:[[[UIApplication sharedApplication] delegate] window] AfterDelay:10.0f];
            
            AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            NSDictionary * jsonParams = @{@"phoneNum":_telNumberTextField.text,@"type":_vcType == 1 ? @"1" : @"2",@"areaCode":@"0086"};
            [[CEENetWork sharedManager] requestWithMethod:POST WithPath:URL_UTILS_CAPCHA WithParams:jsonParams WithSuccessBlock:^(NSDictionary *responseObject) {
                if ([[responseObject objectForKey:@"errorcode"] integerValue]) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    NSString *errMsg  = [CEEUtils errorCodeHandle:[[responseObject objectForKey:@"errorcode"] integerValue]];
                    [MBProgressHUD show:errMsg toView:self.view];
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    MB_HIDEALL;
                } else if([[responseObject objectForKey:@"errorcode"] integerValue] == 0) {
                    //提交数据获取验证码
                    __block int timeout = 59;//倒计时时间
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
                    dispatch_source_set_event_handler(_timer, ^{
                        if (timeout <= 0) {//倒计时结束,关闭
                            dispatch_source_cancel(_timer);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //设置界面的按钮显示,根据自己的需求设置
                                [_captchaButton setTitle:@"获取" forState:UIControlStateNormal];
                                _captchaButton.userInteractionEnabled = YES;
                            });
                        }else{
                            int seconds = timeout % 60;
                            NSString * strTime = [NSString stringWithFormat:@"%.2d",seconds];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_captchaButton setTitle:[NSString stringWithFormat:@"%@秒",strTime]forState:UIControlStateNormal];
                                _captchaButton.userInteractionEnabled = NO;
                            });
                            timeout--;
                        }
                    });
                    dispatch_resume(_timer);
                    MB_HIDEALL;
                    [MBProgressHUD show:@"验证码已发送!" toView:[[[UIApplication sharedApplication] delegate] window]];
                }
            } WithFailurBlock:^(NSError *error) {
                MB_HIDEALL;
                [MBProgressHUD show:@"发送失败!" toView:[[[UIApplication sharedApplication] delegate] window]];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)doRac{
    // 设置用户名是否合法的信号
    // map用于改变信号返回的值，在信号中判断后，返回bool值
    WeakSelf;
    RACSignal *usernameSignal = [self.telNumberTextField.rac_textSignal map:^id(NSString *usernameText) {
        if ([weakSelf isMobileNumber:usernameText]) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RACSignal *passwordSignal = [self.pwdTextField.rac_textSignal map:^id(NSString *usernameText) {
        
        NSUInteger length = usernameText.length;
        
        if (length >= 6 && length <= 16) {
            return @(YES);
        }
        return @(NO);
    }];
    
    RACSignal *captchaSignal = [self.captchaTextField.rac_textSignal map:^id(NSString *captchaText) {
        
        NSUInteger length = captchaText.length;
        
        if (length == 4) {
            return @(YES);
        }
        return @(NO);
    }];
    
    [self.telNumberTextField.rac_textSignal subscribeNext:^(NSString *number) {
        if (number.length >= 11) {
            self.telNumberTextField.text = [number substringToIndex:11];
        }
    }];
    
    [self.captchaTextField.rac_textSignal subscribeNext:^(NSString *number) {
        if (number.length >= 4) {
            self.captchaTextField.text = [number substringToIndex:4];
        }
    }];
    
    [self.pwdTextField.rac_textSignal subscribeNext:^(NSString *number) {
        if (number.length >= 11) {
            self.pwdTextField.text = [number substringToIndex:11];
        }
    }];
    
    RAC(self.registButton, enabled) = [RACSignal combineLatest:@[usernameSignal, passwordSignal,captchaSignal] reduce:^id(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect, NSNumber *iscaptchaCorrect){
        
        return @(isUsernameCorrect.boolValue && isPasswordCorrect.boolValue && iscaptchaCorrect.boolValue);
    }];
    
    RAC(self.registButton, backgroundColor) = [RACSignal combineLatest:@[usernameSignal, passwordSignal, captchaSignal] reduce:^id(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect, NSNumber *iscaptchaCorrect){
        
        if (isUsernameCorrect.boolValue && isPasswordCorrect.boolValue && iscaptchaCorrect.boolValue) {
            return CEETabBarSelectColor;
        } else {
            return [UIColor grayColor];
        }
    }];
}

@end
