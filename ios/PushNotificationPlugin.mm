#import "PushNotificationPlugin.h"
#import "TeaLeafAppDelegate.h"

static PushNotificationPlugin* instance = nil;

@implementation PushNotificationPlugin

@synthesize token;

+ (PushNotificationPlugin*) get {
	if (!instance) {
		instance = [[PushNotificationPlugin alloc] init];
	}
    
	return instance;
}

// The plugin must call super dealloc.
- (void) dealloc {
	[super dealloc];
}

// The plugin must call super init.
- (id) init {
	self = [super init];
	if (!self) {
		return nil;
	}
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
		(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
	NSLOG(@"{pushNotificationPlugin} Initialized with manifest");
	if(self.token.length > 0)
		[self sendTokenToJS];
}

- (void) sendTokenToJS {
    NSLog(@"made it this far");
	[[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
										  @"pushNotificationPlugin",@"name",
                                          @"setToken", @"method",
										  self. token,@"token",
										  nil]];
}

- (void) sendNotificationToJS:(NSDictionary *)userInfo {
	NSLog(@"userInfo:%@",[userInfo description]);
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[userInfo objectForKey:@"aps"]];
    [dict setObject:@"pushNotificationPlugin" forKey:@"name"];
    [dict setObject:@"handleURL" forKey:@"method"];
    NSLog(@"sendDict: %@", [dict description]);
	[[PluginManager get] dispatchJSEvent:dict];
}

- (void) onRequest:(NSDictionary *)jsonObject {
	@try {
		NSLOG(@"{pushNotificationPlugin} Got request");
        
		NSString *method = [jsonObject valueForKey:@"method"];
        
		if ([method isEqualToString:@"clearBadge"]) {
			NSLOG(@"{pushNotificationPlugin} Clearing Badge");
			[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
		}
		if ([method isEqualToString:@"otherFunc"]) {
            // 			[[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
            // 			@"geoloc",@"name", kCFBooleanTrue, @"failed", nil]];
		}
	}
	@catch (NSException *exception) {
		NSLOG(@"{pushNotificationPlugin} Exception while processing event: ", exception);
	}
}
@end

