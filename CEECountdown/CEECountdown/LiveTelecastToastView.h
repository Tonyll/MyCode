//
//  LiveTelecastToastView.h
//  jiemoquan
//
//  Created by Tony L on 7/21/16.
//  Copyright © 2016 IvanMacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LiveTelecastToastViewCallBack)(NSString *confirmCode);

@interface LiveTelecastToastView : UIView

@property (nonatomic, copy) LiveTelecastToastViewCallBack confirmCallBack;

+ (void)show;
+ (void)showWithOverlay:(NSString *)liveId andCallBack:(LiveTelecastToastViewCallBack)callBack;

+ (void)dismiss;

- (void)viewMoveUp;

- (void)viewMoveDown;

//- (void)confirmSelectedCallback:(LiveTelecastToastViewCallBack)callback;


@end
