//
//  PPPrivacyPermission.m
//  PPCarServiceBusiness
//
//  Created by niwanglong on 2018/7/12.
//  Copyright © 2018年 wanhuizulin. All rights reserved.
//

#import "PPPrivacyPermission.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <EventKit/EventKit.h>
#import <Contacts/Contacts.h>
#import <Speech/Speech.h>
#import <HealthKit/HealthKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

static NSInteger const PrivacyPermissionTypeLocationDistanceFilter = 10; //`Positioning accuracy` -> 定位精度
@interface PPPrivacyPermission()<CLLocationManagerDelegate>
@property (nonatomic,copy) void(^completion)(BOOL granted,PrivacyPermissionAuthorizationStatus status);
@property (nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation PPPrivacyPermission

+ (instancetype)sharedInstance{
    static PPPrivacyPermission *mannage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mannage = [PPPrivacyPermission new];
    });
    return mannage;
}



- (NSString *)permissionName:(PrivacyPermissionType)permissionType{
    switch (permissionType) {
        case PrivacyPermissionTypePhoto:
            return @"照片";
        case PrivacyPermissionTypeCamera:
            return @"相机";
        case PrivacyPermissionTypeMedia:
            return @"媒体资料库";
        case PrivacyPermissionTypeMicrophone:
            return @"麦克风";
        case PrivacyPermissionTypeLocation:
            return @"定位服务";
        case PrivacyPermissionTypeBluetooth:
            return @"蓝牙";
        case PrivacyPermissionTypePushNotification:
            return @"通知";
        case PrivacyPermissionTypeSpeech:
            return @"语音识别";
        case PrivacyPermissionTypeEvent:
            return @"日历事件";
        case PrivacyPermissionTypeContact:
            return @"通讯录";
        case PrivacyPermissionTypeReminder:
            return @"提醒事项";
    }
}

- (PrivacyPermissionAuthorizationStatus)authorizationStatus:(PrivacyPermissionType)type{
    switch (type) {
        case PrivacyPermissionTypePhoto: {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            switch (status) {
                case PHAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case PHAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case PHAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                case PHAuthorizationStatusAuthorized:{
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }break;
                    
                default:
                    break;
            }
        }break;
        case PrivacyPermissionTypeCamera: {
            #if TARGET_IPHONE_SIMULATOR
                NSLog(@"模拟器不支持摄像头");
                return PrivacyPermissionAuthorizationStatusNotDetermined;
            #endif
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            switch (status) {
                case AVAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case AVAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                case AVAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case AVAuthorizationStatusAuthorized:{
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }break;
                default:
                    break;
            }
        }break;
            
        case PrivacyPermissionTypeMedia: {
             if (@available(iOS 9.3, *)) {
                 MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
                 switch (status) {
                     case AVAuthorizationStatusNotDetermined:{
                         return PrivacyPermissionAuthorizationStatusNotDetermined;
                     }break;
                     case MPMediaLibraryAuthorizationStatusRestricted:{
                         return PrivacyPermissionAuthorizationStatusRestricted;
                     }break;
                     case MPMediaLibraryAuthorizationStatusDenied:{
                         return PrivacyPermissionAuthorizationStatusDenied;
                     }break;
                     case MPMediaLibraryAuthorizationStatusAuthorized:{
                         return PrivacyPermissionAuthorizationStatusAuthorized;
                     }break;
                     default:
                         break;
                 }
            }
        }break;
            
        case PrivacyPermissionTypeMicrophone: {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            switch (status) {
                case AVAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case AVAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                case AVAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case AVAuthorizationStatusAuthorized:{
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }break;
                default:
                    break;
            }
        }break;
            
        case PrivacyPermissionTypeLocation: {
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            switch (status) {
                case kCLAuthorizationStatusAuthorizedAlways:{
                    return PrivacyPermissionAuthorizationStatusLocationAlways;
                }break;
                case kCLAuthorizationStatusAuthorizedWhenInUse:{
                    return PrivacyPermissionAuthorizationStatusLocationWhenInUse;
                }break;
                case kCLAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case kCLAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case kCLAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                default:
                    break;
            }
        }break;
            
        case PrivacyPermissionTypeBluetooth: {
            if (@available(iOS 10.0, *)) {
                CBCentralManager *centralManager = [[CBCentralManager alloc] init];
                CBManagerState state = [centralManager state];
                if (state == CBManagerStateUnsupported || state == CBManagerStateUnauthorized || state == CBManagerStateUnknown) {
                    return PrivacyPermissionAuthorizationStatusDenied;
                } else {
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }
            }
        }break;
        case PrivacyPermissionTypeSpeech: {
            if (@available(iOS 10.0, *)) {
                SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
                switch (status) {
                    case SFSpeechRecognizerAuthorizationStatusDenied:{
                        return PrivacyPermissionAuthorizationStatusDenied;
                    }break;
                    case SFSpeechRecognizerAuthorizationStatusNotDetermined:{
                        return PrivacyPermissionAuthorizationStatusNotDetermined;
                    }break;
                    case SFSpeechRecognizerAuthorizationStatusRestricted:{
                        return PrivacyPermissionAuthorizationStatusRestricted;
                    }break;
                    case SFSpeechRecognizerAuthorizationStatusAuthorized:{
                        return PrivacyPermissionAuthorizationStatusAuthorized;
                    }break;
                    default:
                        break;
                }
            }
        }break;
            
        case PrivacyPermissionTypeEvent: {
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
            switch (status) {
                case EKAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case EKAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                case EKAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case EKAuthorizationStatusAuthorized:{
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }break;
                default:
                    break;
            }
        }break;
            
        case PrivacyPermissionTypeContact: {
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            switch (status) {
                case CNAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case CNAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                case CNAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case CNAuthorizationStatusAuthorized:{
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }break;
                default:
                    break;
            }
        }break;
            
        case PrivacyPermissionTypeReminder: {
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
            switch (status) {
                case EKAuthorizationStatusNotDetermined:{
                    return PrivacyPermissionAuthorizationStatusNotDetermined;
                }break;
                case EKAuthorizationStatusRestricted:{
                    return PrivacyPermissionAuthorizationStatusRestricted;
                }break;
                case EKAuthorizationStatusDenied:{
                    return PrivacyPermissionAuthorizationStatusDenied;
                }break;
                case EKAuthorizationStatusAuthorized:{
                    return PrivacyPermissionAuthorizationStatusAuthorized;
                }break;
                default:
                    break;
            }
        }break;
        default:
            break;
    }
    return PrivacyPermissionAuthorizationStatusRestricted;
}

