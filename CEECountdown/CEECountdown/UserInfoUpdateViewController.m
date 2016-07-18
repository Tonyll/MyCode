//
//  UserInfoUpdateViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/15/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserInfoUpdateViewController.h"
#import "CEENetWork.h"

@interface UserInfoUpdateViewController ()<UITextFieldDelegate>{
    NSString *paramsKey;
}

@end

@implementation UserInfoUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:CEEBackgroundColor];
    self.infoTextfield.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpSubViews{
    switch (self.infoType) {
        case CEEUserNickName:
            self.infoTextfield.placeholder = @"请输入昵称";
            self.infoTextfield.text = self.userInfo.nickName;
            paramsKey = @"nickName";
            break;
        case CEEUserBirthday:
            self.infoTextfield.placeholder = @"请选择出生日期";
            self.infoTextfield.text = self.userInfo.birthday;
            paramsKey = @"brithday";
            break;
        case CEEUserSex:
            self.infoTextfield.placeholder = @"请选择性别";
            self.infoTextfield.text = self.userInfo.sex;
            paramsKey = @"sex";
            break;
        case CEEUserHometown:
            self.infoTextfield.placeholder = @"请输入家乡";
            self.infoTextfield.text = self.userInfo.hometown;
            paramsKey = @"hometown";
            break;
        case CEEUserFavorite:
            self.infoTextfield.placeholder = @"请输入喜好";
            self.infoTextfield.text = self.userInfo.favorite;
            paramsKey = @"favorite";
            break;
        case CEEUserQQ:
            self.infoTextfield.placeholder = @"请输入QQ号";
            self.infoTextfield.text = self.userInfo.qq;
            paramsKey = @"qq";
            break;
            
        default:
            break;
    }
}

- (void)saveAction{
    if ([CEEUtils NoNetFunc]) {
        MB_NONETCONECTING;
        return;
    }
    
    [self changeUserInfo];
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:self.infoTextfield.text forKey:paramsKey];
    [dic setObject:self.userInfo.userId forKey:@"userId"];

    [MBProgressHUD showMessag:@"正在修改信息..." toView:self.view AfterDelay:30.0f];
    //userId
    [[CEENetWork sharedManager] requestWithMethod:POST WithPath:URL_USER_UPDATE WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[dic objectForKey:@"errorcode"] integerValue]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            NSString *errMsg  = [CEEUtils errorCodeHandle:[[dic objectForKey:@"errorcode"] integerValue]];
            [MBProgressHUD showMessage:errMsg toView:self.view];
            return;
        }
        
        [CEEUtils saveUserInfoToLocal:[self.userInfo yy_modelToJSONString]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_USERINFO_CHANGE object:self.userInfo];
        [self.navigationController popViewControllerAnimated:YES];
    } WithFailurBlock:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void) changeUserInfo{
    switch (self.infoType) {
        case CEEUserNickName:
            self.userInfo.nickName = self.infoTextfield.text;
            break;
        case CEEUserBirthday:
            self.userInfo.birthday = self.infoTextfield.text;
            break;
        case CEEUserSex:
            self.userInfo.sex = self.infoTextfield.text;
            break;
        case CEEUserHometown:
            self.userInfo.hometown = self.infoTextfield.text;
            break;
        case CEEUserFavorite:
            self.userInfo.favorite = self.infoTextfield.text;
            break;
        case CEEUserQQ:
            self.userInfo.qq = self.infoTextfield.text;
            break;
            
        default:
            break;
    }
}

@end
