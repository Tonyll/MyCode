//
//  CountDownViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/7/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CountDownViewController.h"
#import "CBAutoScrollLabel.h"

@interface CountDownViewController (){
    dispatch_source_t _timer;
    NSArray *colorArr;
    NSString *_countdownLabelTextVal;
}

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIView *dayView;
@property (nonatomic, strong) UIView *countdownView;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, strong) UILabel *bottomDayLabel;
@property (nonatomic, strong) CBAutoScrollLabel *bottomScrollLabel;

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    colorArr = @[@0xec6941, @0x01a4e5, @0xe4007f, @0x22ac38, @0xae5da1, @0x0068b7, @0x920783, @0x097c25, @0x7d0022, @0xe60012];
    [self setupSubViews];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *aDate = [df dateFromString: @"2017/06/07 9:00:00"];
    [self countDown:aDate];
    
    NSArray *familys = [UIFont familyNames];
    
    for (int i = 0; i < [familys count]; i++)
    {
        NSString *family = [familys objectAtIndex:i];
        NSLog(@"=====Fontfamily:%@", family);
        NSArray *fonts = [UIFont fontNamesForFamilyName:family];
        for(int j = 0; j < [fonts count]; j++)
        {
            NSLog(@"***FontName:%@", [fonts objectAtIndex:j]);
        }
    }
}

- (void)setupSubViews{
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"countDown_bg"]];
    [self.view addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _centerView = [[UIView alloc] init];
    _centerView.backgroundColor = [UIColor whiteColor];
    _centerView.alpha = 0.6;
    [self.view addSubview:_centerView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.alpha = 0.6;
    [self.view addSubview:_bottomView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(55, 17.5, 211, 17.5);
        make.top.mas_equalTo(self.mas_topLayoutGuide).offset(padding.top);
        make.left.mas_equalTo(self.view).mas_offset(padding.left);
        make.bottom.mas_equalTo(self.view).mas_offset(-padding.bottom);
        make.right.mas_equalTo(self.view).mas_offset(-padding.right);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(79, 17.5, 42, 17.5);
        make.top.mas_equalTo(self.centerView.mas_bottom).mas_offset(padding.top);
        make.left.mas_equalTo(self.view).mas_offset(padding.left);
        make.bottom.mas_equalTo(self.view).mas_offset(-padding.bottom);
        make.right.mas_equalTo(self.view).mas_offset(-padding.right);
    }];
    
    {//centerView subView
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.opaque = NO;
        //设置字体格式和大小
        NSString *str0 = @"2017年7月7日";
        timeLabel.text = str0;
        timeLabel.textColor = CEECountDownFontColor;
        timeLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:28];
        timeLabel.textAlignment = NSTextAlignmentCenter;
//        [timeLabel sizeToFit];
        
        [_centerView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_centerView).mas_offset(@20);
            make.centerX.width.mas_equalTo(_centerView);
            make.height.mas_equalTo(@20);
        }];
        
        _dayView = [[UIView alloc] init];
        [_centerView addSubview:_dayView];
        [_dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_centerView).mas_offset(CGPointMake(0, -10));
            make.height.mas_equalTo(0.4 * (CEEScreenHeight - 55 - 211));
            make.left.right.mas_equalTo(_centerView);
        }];
        
        _countdownView = [[UIView alloc] init];
        [_centerView addSubview:_countdownView];
        [_countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_centerView);
            make.top.mas_equalTo(_dayView.mas_bottom);
        }];
        
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.text = @"154天";
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [_dayView addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_dayView).mas_offset(CGPointMake(0, -10));
            make.top.mas_equalTo(_dayView).mas_offset(10);
            make.bottom.mas_equalTo(_dayView).mas_offset(-10);
        }];
        
        
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabelTextVal = @"1296:49:03";
        NSArray *_countdownLabelVal = [_countdownLabelTextVal componentsSeparatedByString:@":"];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_countdownLabelTextVal];
//        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:16] range:NSMakeRange(0, _countdownLabelTextVal.length)];
        int indexVal = 0;
        for (int i = 0; i < [_countdownLabelVal count]; i++) {
            if (i == 0) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]) range:NSMakeRange(0, [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length + 1)];
            }
            if (i < ([_countdownLabelVal count] - 1)) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]) range:NSMakeRange(indexVal, [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length + 1)];
            }
            if (i == ([_countdownLabelVal count] - 1)) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]) range:NSMakeRange(indexVal, [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length)];
            }
            indexVal += [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length + 1;
        }
        
        _countdownLabel.attributedText = attrStr;
        _countdownLabel.font = [UIFont fontWithName:@"Digital-7" size:16];
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        [_countdownView addSubview:_countdownLabel];
        [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.right.mas_equalTo(_countdownView);
            make.top.mas_equalTo(_countdownView).offset(20);
        }];
    }
    
    {
        _bottomDayLabel = [[UILabel alloc] init];
        _bottomDayLabel.textAlignment = NSTextAlignmentCenter;
        _bottomDayLabel.text = @"去除周末实际仅剩40天";
        _bottomDayLabel.textColor = CEECountDownFontColor;
        _bottomDayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [_bottomView addSubview:_bottomDayLabel];
        [_bottomDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_bottomView).mas_offset(CGPointMake(0, -15));
            make.left.right.mas_equalTo(_bottomView);
            make.height.mas_equalTo(15);
        }];
        
        _bottomScrollLabel = [[CBAutoScrollLabel alloc] init];
        _bottomScrollLabel.textAlignment = NSTextAlignmentCenter;
        _bottomScrollLabel.text = @"2016年高考成绩放榜和分数段公布时间为6月22日晚，考生对成绩有疑问需在6月25日12:00前申请成绩复核登记。6月24日17:00点前，填报本科提前批志愿。";
        _bottomScrollLabel.textColor = CEECountDownFontColor;
        _bottomScrollLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [_bottomView addSubview:_bottomScrollLabel];
        [_bottomScrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_bottomView).mas_offset(CGPointMake(0, 15));
            make.left.right.mas_equalTo(_bottomView);
            make.height.mas_equalTo(15);
        }];
    }
}

//GCD
- (void)countDown:(NSDate *)futureDate{
    NSTimeInterval futureTimeInterval = [futureDate timeIntervalSinceDate:[NSDate date]];
    __block int timeout = futureTimeInterval;
    dispatch_queue_t queue = dispatch_queue_create("com.CEECountdown.countdown", 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout < 0) {
            dispatch_source_cancel(_timer);
            _timer = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"倒计时结束");
            });
        } else{
            timeout--;
            NSLog(@"timeout is %d",timeout);
            int day = timeout/(3600*24);
            int hour = (timeout - day*(3600*24))/3600.0;
            int min = (timeout - day*(3600*24) - hour*3600)/60;
            int sec = (timeout - day*(3600*24) - hour*3600 - min*60);
            NSArray *arr = @[@(day),@(hour + day * 24),@(min),@(sec)];
            NSArray *arrStr = @[@"day",@"hour",@"min",@"sec"];
            //到这里已经可以获取到具体的时差 这边可以显示在你
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%@:%@",arrStr[idx],obj);
            }];
            NSLog(@"------------------------");
        }
        
    });
    dispatch_resume(_timer);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
