//
//  CountDownViewController.m
//  CEECountdown
//
//  Created by Tony L on 7/7/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import "CountDownViewController.h"

@interface CountDownViewController (){
    dispatch_source_t _timer;
    NSArray *colorArr;
}

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIView *dayView;
@property (nonatomic, strong) UIView *countdownView;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, strong) UILabel *bottomDayLabel;
@property (nonatomic, strong) UILabel *bottomScrollLabel;

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    colorArr = @[RGBAHEX(0xec6941),RGBAHEX(0x01a4e5),RGBAHEX(0xe4007f),RGBAHEX(0x22ac38),RGBAHEX(0xae5da1),RGBAHEX(0x0068b7),RGBAHEX(0x920783),RGBAHEX(0x097c25),RGBAHEX(0x7d0022),RGBAHEX(0xe60012)];
    
    [self setupSubViews];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd HH:mm:ss";
    NSDate *aDate = [df dateFromString: @"2016/07/08 12:00:00"];
    [self countDown:aDate];
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
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        
        timeLabel.opaque = NO;
        //设置字体格式和大小
        NSString *str0 = @"2017年7月7日";
        NSDictionary *dictAttr0 = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
        NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
        [attributedString appendAttributedString:attr0];
        
        //设置字体颜色
        NSString *str1 = @"";
        NSDictionary *dictAttr1 = @{NSForegroundColorAttributeName:RGBAHEX(0x6a3906)};
        NSAttributedString *attr1 = [[NSAttributedString alloc]initWithString:str1 attributes:dictAttr1];
        [attributedString appendAttributedString:attr1];
        
        timeLabel.attributedText = attributedString;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        [timeLabel sizeToFit];
        
        [_centerView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_centerView).mas_offset(@20);
            make.centerX.width.mas_equalTo(_centerView);
            make.height.mas_equalTo(@20);
        }];
        
        
        _dayView = [[UIView alloc] init];
        _dayView.backgroundColor = [UIColor grayColor];
        [_centerView addSubview:_dayView];
        [_dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_centerView).mas_offset(CGPointMake(0, 10));
            make.height.mas_equalTo(0.4 * (CEEScreenHeight - 55 - 211));
            make.left.right.mas_equalTo(_centerView);
        }];
        
        _countdownView = [[UIView alloc] init];
        _countdownView.backgroundColor = [UIColor darkGrayColor];
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
            make.center.mas_equalTo(_dayView).mas_offset(CGPointMake(-10, 0));
            make.top.mas_equalTo(_dayView).mas_offset(10);
            make.bottom.mas_equalTo(_dayView).mas_offset(-10);
        }];
        
        
        _countdownLabel = [[UILabel alloc] init];
        _countdownLabel.text = @"1296:49:03";
        _countdownLabel.textAlignment = NSTextAlignmentCenter;
        [_countdownView addSubview:_countdownLabel];
        [_countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.top.left.right.mas_equalTo(_countdownView);
        }];
        
    }
    
    {
        _bottomDayLabel = [[UILabel alloc] init];
        _bottomDayLabel.textAlignment = NSTextAlignmentCenter;
        _bottomDayLabel.text = @"去除周末实际仅剩40天";
        _bottomDayLabel.textColor = CEECountDownFontColor;
        [_bottomView addSubview:_bottomDayLabel];
        [_bottomDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_bottomView).mas_offset(CGPointMake(0, -15));
            make.left.right.mas_equalTo(_bottomView);
            make.height.mas_equalTo(15);
        }];
        
        _bottomScrollLabel = [[UILabel alloc] init];
        _bottomScrollLabel.textAlignment = NSTextAlignmentCenter;
        _bottomScrollLabel.text = @"去除周末实际仅剩40天";
        _bottomScrollLabel.textColor = CEECountDownFontColor;
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
            NSArray *arr = @[@(day),@(hour),@(min),@(sec)];
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
