//
//  CHViewController.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/28.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "CHViewController.h"

@interface CHViewController ()
@property (nonatomic, copy) void (^whenClickedFirst)(void);
@end

@implementation CHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles block:(void(^)(void))whenClickedFirst completion:(void (^)(void))completion
{
    if (IOS_9_OR_LATER) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:action];
        if (otherTitles&&![otherTitles isBlank]) {
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:otherTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(whenClickedFirst){
                    whenClickedFirst();
                }
            }];
            [ac addAction:action2];
        }
        [self presentViewController:ac animated:YES completion:completion];
    }else{
        UIAlertView *alert = nil ;
        if (![otherTitles isBlank]) {
            alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle  otherButtonTitles:otherTitles,nil];
        }else{
            alert =[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle  otherButtonTitles:otherTitles];
        }
        self.whenClickedFirst = whenClickedFirst ;
        [alert show];
    }
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles block:(void(^)(void))whenClickedFirst
{
    [self alertWithTitle:title message:message cancelTitle:cancelTitle otherTitles:otherTitles block:whenClickedFirst completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.whenClickedFirst) {
            self.whenClickedFirst();
        }
    }
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
