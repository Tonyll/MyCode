//
//  CEEAlertView.h
//  CEECountdown
//
//  Created by Tony L on 7/12/16.
//  Copyright © 2016 com.jiemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEEAlertView : UIAlertView

/**
 *  AlertView
 *
 *  @param title             <#title description#>
 *  @param message           <#message description#>
 *  @param block             <#block description#>
 *  @param cancelButtonTitle <#cancelButtonTitle description#>
 *  @param otherButtonTitles <#otherButtonTitles description#>
 *
 *  @return <#return value description#>
 */
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
         completionBlock:(void (^)(NSUInteger buttonIndex, CEEAlertView *alertView))block
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