- (void)accessPrivacyPermission:(PrivacyPermissionType)type autoShowAlert:(BOOL)autoShowAlert completion:(void(^)(BOOL granted,PrivacyPermissionAuthorizationStatus status))completion{
    PrivacyPermissionAuthorizationStatus authorizationStatus = [self authorizationStatus:type];
    if(authorizationStatus != PrivacyPermissionAuthorizationStatusNotDetermined){//不需要授权情况
        (authorizationStatus == PrivacyPermissionAuthorizationStatusDenied) ? [self displayReEnableAlert:type] : nil;
        BOOL grantedState = (authorizationStatus == PrivacyPermissionAuthorizationStatusAuthorized
                             || authorizationStatus == PrivacyPermissionAuthorizationStatusLocationAlways
                             || authorizationStatus == PrivacyPermissionAuthorizationStatusLocationWhenInUse);
        (grantedState == NO) ? [self displayReEnableAlert:type] : nil;
        completion ? completion(grantedState,authorizationStatus) : nil;
        return;
    }
    switch (type) {
        case PrivacyPermissionTypePhoto: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusDenied) {
                        autoShowAlert ? [self displayReEnableAlert:type] : nil;
                        completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                    } else if (status == PHAuthorizationStatusNotDetermined) {
                        completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                    } else if (status == PHAuthorizationStatusRestricted) {
                        completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                    } else if (status == PHAuthorizationStatusAuthorized) {
                        completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                    }
                });
            }];
        }break;
        case PrivacyPermissionTypeCamera: {
            #if TARGET_IPHONE_SIMULATOR
            NSLog(@"模拟器不支持摄像头");
            return;
            #endif
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (granted) {
                        completion ?  completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                    } else {
                        if (status == AVAuthorizationStatusDenied) {
                            autoShowAlert ? [self displayReEnableAlert:type] : nil;
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                        } else if (status == AVAuthorizationStatusNotDetermined) {
                           completion ?  completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                        } else if (status == AVAuthorizationStatusRestricted) {
                           completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                        }
                    }
                });
            }];
        }break;
            
        case PrivacyPermissionTypeMedia: {
            if (@available(iOS 9.3, *)) {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == MPMediaLibraryAuthorizationStatusDenied) {
                            autoShowAlert ? [self displayReEnableAlert:type] : nil;
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                        } else if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                        } else if (status == MPMediaLibraryAuthorizationStatusRestricted) {
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                        } else if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                            completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                        }
                    });
                }];
            }
        }break;
            
        case PrivacyPermissionTypeMicrophone: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                    } else {
                        if (status == AVAuthorizationStatusDenied) {
                            autoShowAlert ? [self displayReEnableAlert:type] : nil;
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                        } else if (status == AVAuthorizationStatusNotDetermined) {
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                        } else if (status == AVAuthorizationStatusRestricted) {
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                        }
                    }
                });
            }];
        }break;
            
        case PrivacyPermissionTypeLocation: {
            if ([CLLocationManager locationServicesEnabled]) {
                CLLocationManager *locationManager = [[CLLocationManager alloc]init];
                [locationManager requestAlwaysAuthorization];
                [locationManager requestWhenInUseAuthorization];
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                locationManager.distanceFilter = PrivacyPermissionTypeLocationDistanceFilter;
                 locationManager.delegate = self;
                _locationManager = locationManager;
                [locationManager startUpdatingLocation];
            }
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == kCLAuthorizationStatusAuthorizedAlways) {
                    completion ? completion(YES,PrivacyPermissionAuthorizationStatusLocationAlways) : nil;
                } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                    completion ? completion(YES,PrivacyPermissionAuthorizationStatusLocationWhenInUse) : nil;
                } else if (status == kCLAuthorizationStatusDenied) {
                    autoShowAlert ? [self displayReEnableAlert:type] : nil;
                    completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                } else if (status == kCLAuthorizationStatusNotDetermined) {
                    completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                } else if (status == kCLAuthorizationStatusRestricted) {
                    completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                }
            });
        }break;
            
        case PrivacyPermissionTypeBluetooth: {
            if (@available(iOS 10.0, *)) {
                CBCentralManager *centralManager = [[CBCentralManager alloc] init];
                CBManagerState state = [centralManager state];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (state == CBManagerStateUnsupported || state == CBManagerStateUnauthorized || state == CBManagerStateUnknown) {
                        autoShowAlert ? [self displayReEnableAlert:type] : nil;
                        completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                    } else {
                        completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                    }
                });
            }
        }break;
            
        case PrivacyPermissionTypePushNotification: {
            if (@available(iOS 10.0, *)) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions types=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted) {
                            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                                //
                            }];
                        } else {
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) { }];
                        }
                    });
                }];
            } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            }
