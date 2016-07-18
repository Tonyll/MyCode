//
//  BaseViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/12/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "FastRegistrationNewViewController.h"

@interface BaseViewController ()<UIAlertViewDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"2017高考倒计时";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:CEETabBarSelectColor,NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIButton *navRoad = [[UIButton alloc] init];
    navRoad.frame = CGRectMake(0, 0, 34, 34);
    [navRoad setBackgroundImage:[UIImage imageNamed:@"nav_road"] forState:UIControlStateNormal];
    [navRoad setBackgroundImage:[UIImage imageNamed:@"nav_road_select"] forState:UIControlStateHighlighted];
    [navRoad addTarget:self action:@selector(jumpRoad) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:navRoad];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIButton *navSetBtn = [[UIButton alloc] init];
    navSetBtn.frame = CGRectMake(0, 0, 24, 24);
    [navSetBtn setBackgroundImage:[UIImage imageNamed:@"nav_setup"] forState:UIControlStateNormal];
    [navSetBtn setBackgroundImage:[UIImage imageNamed:@"nav_setup_select"] forState:UIControlStateHighlighted];
    [navSetBtn addTarget:self action:@selector(userInfoJump) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc] initWithCustomView:navSetBtn];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userInfoJump{
    if (LOCAL_GET_ISLOGIN) {
        UserModel *model = [CEEUtils getUserInfoFromLocal];
        
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.userInfo = model;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    } else {
        [self loginAlertShow];
    }
}


- (void)loginAlertShow{
    WeakSelf;
    [CEEAlertView showAlertWithTitle:@"登录提示"
                            message:@"您还没有登录,是否登录?"
                    completionBlock:^(NSUInteger buttonIndex, CEEAlertView *alertView) {
                        if (buttonIndex == 1) {
                            [weakSelf jumpToLoginVC];
                        }
                    } cancelButtonTitle:@"取消"
                  otherButtonTitles:@"确定", nil];
}

- (void)jumpToLoginVC{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)jumpRoad{
    if (LOCAL_GET_ISLOGIN) {
        UserModel *model = [CEEUtils getUserInfoFromLocal];
        
        FastRegistrationNewViewController *fastRegistVC = [[FastRegistrationNewViewController alloc] init];
        fastRegistVC.userInfo = model;
        [self.navigationController pushViewController:fastRegistVC animated:YES];
    } else {
        [self loginAlertShow];
    }
}



@end
