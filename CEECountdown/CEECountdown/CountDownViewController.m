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
}

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *centerView;

@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
            make.top.mas_equalTo(_centerView).mas_offset(@15);
            make.centerX.width.mas_equalTo(_centerView);
            make.height.mas_equalTo(@20);
        }];
        
        
        UIView *dayView = [[UIView alloc] init];
        dayView.backgroundColor = [UIColor grayColor];
        [_centerView addSubview:dayView];
        [dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_centerView);
            make.height.mas_equalTo(@120);
            make.left.right.mas_equalTo(_centerView);
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
