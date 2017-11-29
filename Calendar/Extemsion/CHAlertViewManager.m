//
//  CHAlertViewManager.m
//  YMStars
//
//  Created by HFY on 2017/9/5.
//  Copyright © 2017年 厦门市云梦星辰科技有限公司. All rights reserved.
//

#import "CHAlertViewManager.h"

@implementation CHAlertViewManager

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       textFieldNumber:(NSUInteger)textFieldNumber
          actionNumber:(NSUInteger)actionNumber
          actionTitles:(NSArray *)actionTitle
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(actionHandler)actionHandler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (textFieldNumber > 0) {
        for (int i = 0; i < textFieldNumber; i++) {
            [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textFieldHandler(textField, i);
            }];
        }
    }
    if (actionNumber > 0) {
        for (NSUInteger i = 0; i < actionNumber; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}


+ (void)actionSheettWithTitle:(NSString *)title
                      message:(NSString *)message
                 actionNumber:(NSUInteger)actionNumber
                 actionTitles:(NSArray *)actionTitle
                actionHandler:(actionHandler)actionHandler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (actionNumber > 0) {
        for (NSUInteger i = 0; i < actionNumber; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}




@end
