#import "PluginManager.h"

@interface PushNotificationPlugin : GCPlugin {
	NSString* token;
}

@property (nonatomic, retain) NSString* token;

+ (PushNotificationPlugin*) get;
- (void) sendTokenToJS;
- (void) sendNotificationToJS:(NSDictionary *)userInfo;
- (void) onRequest:(NSDictionary *)jsonObject;

@end