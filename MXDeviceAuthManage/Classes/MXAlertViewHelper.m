//
//  MXAlertViewHelper.m
//  MXDeviceAuthManage
//
//  Created by mac on 2021/6/7.
//

#import "MXAlertViewHelper.h"

@implementation MXAlertViewHelper

+ (void)showAlertViewWithMessage:(NSString*)message
                           title:(NSString*)title
                         okTitle:(NSString*)okTitle
                     cancelTitle:(NSString*)cancelTitle
                      completion:(MXAlertViewCompletionBlock)completion {
    message = message?:@"";
    title = title?:@"";
    okTitle = okTitle?:@"";
    cancelTitle = cancelTitle?:@"";
    
    UIAlertController *control = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
        if (completion) {
            completion(YES, 0);
        }
    }];
    [control addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
        if (completion) {
            completion(NO, 1);
        }
    }];
    [control addAction:okAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:control
                                                                                 animated:YES completion:nil];
}

@end
