#import "PluginManager.h" 
#import "PushNotificationPlugin.h" 
#import "TeaLeafAppDelegate+Push.h"
#import <objc/runtime.h> 

@implementation TeaLeafAppDelegate (Push)

// -(void) applicationDidFinishLaunching:(UIApplication *)application {    
// 	NSLog(@"Push Thing in DidFinishLaunching");
// }

+ (void)load {
    Method original = 	class_getInstanceMethod(self, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:));
    Method custom =		class_getInstanceMethod(self, @selector(customApplication:didRegisterForRemoteNotificationsWithDeviceToken:));
    method_exchangeImplementations(original, custom);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSString* token = [NSString stringWithFormat:@"%@", deviceToken];
	NSLog(@"{PushNotificationIOS} My token is: %@", deviceToken);
	[[PushNotificationPlugin get] setToken:token];
}

- (void)customApplication:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
//     NSLog(@"custom token");
    // this looks like recursion, but because the insides of the methods are swapped, we are actually calling the original implementation of the method
    [self customApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}
 
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"{PushNotificationIOS} Failed to get token, error: %@", error);
}
 
- (void)customApplication:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
//     NSLog(@"custom fail");
    // this looks like recursion, but because the insides of the methods are swapped, we are actually calling the original implementation of the method
    [self customApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
	[[PushNotificationPlugin get] sendNotificationToJS:userInfo];
}
@end