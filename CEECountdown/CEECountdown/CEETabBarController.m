//
//  CEETabBarController.m
//  CEECountdown
//
//  Created by Tony L on 7/7/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CEETabBarController.h"
#import "CountDownViewController.h"
#import "CEENavigationViewController.h"

@interface CEETabBarController ()

@end

@implementation CEETabBarController

+ (void)initialize {
//    [UITabBar appearance].translucent = NO;
//    [[UITabBar appearance] setBackgroundColor:CEETabBarNormalColor];
    
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:11];
    normalAttrs[NSForegroundColorAttributeName] = CEETabBarNormalColor;
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = normalAttrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = CEETabBarSelectColor;
    
    UITabBarItem *appearance = [UITabBarItem appearance];
    [appearance setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [appearance setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    UITabBar *barAppearance = [UITabBar appearance];
    barAppearance.barTintColor = CEETabBarTintColor;
    barAppearance.translucent = NO;
}

- (void)viewDidLoad {
    [self setupChildViewController:[[CountDownViewController alloc] init]
                             title:@"倒计时"
                             image:@"bar_countdown"
                     selectedImage:@"bar_countdown_select"];
//    [self setupChildViewController:[[CountDownViewController alloc] init]
//                             title:@"吐槽弹幕"
//                             image:@"bar_barrage"
//                     selectedImage:@"bar_barrage_select"];
//    [self setupChildViewController:[[CountDownViewController alloc] init]
//                             title:@"对对碰"
//                             image:@"bar_concentration"
//                     selectedImage:@"bar_concentration_select"];
    [self setupChildViewController:[[CountDownViewController alloc] init]
                             title:@"高考日历"
                             image:@"bar_calendar"
                     selectedImage:@"bar_calendar_select"];
}

- (void)setupChildViewController:(UIViewController *)childController
                           title:(NSString *)title
                           image:(NSString *)image
                   selectedImage:(NSString *)selectedImage {
    childController.title = title;
    [childController.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    CEENavigationViewController *navCon = [[CEENavigationViewController alloc] initWithRootViewController:childController];
    navCon.title = @"2017高考倒计时";
    
    [self addChildViewController:navCon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
