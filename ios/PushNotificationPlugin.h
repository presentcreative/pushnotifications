#import "PluginManager.h"

@interface PushNotificationPlugin : GCPlugin {
	NSString* token;
}

@property (nonatomic, retain) NSString* token;

+ (PushNotificationPlugin*) get;
- (void) sendTokenToJS;
- (void) sendNotificationToJS:(NSDictionary *)userInfo;
- (void) onRequest:(NSDictionary *)jsonObject;
- (void) didFailToRegisterForRemoteNotificationsWithError:(NSError *)error application:(UIApplication *)app;
- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo application:(UIApplication *)app;
- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken application:(UIApplication *)app;
- (void) didReceiveLocalNotification:(UILocalNotification *)notification application:(UIApplication *)app;

@end

@interface NotificationChecker : NSObject {

}

@end