//
//  UserConfigViewController.h
//  CEECountdown
//
//  Created by Tony L on 7/18/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserConfigViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FSMediaPickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) UserModel *userModel;

//@property (nonatomic,copy)NSString * nickName;
//@property (nonatomic,copy)NSString * imageUrl;

@property (nonatomic,weak)id delegate;

@end
