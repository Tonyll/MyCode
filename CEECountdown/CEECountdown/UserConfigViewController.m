//
//  UserConfigViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/18/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserConfigViewController.h"
#import "UserConfigCell.h"
#import "UserConfigCell1.h"
#import <UIImageView+WebCache.h>
#import "HTTPConfig.h"
#import "UserInfoUpdateViewController.h"

@interface UserConfigViewController ()<UIGestureRecognizerDelegate>{
    CGRect frame_first;
    UIImageView *fullImageView;
    BOOL _imgCanShowBig;//头像放大是否可点击
}

@property (nonatomic,strong)NSMutableArray * typeArray;
@property (nonatomic,strong)UIImage * smallImage;
@property (nonatomic,strong)UIImageView * currentImage;//当前图片存放

@end

@implementation UserConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 44, 44)];
    [backButton setImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:CEECountDownFontColor forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [backButton setTintColor:CEECountDownFontColor];
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    _imgCanShowBig = YES;
}
-(void)doBack:(id)sender
{
    _imgCanShowBig= NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.myTableView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeName:) name:@"CHANGENICKNAME" object:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyl
{
    return UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self showSmallImage];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)changeName:(NSNotification *)noti
{
    self.userModel.nickName = [noti.userInfo objectForKey:@"nickName"];
    [self.myTableView reloadData];
}
- (NSString *)title
{
    return @"个人信息";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80.0f;
        }else{
            return 50;
        }
        
    }
    
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0001f;
    }else{
        return 10.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * cellID = @"UserConfigCell";
        UserConfigCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        cell.headLabel.text = @"头像";
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:_userModel.imageUrl] placeholderImage:[UIImage imageNamed:@"ico_headDefault"]];
        //点击头像更改上传头像
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        cell.headImage.userInteractionEnabled = YES;
        [cell.headImage addGestureRecognizer:tap];
        return cell;
    }else{
        static NSString * cellID = @"UserConfigCell1";
        UserConfigCell1 * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if (indexPath.row == 1) {
            cell.typeLabel.text = @"昵称";
            if (_userModel.nickName) {
                cell.otherLabel.text = _userModel.nickName;
            }else{
                cell.otherLabel.text = @"未设置";
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (fullImageView.superview) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
        
    if (indexPath.row == 0) {
        FSMediaPicker * picker = [[FSMediaPicker alloc]init];
        picker.delegate = self;
        [picker showFromView:self.myTableView];
    }
    if (indexPath.row == 1) {
        UserInfoUpdateViewController *infoUpdateVC = [[UserInfoUpdateViewController alloc] init];
        infoUpdateVC.infoType = CEEUserNickName;
        infoUpdateVC.userInfo = self.userModel;
        [self.navigationController pushViewController:infoUpdateVC animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

//点击放大头像方法
- (void)showBigImage:(UITapGestureRecognizer *)tap
{
    if (_imgCanShowBig) {
        CGPoint location = [tap locationInView:self.myTableView];
        NSIndexPath * indexPath = [self.myTableView indexPathForRowAtPoint:location];
        UserConfigCell *cell = (UserConfigCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
        UIImageView *imageView=(UIImageView *)tap.view;
        frame_first=CGRectMake(cell.frame.origin.x+imageView.frame.origin.x, cell.frame.origin.y+imageView.frame.origin.y-self.myTableView.contentOffset.y+imageView.frame.size.height, imageView.frame.size.width, imageView.frame.size.height);
        fullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, CEEScreenWidth, CEEScreenHeight-50)];
        fullImageView.clipsToBounds = YES;
        fullImageView.backgroundColor = [UIColor blackColor];
        fullImageView.userInteractionEnabled = YES;
        [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSmallImage)]];
        fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        fullImageView.alpha = 0;
        if (![fullImageView superview]) {
            fullImageView.image = imageView.image;
            [self.view.window addSubview:fullImageView];
            fullImageView.frame = frame_first;
            fullImageView.frame = CGRectMake(0, 0, CEEScreenWidth, CEEScreenHeight);
            [UIView animateWithDuration:0.3 animations:^{
                fullImageView.alpha = 1;
            }completion:^(BOOL finished) {
            }];
        }
    }
}
- (void)showSmallImage
{
    fullImageView.frame = CGRectZero;
    [UIView animateWithDuration:0.3 animations:^{
        fullImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [fullImageView removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//第三方做法
- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    
    
    if ([CEEUtils NoNetFunc]) {
        MB_NONETCONECTING;
    }else{
        UIImage * image = [mediaInfo objectForKey:UIImagePickerControllerEditedImage];
        //    //把头像图片保存到本地
        if ([mediaInfo objectForKey:@"UIImagePickerControllerMediaMetadata"]!=nil)
        {
            [self save:[mediaInfo objectForKey:UIImagePickerControllerOriginalImage]];
        }
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        
        [MBProgressHUD showMessag:@"正在更改头像..." toView:self.view AfterDelay:10];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary * jsonParams = @{@"id": _userModel.userId,@"type":@"1",@"pictureCount":@"1"};
        NSString * returnString = [jsonParams JSONString];
        [manager POST:URL_UTILS_UPLOADIMAGE parameters:@{@"jsonParams": returnString} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"file0" fileName:@"file0.jpg" mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"上传图片至服务器后请求到的数据是:%@", responseObject);
            NSMutableDictionary *dic = (NSMutableDictionary*) responseObject;
            NSString *urlStr = [[dic objectForKey:@"data"] objectForKey:@"imageUrl"];
            self.userModel.imageUrl = urlStr;
            [CEEUtils saveUserInfoToLocal:[self.userModel yy_modelToJSONString]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD show:@"头像修改成功!" toView:self.view];
            UserConfigCell * cell = ((UserConfigCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]);
            
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.userModel.imageUrl] placeholderImage:[UIImage imageNamed:@"ico_headDefault"]];
            NSLog(@"[NSURL URLWithString:self.userModel.imageUrl] : %@",[NSURL URLWithString:self.userModel.imageUrl]);
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_USERINFO_CHANGE object:nil];
            NSIndexPath *changeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.myTableView reloadRowsAtIndexPaths:@[changeIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"错误信息是: %@", error);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD show:@"头像更改失败!" toView:self.view];
        }];
        
        ((UserConfigCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).headImage.layer.masksToBounds = YES;
    }
}
- (void)save:(UIImage *)image {
    // 存储图片到"相机胶卷"
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
// 成功保存图片到相册中, 必须调用此方法, 否则会报参数越界错误
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
}
@end
