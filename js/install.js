function pluginSend(evt, params) {
	NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent &&
		NATIVE.plugins.sendEvent("FacebookPlugin", evt,
				JSON.stringify(params || {}));
}

var PushNotificationPlugin = Class(function () {
    NATIVE.events.registerHandler('pushNotificationPlugin', function(e) {
		console.log("{PushNotificationJS} received return event");
		if (e.method == "setToken") {
			console.log("{PushNotificationJS} GC received token: "+e.token);
			GLOBAL.pushToken = e.token;
		}
		if (e.method == "handleDict") {
			//Edit here to utilize PN dictionary data
			GLOBAL.pushDict = e;
			console.log("{PushNotificationJS} GC received notification - "+JSON.stringify(e));
			pluginSend("clearPNDict");
		}
	});

	var req = {method:"getToken"}
	NATIVE.plugins.sendEvent("PushNotificationPlugin", "onRequest", JSON.stringify(req));

	//plugins.pushNotificationPlugin.clearBadge
	this.clearBadge = function() {	
		console.log("{PushNotificationJS} Requesting Badge Clear");
		pluginSend("clearBadge");
	}
	this.getPNDict = function() {
		console.log("{PushNotificationJS} getting PN Dict");
		pluginSend("getPNDict");
	}
	this.getPNDict();
});

exports = new PushNotificationPlugin();