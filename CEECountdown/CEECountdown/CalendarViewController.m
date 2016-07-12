//
//  CalendarViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/12/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CalendarViewController.h"
#import "FDCalendar.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
//    [calendar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.bottom.mas_equalTo(self.view);
//    }];
    CGRect frame = calendar.frame;
    frame.origin.y = 64;
    calendar.frame = frame;
    [self.view addSubview:calendar];
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
