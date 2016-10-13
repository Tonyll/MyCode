//
//  LiveTelecastToastView.m
//  jiemoquan
//
//  Created by Tony L on 7/21/16.
//  Copyright © 2016 IvanMacAir. All rights reserved.
//

#import "LiveTelecastToastView.h"
#import "AppDelegate.h"
#import <Masonry.h>

#define FadeDuration    0.3
#define APPDELEGATE     ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface LiveTelecastToastView ()

+ (instancetype)instance;

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *toastView;
//@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic, strong) UIImageView *labelBorderImgView;
@property (nonatomic, strong) UITextField *inputTextField;//请输入听课证号
@property (nonatomic, strong) UIImageView *errorImgView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, assign) BOOL shown;

@property (nonatomic, assign) BOOL keyboardIsShow;

@property (copy, nonatomic) LiveTelecastToastViewCallBack callback;

@property (nonatomic, strong) NSString *toastLiveId;

@end

@implementation LiveTelecastToastView

#pragma mark Lifecycle

static LiveTelecastToastView *instance;


+ (instancetype)instance {
    if (!instance) {
        instance = [[LiveTelecastToastView alloc] init];
    }
    return instance;
}

- (instancetype)init {
    if ((self = [super initWithFrame:CGRectMake(0, 0, 253, 320 + 63)])) {
        
        [self setAlpha:0];
        [self setCenter:CGPointMake(APPDELEGATE.window.center.x, APPDELEGATE.window.center.y)];
        [self.layer setBackgroundColor:[UIColor clearColor].CGColor];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        
        self.toastView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.toastView.layer setBackgroundColor:[UIColor whiteColor].CGColor];
        [self.toastView.layer setCornerRadius:10];
        [self addSubview:self.toastView];
        [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.height.mas_equalTo(320);
        }];
        
        
        self.headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.headerView.image = [UIImage imageNamed:@"live_toast_head"];
        [self.toastView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(self.toastView);
            make.height.mas_equalTo(@70);
        }];
        
        self.labelBorderImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.labelBorderImgView.image = [UIImage imageNamed:@"live_toast_input_border"];
        self.labelBorderImgView.userInteractionEnabled = YES;
        [self.toastView addSubview:self.labelBorderImgView];
        [self.labelBorderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.toastView).mas_offset(15);
            make.right.mas_equalTo(self.toastView).mas_offset(-15);
            make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(@20);
            make.height.mas_equalTo(@35);
        }];
        
        self.inputTextField = [[UITextField alloc] initWithFrame:CGRectZero];

        self.inputTextField.placeholder = @"请输入听课号";
        self.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.inputTextField.textAlignment = NSTextAlignmentLeft;
        self.inputTextField.borderStyle = UITextBorderStyleNone;
        [self.labelBorderImgView addSubview:self.inputTextField];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            UIEdgeInsets padding = UIEdgeInsetsMake(5, 10, 5, 30);
            make.edges.equalTo(self.labelBorderImgView).with.insets(padding);
        }];
        
        self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmBtn setTintColor:[UIColor whiteColor]];
        [self.confirmBtn setBackgroundColor:RGBAHEX(0x17a3e5)];
        [self.confirmBtn.layer setMasksToBounds:YES];
        [self.confirmBtn.layer setCornerRadius: 35.0/2];
        [self.confirmBtn addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.toastView addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(104);
            make.height.mas_equalTo(35);
            make.centerX.mas_equalTo(self.toastView);
            make.bottom.mas_equalTo(self.toastView.mas_bottom).mas_offset(-20);
        }];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"live_toast_cancel"] forState:UIControlStateNormal];
        [self.cancelBtn setTintColor:[UIColor whiteColor]];
        self.cancelBtn.userInteractionEnabled = YES;
        [self.cancelBtn.layer setMasksToBounds:YES];
        [self.cancelBtn.layer setCornerRadius: 35.0/2];
        [self.cancelBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(35);
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        [APPDELEGATE.window addSubview:self];
        
        [self.inputTextField.rac_textSignal subscribeNext:^(NSString *number) {
            if (number.length >= 4) {
                self.inputTextField.text = [number substringToIndex:4];
            }
        }];
    }
    return self;
}

#pragma mark HUD

+ (void)showWithOverlay:(NSString *)liveId andCallBack:(LiveTelecastToastViewCallBack)callBack{
    [[self instance] setConfirmCallBack:callBack];
    [[self instance] setToastLiveId:liveId];
    [self dismiss:^{
        [APPDELEGATE.window addSubview:[[self instance] overlay1]];
        [self show];
    }];
}

+ (void)show {
    [self dismiss:^{
        [APPDELEGATE.window bringSubviewToFront:[self instance]];
        [[self instance] setShown:YES];
        [[self instance] toastFadeIn];
    }];
}

- (void)confirmButtonClicked{
    if (self.confirmCallBack) {
        self.confirmCallBack(self.inputTextField.text);
    };
}

- (void)cancelButtonClicked{
    if (!self.shown)
        return;
    [self.overlayView removeFromSuperview];
    [self toastFadeOut];
}


+ (void)dismiss {
    if (![[self instance] shown])
        return;
    
    [[[self instance] overlay1] removeFromSuperview];
    [[self instance] toastFadeOut];
}

+ (void)dismiss:(void(^)(void))complated {
    if (![[self instance] shown])
        return complated ();
    
    [[self instance] fadeOutComplate:^{
        [[[self instance] overlay1] removeFromSuperview];
        complated ();
    }];
}

#pragma mark Effects

- (void)toastFadeIn {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:1];
    }];
}

- (void)toastFadeOut {
    [UIView animateWithDuration:0 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
    }];
}

- (void)fadeOutComplate:(void(^)(void))complated {
    [UIView animateWithDuration:FadeDuration animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setShown:NO];
        complated ();
    }];
}

- (UIView *)overlay1 {
    if (!self.overlayView) {
        self.overlayView = [[UIView alloc] initWithFrame:APPDELEGATE.window.frame];
        [self.overlayView setBackgroundColor:[UIColor blackColor]];
        [self.overlayView setAlpha:0];
        
        [UIView animateWithDuration:FadeDuration animations:^{
            [self.overlayView setAlpha:0.8];
        }];
    }
    return self.overlayView;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.inputTextField isExclusiveTouch]) {
        [self.inputTextField resignFirstResponder];
    }
}

/**
 *  键盘弹出 view上移
 */
- (void)viewMoveUp{
    
    if (!_keyboardIsShow) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint point = self.center;
            point.y = point.y - 40;
            self.center = point;
        }];
    }
    _keyboardIsShow = YES;
}

- (void)viewMoveDown{
    if (_keyboardIsShow) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint point = self.center;
            point.y = point.y + 40;
            self.center = point;
        }];
        _keyboardIsShow = NO;
    }
}

- (void)confirmSelectedCallback:(LiveTelecastToastViewCallBack)callback{
    _callback = callback;
}

@end
