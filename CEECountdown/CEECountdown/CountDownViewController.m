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
    NSString *_countdownDayVal;
    
    
    UIColor *_hourColor;
    UIColor *_minColor;
    UIColor *_secColor;
    
    NSString *_remainDay;//距离高考剩余天数
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
    
    [self initData];
    [self setupSubViews];
    [self calculateDays];
    
    self.navigationItem.title = @"2017高考倒计时";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:CEETabBarSelectColor,NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *aDate = [df dateFromString: @"2017/06/07 9:00:00"];
    [self countDown:aDate];
}

- (void)initData{
    colorArr = @[@0xec6941, @0x01a4e5, @0xe4007f, @0x22ac38, @0xae5da1, @0x0068b7, @0x920783, @0x097c25, @0x7d0022, @0xe60012];
    
    _hourColor = RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]);
    _minColor = RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]);
    _secColor = RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]);
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

        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        NSDateFormatter * df = [[NSDateFormatter alloc] init ];
        [df setDateFormat:@"yyyy年MM月dd日"];
        NSString * na = [df stringFromDate:currentDate];
        
        timeLabel.text = na;
        timeLabel.textColor = CEECountDownFontColor;
        timeLabel.font = [UIFont systemFontOfSize:26];
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
        _countdownDayVal = @"";
        [self setUpDayLabelVal];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [_dayView addSubview:_dayLabel];
        [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_dayView).mas_offset(CGPointMake(0, -10));
            make.top.mas_equalTo(_dayView).mas_offset(10);
            make.bottom.mas_equalTo(_dayView).mas_offset(-10);
        }];
        
        self.countdownLabel = [[UILabel alloc] init];
        _countdownLabelTextVal = @"";
        [_countdownView addSubview:self.countdownLabel];
        [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.left.right.mas_equalTo(_countdownView);
            make.top.mas_equalTo(_countdownView).offset(20);
        }];
    }
    
    {
        _bottomDayLabel = [[UILabel alloc] init];
        _bottomDayLabel.textAlignment = NSTextAlignmentCenter;
        _bottomDayLabel.text = [NSString stringWithFormat:@"去除周末实际仅剩%@天",_remainDay];
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

- (void) setUpDayLabelVal{
    if (_countdownDayVal.length > 0) {
        NSInteger dayLabelLength = _countdownDayVal.length;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_countdownDayVal];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:120] range:NSMakeRange(0, _countdownDayVal.length - 1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:NSMakeRange(_countdownDayVal.length - 1, 1)];
        for (int i = 0; i<(dayLabelLength - 1); i++) {
            [attrStr addAttribute:NSForegroundColorAttributeName value:RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]) range:NSMakeRange(i, 1)];
        }
        
        self.dayLabel.attributedText = attrStr;
    }
}

- (void)setUpCountCountdownLabel{
    NSArray *_countdownLabelVal = [_countdownLabelTextVal componentsSeparatedByString:@":"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:_countdownLabelTextVal];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Digital-7" size:30] range:NSMakeRange(0, _countdownLabelTextVal.length)];
    int indexVal = 0;
    if (_countdownLabelTextVal.length != 0) {
        for (int i = 0; i < [_countdownLabelVal count]; i++) {
            if (i == 0) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:_hourColor range:NSMakeRange(0, [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length + 1)];
            }else if (i < ([_countdownLabelVal count] - 1)) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:_minColor range:NSMakeRange(indexVal, [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length + 1)];
            }else if (i == ([_countdownLabelVal count] - 1)) {
                [attrStr addAttribute:NSForegroundColorAttributeName value:_secColor range:NSMakeRange(indexVal, [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length)];
            }
            indexVal += [NSString stringWithFormat:@"%@",[_countdownLabelVal objectAtIndex:i]].length + 1;
        }
    }
    self.countdownLabel.attributedText = attrStr;
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
}

//GCD
- (void)countDown:(NSDate *)futureDate{
    WeakSelf;
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
            int day = timeout/(3600*24);
            int hour = (timeout - day*(3600*24))/3600.0;
            int min = (timeout - day*(3600*24) - hour*3600)/60;
            int sec = (timeout - day*(3600*24) - hour*3600 - min*60);
            NSString *minStr;
            NSString *secStr;
            if (min < 10) {
                minStr = [NSString stringWithFormat:@"0%d", min];
            } else{
                minStr = [NSString stringWithFormat:@"%d", min];
            }
            if (sec < 10) {
                secStr = [NSString stringWithFormat:@"0%d", sec];
            } else{
                secStr = [NSString stringWithFormat:@"%d", sec];
            }
            _countdownLabelTextVal = [NSString stringWithFormat:@"%d:%@:%@",hour + day * 24,minStr,secStr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *tmpDayVal = [NSString stringWithFormat:@"%d天",day];
                if (![_countdownDayVal isEqualToString:tmpDayVal]) {
                    _countdownDayVal = tmpDayVal;
                    [weakSelf setUpDayLabelVal];
                }
                if (sec == 0) {
                    _minColor = RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]);
                    _secColor = RGBAHEX([[colorArr objectAtIndex:(arc4random() % [colorArr count])] integerValue]);
                }
                [weakSelf setUpCountCountdownLabel];
            });
        }
    });
    dispatch_resume(_timer);
}

/**
 *  计算剩余时间 去除周么
 */
- (void)calculateDays
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:@"2017-6-7"];
    
    NSDate *date = [NSDate date];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:date];
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int totalWeek = days / 7;
    int yuDay = days % 7;
    int lastDay = 0;
    if (yuDay == 0) {
        lastDay = days - (totalWeek * 2);
    } else{
        int weekDay = 0;
        int endWeekDay = 0;
        weekDay = comps.weekday == 0 ? 7 : (int)comps.weekday;
        
        if ((weekDay == 6 && yuDay >= 2) || (weekDay == 7 && yuDay >= 1) || (weekDay == 5 && yuDay >= 3) || (weekDay == 4 && yuDay >= 4) || (weekDay == 3 && yuDay >= 5) || (weekDay == 2 && yuDay >= 6) || (weekDay == 1 && yuDay >=7))
        {
            endWeekDay =2;
        }
        if ((weekDay == 6 && yuDay < 1) || (weekDay == 7 && yuDay <5) || (weekDay == 5 && yuDay < 2) || (weekDay == 4 && yuDay < 3) || (weekDay == 3 && yuDay < 4) || (weekDay == 2 && yuDay < 5) || (weekDay == 1 && yuDay < 6))          {
            endWeekDay = 1;
        }
        lastDay = days - (totalWeek * 2) - endWeekDay + 1;
    }
    _remainDay = [NSString stringWithFormat:@"%d",lastDay];;
    _bottomDayLabel.text = [NSString stringWithFormat:@"去除周末实际仅剩%@天",_remainDay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
