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

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNotificationChecker:)
                                                 name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
}

+ (void)createNotificationChecker:(NSNotification *)notification
{
    NSDictionary *launchOptions = [notification userInfo] ;
    
    // This code will be called immediately after application:didFinishLaunchingWithOptions:.
	NSDictionary *remoteNotificationDict = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationDict) {
        NSLog(@"remote PN received at launch");
        [[PushNotificationPlugin get] handleRemoteNotification:remoteNotificationDict];
    }else{
        NSLog(@"no remote PN found, continue");
    }
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
}

- (void) sendTokenToJS {
    if ([self.token length]>0) {
        [[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
                                              @"pushNotificationPlugin",@"name",
                                              @"setToken", @"method",
                                              self. token,@"token",
                                              nil]];
    }
}

- (void) sendNotificationToJS:(NSDictionary *)userInfo {
	NSLog(@"userInfo:%@",[userInfo description]);
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[userInfo objectForKey:@"aps"]];
    [dict setObject:@"pushNotificationPlugin" forKey:@"name"];
    [dict setObject:@"handleURL" forKey:@"method"];
	[[PluginManager get] dispatchJSEvent:dict];
}


- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken application:(UIApplication *)app {
	NSString* aToken = [NSString stringWithFormat:@"%@", deviceToken];
	NSLog(@"{PushNotificationIOS} My token is: %@", deviceToken);
	[self setToken:aToken];
    [self sendTokenToJS];
//    [self performSelector:@selector(sendTokenToJS) withObject:nil afterDelay:1.0];
}

- (void) onRequest:(NSDictionary *)jsonObject {
	@try {
		NSLOG(@"{pushNotificationPlugin} Got request");
        
		NSString *method = [jsonObject valueForKey:@"method"];
        
		if ([method isEqualToString:@"clearBadge"]) {
			NSLOG(@"{pushNotificationPlugin} Clearing Badge");
			[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
		}
		if ([method isEqualToString:@"getToken"]) {
			[self sendTokenToJS];
		}
	}
	@catch (NSException *exception) {
		NSLOG(@"{pushNotificationPlugin} Exception while processing event: ", exception);
	}
}

- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo application:(UIApplication *)app {
    NSLog(@"{pushNotificationPlugin} didReceiveRemoteNotification");
    [self handleRemoteNotification:userInfo];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"{pushNotificationPlugin} handling notification");
	[[PushNotificationPlugin get] sendNotificationToJS:userInfo];
}

@end