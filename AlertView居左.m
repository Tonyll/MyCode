#pragma mark -
#pragma mark - alert delegate
- (void) willPresentAlertView:(UIAlertView *)alertView
{
    //由于不希望标题也居左
   NSInteger labelIndex = 1;
    //在ios7.0一下版本这个方法是可以的
   for (UIView *subViewin alertView.subviews)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        {
           if ([subView isKindOfClass: [UILabelclass]])
            {
               if (labelIndex > 1)
                {
                   UILabel *tmpLabel = (UILabel *)subView;
                    tmpLabel.textAlignment =NSTextAlignmentLeft;
                }
               //过滤掉标题
                labelIndex ++;
            }
        }
    }
}
但这只能在ios7.0以下版本可以生效；如果是8.0，处理方式还不一样，具体如下：
- (void) showAlertWithMessage:(NSString *) message
{
    //8.0
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ffff" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        //行间距
        paragraphStyle.lineSpacing = 5.0;
        
        NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18.0], NSParagraphStyleAttributeName : paragraphStyle};
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedTitle addAttributes:attributes range:NSMakeRange(0, message.length)];
        [alertController setValue:attributedTitle forKey:@"attributedMessage"];//attributedTitle\attributedMessage
        //end ---
        
        
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"cancel"
                                                                style: UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  UITextField *textField = alertController.textFields[0];
                                                                  NSLog(@"text was %@", textField.text);
                                                              }];
        UIAlertAction *defaultAction2 = [UIAlertAction actionWithTitle:@"ok"
                                                                style: UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  NSLog(@"ok btn");
                                                                  
                                                                  [alertController dismissViewControllerAnimated:YES completion:nil];

                                                              }];

        [alertController addAction:defaultAction1];
        [alertController addAction:defaultAction2];
        //添加textfield

        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:alertController animated: YES completion: nil];

    }else{
        
        UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"测试换行"
                                                               message:message
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"知道了", nil];
        
        //如果你的系统大于等于7.0
         
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            CGSize size = [self.messageString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(240, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, size.height)];
            textLabel.font = [UIFont systemFontOfSize:15];
            textLabel.textColor = [UIColor blackColor];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            textLabel.numberOfLines = 0;
            textLabel.textAlignment = NSTextAlignmentLeft;
            textLabel.text = self.messageString;
            [tmpAlertView setValue:textLabel forKey:@"accessoryView"];
            
            //这个地方别忘了把alertview的message设为空
            tmpAlertView.message = @"";
            
        }
        
        [tmpAlertView show];
    }
    
}