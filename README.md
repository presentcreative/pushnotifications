# Game Closure Devkit Plugin: pushNotificationPlugin

## Usage

Include it in the `manifest.json` file under the "addons" section for your game:

~~~
"addons": [
	"pushNotificationPlugin"
],
~~~

At the top of your game's `src/Application.js`:

~~~
import plugins.pushNotificationPlugin.install;
~~~

This registers your app for Apple Push Notification service, and automatically prompts users for permission at launch.

You still need to set up a valid provisioning profile for the app and certificates to send notifications with.

Push notifications can be tested with simplepush.php, for more info visit www.raywenderlich.com/32960/apple-push-notification-services-in-ios-6-tutorial-part-1

~~~

## Platform-specific notes

iOS support only.