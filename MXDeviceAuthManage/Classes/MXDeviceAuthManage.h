//
//  MXDeviceAuthManage.h
//  BOB
//
//  Created by mac on 2021/6/7.
//  Copyright © 2021 xxxxx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MXDeviceAuthorization) {
    ///麦克风权限
    MXDeviceAuthorizationMicrophone,
    ///手机通讯录
    MXDeviceAuthorizationAddressBook,
    ///相机
    MXDeviceAuthorizationCamera,
    ///日历
    MXDeviceAuthorizationCalendars,
    ///提醒事项
    MXDeviceAuthorizationReminders,
    ///通知
    MXDeviceAuthorizationNotification,
};

@interface MXDeviceAuthManage : NSObject

///获取设备权限
+ (void)requestDeviceAuthod:(MXDeviceAuthorization)authType complete:(void(^)(BOOL follow))complete;
///未开启权限时的提示弹窗
+ (void)alterDeviceAuthod:(MXDeviceAuthorization)authType complete:(void(^)(BOOL))complete;

@end
