//
//  MXAlertHelper.h
//  MXDeviceAuthManage
//
//  Created by mac on 2021/6/7.
//

#import <Foundation/Foundation.h>

typedef void(^MXAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);

NS_ASSUME_NONNULL_BEGIN

@interface MXAlertHelper : NSObject

+ (void)showAlertViewWithMessage:(NSString*)message
                           title:(NSString*)title
                         okTitle:(NSString*)okTitle
                     cancelTitle:(NSString*)cancelTitle
                      completion:(MXAlertViewCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
