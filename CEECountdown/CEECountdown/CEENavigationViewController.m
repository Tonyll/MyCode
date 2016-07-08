//
//  CEENavigationViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/7/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CEENavigationViewController.h"

@interface CEENavigationViewController ()

@end

@implementation CEENavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = CEENavColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        // 替换back按钮
//        UIBarButtonItem *backBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"backStretchBackgroundNormal"
//                                                                         imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)
//                                                                                  target:self
//                                                                                  action:@selector(back)];
//        viewController.navigationItem.leftBarButtonItem = backBarButtonItem;
//        // 隐藏tabbar
//        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (NSString *)title{
    return @"2017高考倒计时";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
