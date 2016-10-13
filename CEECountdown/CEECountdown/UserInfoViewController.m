//
//  UserInfoViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/14/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "UserInfoUpdateViewController.h"
#import "FastRegistrationNewViewController.h"
#import "UserConfigViewController.h"

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSArray *infoArr;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userNickName;

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topHeaderBg;

- (IBAction)logOut:(id)sender;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:CEEBackgroundColor];
    self.navigationItem.title = @"我的秘密档案";
    
    self.logoutBtn.backgroundColor = CEENavColor;
    [self.logoutBtn.layer setMasksToBounds:YES];
    [self.logoutBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.logoutBtn.layer setBorderWidth:1.0]; //边框宽度
    
    infoArr = @[@"生日",@"性别",@"家乡",@"喜好",@"QQ",@"电话"];
    
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    if (CEEScreenHeight > 568) {
        self.infoTableView.scrollEnabled = NO;
    } else {
        self.infoTableView.scrollEnabled = YES;
    }
    
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"userInfo_headDefault"]];
    self.userNickName.text = self.userInfo.nickName;
    
    UIButton *navRoad = [[UIButton alloc] init];
    navRoad.frame = CGRectMake(0, 0, 34, 34);
    [navRoad setBackgroundImage:[UIImage imageNamed:@"nav_road"] forState:UIControlStateNormal];
    [navRoad setBackgroundImage:[UIImage imageNamed:@"nav_road_select"] forState:UIControlStateHighlighted];
    [navRoad addTarget:self action:@selector(jumpRoad) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:navRoad];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChange) name:KNOTIFICATION_USERINFO_CHANGE object:nil];
    
    self.topHeaderBg.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewTap:)];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1; // 单击
    [self.topHeaderBg addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UITapGestureRecognizer 轻拍手势事件 ---

- (void)topViewTap:(UIGestureRecognizer *)sender{
    UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UserConfigViewController *userConfigVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserConfigViewController"];
    userConfigVC.userModel = self.userInfo;
    [self.navigationController pushViewController:userConfigVC animated:YES];
}

- (void)jumpRoad {
    FastRegistrationNewViewController *fastRegistVC = [[FastRegistrationNewViewController alloc] init];
    fastRegistVC.userInfo = self.userInfo;
    [self.navigationController pushViewController:fastRegistVC animated:YES];
}

- (IBAction)logOut:(id)sender {
    WeakSelf;
    [CEEAlertView showAlertWithTitle:@"提示"
                             message:@"是否确定退出?"
                     completionBlock:^(NSUInteger buttonIndex, CEEAlertView *alertView) {
                         if (buttonIndex == 1) {
                             [weakSelf logOutFunc];
                         }
                     } cancelButtonTitle:@"取消"
                   otherButtonTitles:@"确定", nil];
}

- (void)logOutFunc{
    LOCAL_SET_ISLOGIN(NO);
    LOCAL_SYNCHRONIZE;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in arr) {
        if ([vc isKindOfClass:[UserInfoViewController class]]) {
            [arr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = arr;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return infoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIndentifier = @"cell";
    UserInfoTableViewCell * cell = (UserInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = infoArr[indexPath.row];
    cell.contentLabel.text = [self userInfoContent:indexPath.row];
    
     
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 5) {
        UserInfoUpdateViewController *infoUpdateVC = [[UserInfoUpdateViewController alloc] init];
        infoUpdateVC.infoType = indexPath.row;
        infoUpdateVC.userInfo = self.userInfo;
        [self.navigationController pushViewController:infoUpdateVC animated:YES];
    } else{
        [MBProgressHUD show:@"不能修改" toView:self.view];
    }
}

- (void)userInfoChange{
    self.userInfo = [CEEUtils getUserInfoFromLocal];
    NSLog(@"[NSURL URLWithString:self.userModel.imageUrl] : %@",[NSURL URLWithString:self.userInfo.imageUrl]);
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"userInfo_headDefault"]];
    self.userNickName.text = self.userInfo.nickName;
    [self.infoTableView reloadData];
}

#pragma private func
- (NSString *)userInfoContent:(NSInteger)index{
    NSString *str = @"";
    switch (index) {
        case 0:
            str = self.userInfo.birthday;
            break;
        case 1:
            if ([self.userInfo.sex isEqualToString:@"1"]) {
                str = @"男";
            } else if([self.userInfo.sex isEqualToString:@"2"]){
                str = @"女";
            }
            break;
        case 2:
            str = self.userInfo.hometown;
            break;
        case 3:
            str = self.userInfo.favorite;
            break;
        case 4:
            str = self.userInfo.qq;
            break;
        case 5:
            str = self.userInfo.userMobileNum;
            break;
            
        default:
            break;
    }
    
    return str;
}
@end
