//
//  UserInfoUpdateViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/15/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "UserInfoUpdateViewController.h"
#import "CEENetWork.h"
#import <IQUIView+IQKeyboardToolbar.h>

#define kLETTERNUM @"0123456789\n"

@interface UserInfoUpdateViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UIActionSheetDelegate>{
    NSString *paramsKey;
}

@property (nonatomic, strong) UIBarButtonItem *itemRight;

@property(nonatomic,strong)UIDatePicker *datePicker;

@property (nonatomic, strong) UIActionSheet *sheet;

@end

@implementation UserInfoUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:CEEBackgroundColor];
    self.infoTextfield.backgroundColor = [UIColor whiteColor];
    _itemRight = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    _itemRight.tintColor = CEECountDownFontColor;
    
    self.navigationItem.rightBarButtonItem = _itemRight;
    self.infoTextfield.delegate = self;
    [self initDatePicker];
    [self initActionSheet];
    [self setUpSubViews];
    
//    [self.infoTextfield addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)doneAction:(id)sender{
//    if (self.infoType == CEEUserBirthday) {
//        if (self.infoTextfield.text.length == 0) {
//            NSDate *currentTime = [NSDate date];
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            //设定时间格式,这里可以设置成自己需要的格式
//            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//            self.infoTextfield.text = [dateFormatter stringFromDate:currentTime];
//        }
//    }
//}

- (void) setUpSubViews{
    switch (self.infoType) {
        case CEEUserNickName:
        {
            self.infoTextfield.placeholder = @"请输入昵称";
            self.infoTextfield.text = self.userInfo.nickName;
            self.navigationItem.title = @"昵称";
            paramsKey = @"nickName";
            [self.infoTextfield.rac_textSignal subscribeNext:^(NSString *number) {
                if (number.length >= 15) {
                    self.infoTextfield.text = [number substringToIndex:15];
                }
            }];
        }
            break;
        case CEEUserBirthday:
            self.infoTextfield.placeholder = @"请输入生日";
            self.infoTextfield.text = self.userInfo.birthday;
            self.navigationItem.title = @"生日";
            self.infoTextfield.inputView = [[UIView alloc] init];
            self.infoTextfield.inputView = self.datePicker;
            paramsKey = @"birthday";
            break;
        case CEEUserSex:
            self.infoTextfield.placeholder = @"请选择性别";
            if ([self.userInfo.sex isEqualToString:@"1"]) {
                self.infoTextfield.text = @"男";
            } else if([self.userInfo.sex isEqualToString:@"2"]){
                self.infoTextfield.text = @"女";
            }
            
            self.navigationItem.title = @"性别";
            paramsKey = @"sex";
            break;
        case CEEUserHometown:
        {
            self.infoTextfield.placeholder = @"请输入家乡";
            self.infoTextfield.text = self.userInfo.hometown;
            self.navigationItem.title = @"家乡";
            paramsKey = @"hometown";
            [self.infoTextfield.rac_textSignal subscribeNext:^(NSString *number) {
                if (number.length >= 15) {
                    self.infoTextfield.text = [number substringToIndex:15];
                }
            }];
        }
            break;
        case CEEUserFavorite:
        {
            self.infoTextfield.placeholder = @"请输入喜好";
            self.infoTextfield.text = self.userInfo.favorite;
            self.navigationItem.title = @"喜好";
            paramsKey = @"favorite";
            [self.infoTextfield.rac_textSignal subscribeNext:^(NSString *number) {
                if (number.length >= 15) {
                    self.infoTextfield.text = [number substringToIndex:15];
                }
            }];
        }
            break;
        case CEEUserQQ:
        {
            self.infoTextfield.placeholder = @"请输入QQ号";
            self.infoTextfield.text = self.userInfo.qq;
            self.infoTextfield.keyboardType = UIKeyboardTypeNumberPad;
            self.navigationItem.title = @"QQ";
            paramsKey = @"qq";
            
            [self.infoTextfield.rac_textSignal subscribeNext:^(NSString *number) {
                NSCharacterSet* cs = [[NSCharacterSet  characterSetWithCharactersInString:kLETTERNUM]  invertedSet];
                NSString* filtered = [[self.infoTextfield.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                self.infoTextfield.text = filtered;
                if (number.length >= 11) {
                    self.infoTextfield.text = [number substringToIndex:11];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.infoType == CEEUserSex) {
        [self.sheet showInView:self.view];
        
        return NO;
    }
    return YES;
}

- (void) saveAction{
    [self.infoTextfield resignFirstResponder];
    if ([CEEUtils NoNetFunc]) {
        MB_NONETCONECTING;
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    if (self.infoType == CEEUserSex) {
        if ([self.infoTextfield.text isEqualToString:@"男"]) {
            [dic setObject:@"1" forKey:paramsKey];
        } else if([self.infoTextfield.text isEqualToString:@"女"]){
            [dic setObject:@"2" forKey:paramsKey];
        }
    } else{
        [dic setObject:self.infoTextfield.text forKey:paramsKey];
    }
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
        
        [self changeUserInfo];
        
        [CEEUtils saveUserInfoToLocal:[self.userInfo yy_modelToJSONString]];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_USERINFO_CHANGE object:nil];
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
            if ([self.infoTextfield.text isEqualToString:@"男"]) {
                self.userInfo.sex = @"1";
            } else if([self.infoTextfield.text isEqualToString:@"女"]){
                self.userInfo.sex = @"2";
            }
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

- (void) initDatePicker{
    self.datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 162)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [self.datePicker setMinimumDate:[dateFormatter dateFromString:@"1900-01-01"]];
    self.datePicker.maximumDate = currentTime;
    
    [self.datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
}

- (void)initActionSheet{
    self.sheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.infoTextfield.text = @"男";
    } else if(buttonIndex == 1){
        self.infoTextfield.text = @"女";
    }
    NSLog(@"%ld", buttonIndex);
}

-(void)selectDate:(id)sender
{
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[outputFormatter stringFromDate:self.datePicker.date];
    self.infoTextfield.text=str;
    
    NSLog(@"%@",self.datePicker.date);
    NSLog(@"%@",str);
}

@end
