//
//  MXDeviceAuthManage.m
//  BOB
//
//  Created by mac on 2021/6/7.
//  Copyright © 2021 xxxxx. All rights reserved.
//

#import "MXDeviceAuthManage.h"
#import "MXAlertViewHelper.h"

#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <EventKit/EventKit.h>
#import <UserNotifications/UserNotifications.h>

/*! 主线程异步队列 */
#define MXBlock_Exec_Main_Async_Safe(block)        \
    if ([NSThread isMainThread]) {                 \
        block();                                       \
    } else {                                       \
        dispatch_async(dispatch_get_main_queue(), block);\
}

@implementation MXDeviceAuthManage

#pragma mark - 获取设备权限
+ (void)requestDeviceAuthod:(MXDeviceAuthorization)authType complete:(void(^)(BOOL follow))complete {
    switch (authType) {
        case MXDeviceAuthorizationMicrophone: {
            [self requestAuthodMicrophoneStatus:complete];
            break;
        }
        case MXDeviceAuthorizationAddressBook: {
            [self requestAuthodAddressBookStatus:complete];
            break;
        }
        case MXDeviceAuthorizationCamera: {
            [self requestAuthodCameraStatus:complete];
            break;
        }
        case MXDeviceAuthorizationCalendars: {
            [self requestAuthodCalendarsStatus:complete];
            break;
        }
        case MXDeviceAuthorizationReminders: {
            [self requestAuthodRemindersStatus:complete];
            break;
        }
        case MXDeviceAuthorizationNotification: {
            [self requestAuthodNotificationStatus:complete];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 麦克风权限状态状态
+ (void)requestAuthodMicrophoneStatus:(void(^)(BOOL))complete {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        [self requestAuthodMicrophone:complete];
    } else if (status == AVAuthorizationStatusAuthorized) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(YES);
            }
        }));
    } else {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(NO);
            }
        }));
    }
}

#pragma mark - 通讯录权限状态
+ (void)requestAuthodAddressBookStatus:(void(^)(BOOL))complete {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (CNAuthorizationStatusNotDetermined == status) {
        [self requestAuthodAddressBook:complete];
    } else if(CNAuthorizationStatusAuthorized == status) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(YES);
            }
        }));
    } else {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(NO);
            }
        }));
    }
}

#pragma mark - 相机权限状态
+ (void)requestAuthodCameraStatus:(void(^)(BOOL))complete {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (AVAuthorizationStatusNotDetermined == status) {
        [self requestAuthodCamera:complete];
    } else if(AVAuthorizationStatusAuthorized == status) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(YES);
            }
        }));
    } else {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(NO);
            }
        }));
        
    }
}

#pragma mark - 日历权限状态
+ (void)requestAuthodCalendarsStatus:(void(^)(BOOL))complete {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (EKAuthorizationStatusNotDetermined == status) {
        [self requestAuthodCalendar:complete];
    } else if(EKAuthorizationStatusAuthorized == status) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(YES);
            }
        }));
    } else {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(NO);
            }
        }));
        
    }
}

#pragma mark - 获取提醒事项权限状态
+ (void)requestAuthodRemindersStatus:(void(^)(BOOL))complete {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (EKAuthorizationStatusNotDetermined == status) {
        [self requestAuthodReminder:complete];
    } else if(EKAuthorizationStatusAuthorized == status) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(YES);
            }
        }));
    } else {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(NO);
            }
        }));
    }
}

#pragma mark - 获取通知权限状态
+ (void)requestAuthodNotificationStatus:(void(^)(BOOL))complete {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            UNAuthorizationStatus status = settings.authorizationStatus;
            if (UNAuthorizationStatusNotDetermined == status) {
                [self requestAuthodNotification:complete];
            } else if(UNAuthorizationStatusAuthorized == status) {
                MXBlock_Exec_Main_Async_Safe((^{
                    if (complete) {
                        complete(YES);
                    }
                }));
            } else {
                MXBlock_Exec_Main_Async_Safe((^{
                    if (complete) {
                        complete(NO);
                    }
                }));
            }
        }];
    } else {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(NO);
            }
        }));
    }
}

#pragma mark - 获取麦克风权限
+ (void)requestAuthodMicrophone:(void(^)(BOOL))complete {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(granted);
            }
        }));
    }];
}

#pragma mark - 获取通讯录
+ (void)requestAuthodAddressBook:(void(^)(BOOL))complete {
    CNContactStore *store = [CNContactStore new];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(granted);
            }
        }));
    }];
}

#pragma mark - 获取相机权限
+ (void)requestAuthodCamera:(void(^)(BOOL))complete {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(granted);
            }
        }));
    }];
}

#pragma mark - 获取日历权限
+ (void)requestAuthodCalendar:(void(^)(BOOL))complete {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(granted);
            }
        }));
    }];
}

#pragma mark - 获取提醒权限
+ (void)requestAuthodReminder:(void(^)(BOOL))complete {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(granted);
            }
        }));
    }];
}

#pragma mark - 获取通知权限
+ (void)requestAuthodNotification:(void(^)(BOOL))complete {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        MXBlock_Exec_Main_Async_Safe((^{
            if (complete) {
                complete(granted);
            }
        }));
    }];
}

+ (void)alterDeviceAuthod:(MXDeviceAuthorization)authType complete:(void(^)(BOOL))complete{
    NSString *trips = [self authodTrips:authType];
    [MXAlertViewHelper showAlertViewWithMessage:trips title:@"提示"
                                        okTitle:@"去设置"
                                    cancelTitle:@"取消"
                                     completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (cancelled) {
            MXBlock_Exec_Main_Async_Safe((^{
                if (complete) {
                    complete(NO);
                }
            }));
            return;
        }
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            UIApplication *application = [UIApplication sharedApplication];
            if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [application openURL:url options:@{} completionHandler:nil];
            } else {
                [application openURL:url options:@{UIApplicationLaunchOptionsURLKey : @YES} completionHandler:nil];
            }
        }
    }];
}

+ (NSString *)authodTrips:(MXDeviceAuthorization)authType {
    NSString *trip;
    NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
    trip = infoDic[[self authodInfoKey:authType]]?:@"";
    return trip;
}

+ (NSString *)authodInfoKey:(MXDeviceAuthorization)authType {
    NSString *key = @"";
    switch (authType) {
        case MXDeviceAuthorizationMicrophone:
            key = @"NSMicrophoneUsageDescription";
            break;
        case MXDeviceAuthorizationAddressBook:
            key = @"NSContactsUsageDescription";
            break;
        case MXDeviceAuthorizationCamera:
            key = @"NSCameraUsageDescription";
            break;
        case MXDeviceAuthorizationCalendars:
            key = @"NSCalendarsUsageDescription";
            break;
        case MXDeviceAuthorizationReminders:
            key = @"NSRemindersUsageDescription";
            break;
        case MXDeviceAuthorizationNotification:
            key = @"";
            break;
        default:
            break;
    }
    return key;
}

@end
