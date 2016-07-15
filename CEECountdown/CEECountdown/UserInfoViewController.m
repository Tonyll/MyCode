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

@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *infoArr;
}

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userNickName;

@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

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
    
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2;
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:self.userInfo.imageUrl] placeholderImage:[UIImage imageNamed:@"userInfo_headDefault"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    self.userNickName.text = self.userInfo.nickName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOut:(id)sender {
    LOCAL_SET_ISLOGIN
    (NO);
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

#pragma private func
- (NSString *)userInfoContent:(NSInteger)index{
    NSString *str = @"";
    switch (index) {
        case 0:
            str = self.userInfo.birthday;
            break;
        case 1:
            str = [self.userInfo.sex isEqualToString:@"0"] ? @"男" : @"女";
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
