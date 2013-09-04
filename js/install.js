var PushNotificationPlugin = Class(function () {
    NATIVE.events.registerHandler('pushNotificationPlugin', function(e) {
		console.log("{PushNotificationJS} received return event");
		if (e.method == "setToken") {
			console.log("{PushNotificationJS} GC received token: "+e.token);
			GLOBAL.pushToken = e.token;
		}
		if (e.method == "handleURL") {
			//Edit here to utilize PN dictionary data
			console.log("{PushNotificationJS} GC received notification - "+JSON.stringify(e));
		}
	});

	var req = {method:"getToken"}
	NATIVE.plugins.sendEvent("PushNotificationPlugin", "onRequest", JSON.stringify(req));

	//plugins.pushNotificationPlugin.clearBadge
	this.clearBadge = function() {	
		console.log("{PushNotificationJS} Requesting Badge Clear");
		var e = {method:"clearBadge"}
		NATIVE.plugins.sendEvent("PushNotificationPlugin", "onRequest", JSON.stringify(e));
	}
});

exports = new PushNotificationPlugin();