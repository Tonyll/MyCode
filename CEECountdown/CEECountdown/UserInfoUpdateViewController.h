//
//  UserInfoUpdateViewController.h
//  CEECountdown
//
//  Created by Tony L on 7/15/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoUpdateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *infoTextfield;

@property (assign, nonatomic) NSInteger infoType;

@property (strong, nonatomic) UserModel *userInfo;

@end
