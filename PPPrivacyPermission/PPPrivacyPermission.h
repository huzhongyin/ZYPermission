//
//  PPPrivacyPermission.h
//  PPCarServiceBusiness
//
//  Created by niwanglong on 2018/7/12.
//  Copyright © 2018年 wanhuizulin. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger,PrivacyPermissionType) {
    PrivacyPermissionTypePhoto = 0,//相册
    PrivacyPermissionTypeCamera,//相机
    PrivacyPermissionTypeMedia,//媒体资料库
    PrivacyPermissionTypeMicrophone,//麦克风
    PrivacyPermissionTypeLocation,//定位
    PrivacyPermissionTypeBluetooth,//蓝牙
    PrivacyPermissionTypePushNotification,//通知
    PrivacyPermissionTypeSpeech,//语音识别
    PrivacyPermissionTypeEvent,//日历事件
    PrivacyPermissionTypeContact,//通讯录
    PrivacyPermissionTypeReminder,//备忘录
};

typedef NS_ENUM(NSUInteger,PrivacyPermissionAuthorizationStatus) {
    PrivacyPermissionAuthorizationStatusAuthorized = 0,
    PrivacyPermissionAuthorizationStatusDenied,
    PrivacyPermissionAuthorizationStatusNotDetermined,
    PrivacyPermissionAuthorizationStatusRestricted,
    PrivacyPermissionAuthorizationStatusLocationAlways,
    PrivacyPermissionAuthorizationStatusLocationWhenInUse,
    PrivacyPermissionAuthorizationStatusUnkonwn,
};
@interface PPPrivacyPermission : NSObject

+ (instancetype)sharedInstance;
/**
 获取权限状态
 
 @param type 获取权限枚举类型
 @return 权限状态
 */
- (PrivacyPermissionAuthorizationStatus)authorizationStatus:(PrivacyPermissionType)type;

/**
 获取权限函数(自动弹框显示)

 @param type 权限类型
 @param completion 是否获权 权限状态
 */
- (void)accessPrivacyPermission:(PrivacyPermissionType)type completion:(void(^)(BOOL granted,PrivacyPermissionAuthorizationStatus status))completion;

/**
 获取授权函数

 @param type 权限类型
 @param autoShowAlert 是否自动显示alert提示
 @param completion 是否获权 权限状态
 */
- (void)accessPrivacyPermission:(PrivacyPermissionType)type autoShowAlert:(BOOL)autoShowAlert completion:(void(^)(BOOL granted,PrivacyPermissionAuthorizationStatus status))completion;
/**
 显示统一的提示
 @param type 权限类型
 */
- (void)displayReEnableAlert:(PrivacyPermissionType)type;
@end