#pragma clang diagnostic pop
        }break;
        case PrivacyPermissionTypeSpeech: {
            if (@available(iOS 10.0, *)) {
                [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (status == SFSpeechRecognizerAuthorizationStatusDenied) {
                            autoShowAlert ? [self displayReEnableAlert:type] : nil;
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                        } else if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                        } else if (status == SFSpeechRecognizerAuthorizationStatusRestricted) {
                            completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                        } else if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                            completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                        }
                    });
                }];
            }
        }break;
            
        case PrivacyPermissionTypeEvent: {
                EKEventStore *store = [[EKEventStore alloc] init];
                [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                        if (granted) {
                            completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                        } else {
                            if (status == EKAuthorizationStatusDenied) {
                                autoShowAlert ? [self displayReEnableAlert:type] : nil;
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                            } else if (status == EKAuthorizationStatusNotDetermined) {
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                            } else if (status == EKAuthorizationStatusRestricted) {
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                            }
                        }
                    });
                }];
        }break;
            
        case PrivacyPermissionTypeContact: {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                        if (granted) {
                            completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                        } else {
                            if (status == CNAuthorizationStatusDenied) {
                                autoShowAlert ? [self displayReEnableAlert:type] : nil;
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                            }else if (status == CNAuthorizationStatusRestricted){
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusRestricted) : nil;
                            }else if (status == CNAuthorizationStatusNotDetermined){
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                            }
                        }
                    });
                }];
        }break;
            
        case PrivacyPermissionTypeReminder: {
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                        if (granted) {
                            completion ? completion(YES,PrivacyPermissionAuthorizationStatusAuthorized) : nil;
                        } else {
                            if (status == EKAuthorizationStatusDenied) {
                                autoShowAlert ? [self displayReEnableAlert:type] : nil;
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusDenied) : nil;
                            }else if (status == EKAuthorizationStatusNotDetermined){
                                completion ? completion(NO,PrivacyPermissionAuthorizationStatusNotDetermined) : nil;
                            }else if (status == EKAuthorizationStatusRestricted){
                                completion(NO,PrivacyPermissionAuthorizationStatusRestricted);
                            }
                        }
                    });
                }];
        }break;
        default:
            break;
    }
}

- (void)accessPrivacyPermission:(PrivacyPermissionType)type completion:(void(^)(BOOL granted,PrivacyPermissionAuthorizationStatus status))completion{
    [self accessPrivacyPermission:type autoShowAlert:YES completion:completion];
}

- (void)displayReEnableAlert:(PrivacyPermissionType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *permission = [self permissionName:type];
        NSString *title = [NSString stringWithFormat:@"您已禁止访问%@",permission];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *message = [NSString stringWithFormat:@"请在 '设置-隐私-%@'-\"%@\" 中进行设置",permission,appName];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:cancel];
        UIAlertAction *goSetting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];//打开系统设置
        }];
        [alertVc addAction:goSetting];
        UIViewController *vc = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [vc presentViewController:alertVc animated:YES completion:nil];
    });
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
}

@end
