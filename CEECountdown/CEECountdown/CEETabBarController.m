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
#import "CalendarViewController.h"

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
    
    CEENavigationViewController *navCon = [[CEENavigationViewController alloc] initWithRootViewController:[[CountDownViewController alloc] init]];
    CEENavigationViewController *navCon1 = [[CEENavigationViewController alloc] initWithRootViewController:[[CalendarViewController alloc] init]];
    
    self.viewControllers = [NSArray arrayWithObjects:navCon, navCon1, nil];
    
    NSArray *titleArr = @[@"倒计时",@"高考日历"];
    NSArray *imgArr = @[@"bar_countdown",@"bar_calendar"];
    NSArray *imgSelectArr = @[@"bar_countdown_select",@"bar_calendar_select"];
    for (int i = 0 ; i < self.tabBar.items.count;i++) {
        UITabBarItem *item =  [self.tabBar.items objectAtIndex:i];
        item.tag = i;
        item.title = titleArr[i];
        item.image = [[UIImage imageNamed:imgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:imgSelectArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
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
