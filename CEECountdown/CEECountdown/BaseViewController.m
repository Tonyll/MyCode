//
//  BaseViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/12/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"2017高考倒计时";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:CEETabBarSelectColor,NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIButton * navRoad=[[UIButton alloc]init];
    navRoad.frame=CGRectMake(0, 0, 36, 36);
    [navRoad setBackgroundImage:[UIImage imageNamed:@"nav_road"] forState:UIControlStateNormal];
    [navRoad setBackgroundImage:[UIImage imageNamed:@"nav_road_selecte"] forState:UIControlStateHighlighted];
    [navRoad addTarget:self action:@selector(road) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithCustomView:navRoad];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.navigationController.navigationBar.translucent = NO;
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
