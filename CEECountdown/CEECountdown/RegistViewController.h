//
//  RegistViewController.h
//  CEECountdown
//
//  Created by Tony L on 7/18/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *telNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *captchaButton;

@property (assign, nonatomic) NSInteger vcType;//1:注册 2:找回密码

- (IBAction)registAction:(id)sender;
- (IBAction)showPwdAction:(id)sender;
- (IBAction)postAction:(id)sender;

@property (nonatomic,copy)NSString * deviceid;//设备编号

@end
