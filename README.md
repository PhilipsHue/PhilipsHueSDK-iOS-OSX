The Hue SDK by Philips
===============
 (c) Copyright Philips 2012-2013
Introduction
----------------
The Hue SDK is a set of tools that are designed to make it easy to access the Hue system through the Hue Wi-Fi network connected bridge and control an associated set of connected lamps. The aim of the SDK is to enable you to create your own applications for the Hue system.
The tools are provided with documentation for the SDK and example code. They are designed to be flexible, whilst easing the use of the more complex components of the system.

The Hue SDK Components
-------------------------------------
###The SDK API
The SDK library is the main API of the Hue SDK. It contains all of the main tools to access the Hue system
###The Wizards
The Wizards are user interface components that are provided as source and access the Hue SDK to operate. They are provided to cover functionality such as configuration that is best given as source. Providing the source and graphics resources grants you the option to change the look and feel to match your own application's design.

###The Documentation
Documentation is provided in documents such as this, other media, and code comments. 

###The Sample App
The Sample App is provided to show the usage of the Hue SDK. It uses the Wizards and the Hue SDK API. It is kept deliberately simple and focuses on how to use the Hue SDK.
Since 	 1.1.1beta the Sample App is obsolete and replaced by the QuickStartApp.

###The QuickStart App for iOS/OS X
The QuickStart App contains minimal functionality to connect to a bridge and for getting started. Ideal for devs to start programming their Hue Apps.

How to structure your app for the Hue SDK
---------------------------------------------------------
These are the key things you need to consider when building your app for the Hue SDK.
###The bridge controls the lights
The hardware bridge that you connect to your Wi-Fi network controls the connected lights. This means that all communication with the lights goes via the bridge
###The SDK connects to a bridge
To operate, the SDK must connect to a bridge
###Find a bridge
The SDK has functionality to find local bridges and a Wizard UI component for the user to select the bridge to use
###Push Linking
The button on the bridge itself must be pressed to connect to the SDK.  The SDK provides the code and Wizard UI component for this.
###Find the lights
The bridge should be instructed to find any unallocated lights in the locality. It will search using Zigbee to find them
###Identifiers for lights
The found lights are given unique identifiers by the bridge. These identifiers can be used to reference specific lights in SDK method calls
###The Bridge Send API sends commands to the lights 
This API allows the app to command the bridge to set light states (colours etc), group commands to lights, set schedules for light events etc.
###The heartbeat gets the state of the bridge and light settings
The Heartbeat runs at regular intervals in the SDK and each interval the latest state of the lights, configuration etc, is collected from the bridge and stored in the Bridge Resources cache.
###Use the Bridge Resources Cache to read the state of the lights etc.
The Bridge keeps itself in sync with the lights and the Bridge Resources Cache is a copy of the last read setting.
The app should read the Bridge Resources Cache objects to get the latest settings for lights, schedules etc.
###Notifications
Notifications are used by the SDK. The App can receive notifications as events occur
The 1-2-3 Quick Start for your SDK app
-----------------------------------------------------
1. Connect the SDK to the Bridge and Find Lights
2. Send commands via the Bridge Send API
3. Read the Bridge Resources Cache to see current light settings.

###Linker flags
Please make sure you have added -ObjC to your linker flags


Hue SDK Components
------------------------------
###The Heartbeat
The Heartbeat is a regular timed event that occurs on the SDK once it is running and initialized. The Heartbeat is used to collect the latest status of the bridge and Hue Lamps. The Heartbeat serves the purpose of allowing for other bridge clients, both local and remote, to make changes to settings of lamps via the bridge. During the Heartbeat, the SDK caches the current status returned from the bridge
###Notifications
Notifications are used by the SDK. The notification architecture allows the SDK to post events as they occur. Clients can register to receive notifications in order to process them. An example would be that the cache has updated information (changes) on the lamp settings. -Registering for this notification will allow a UI component to update its display settings for the lamps.
###Bridge Send API
The Bridge Send API provides methods to set and get the status of Bridge resources(lights, schedules etc). Calls through the Bridge Send API typically result in changes in state of the lamps connected to the bridge. These state changes are then shown in the Bridge Resources Cache when it updates.
###Bridge Resources Cache
The SDK provides visibility of the bridge and the resources it is controlling through the PHBridgeResourcesCache object.
This object contains the following objects that show the current bridge state:
####PHBridgeConfiguration
This object contains information on the configuration and settings of the bridge itself
####PHLights
This collection of PHLight objects contains details of each light connected to the bridge
####PHGroups
Each group in this collection of groups contains a set of PHLight objects
####PHSchedules
The collection of PHSchedules held in the bridge. Each schedule contains a date/time and the bridge action to be carried out at that time.
###Other SDK classes
####PHLightState
Represents a light state setting for the lights properties.

##Bridge Discovery and Connection
When initializing the SDK can optionally find a bridge on the local network and connect to it. If no local bridge is found, the SDK, will timeout and return a notification.

##The Wizards
The Wizards are supplied as source code components that use the SDK. You may adapt and modify them, but they will make it easier to:

1. Discover the bridge
2. Connect to the bridge
3. Push link to the bridge 
4. Bridge Configuration
5. Find lights


##Walking through the Sample App code

###PHAppDelegate:
```objc
    @implementation PHAppDelegate
```
**Startup:**
**The HueSDK instance is created and startUpSDK called to initialize it.**

**We also start the regular heartbeat events.**

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    /***************************************************
     The Hue SDK is created as a property in the App delegate .h file
     (@property (nonatomic, strong) PHHueSDK *phHueSDK;)
     (@property (nonatomic, strong) PHBridgeSearching *bridgeSearching;)
     
     and the SDK instance can then be created:
     // Create sdk instance
     self.phHueSDK = [[PHHueSDK alloc] init];
     
     next, the startUpSDK call will initialize the SDK and kick off its regular heartbeat timer:
     [self.phHueSDK startUpSDK];
     *****************************************************/
    
    // Create sdk instance
    self.phHueSDK = [[PHHueSDK alloc] init];
    [self.phHueSDK startUpSDK];
    
    // Create a viewcontroller in a navigation controller and make the navigation controller the rootviewcontroller of the app
    PHViewController *viewController = [[PHViewController alloc] initWithNibName:@"PHViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // Listen for notifications
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    /***************************************************
     The SDK will send the following notifications in response to events
     *****************************************************/

    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
    /***************************************************
     If there is no authentication against the bridge this notification is sent
     *****************************************************/

    [notificationManager registerObject:self withSelector:@selector(notAuthenticated) forNotification:NO_LOCAL_AUTHENTICATION_NOTIFICATION];
    /***************************************************
    The local heartbeat is a regular  timer event in the SDK. Once enabled the SDK regular collects the current state of resources managed
     by the bridge into the Bridge Resources Cache
     *****************************************************/

    self.bridgeSearching = [[PHBridgeSearching alloc] initWithUpnpSearch:YES andPortalSearch:YES andIpAdressSearch:NO];
    
    [self enableLocalHeartbeat];
    
    return YES;
}
```

**If we are not authenticated against the bridge a notification is sent be the SDK. We**
**process it here and start Push linking to authenticate**

```objc
- (void)notAuthenticated {
    /***************************************************
     We are not authenticated so we start the authentication process
     *****************************************************/

    // Move to main screen (as you can't control lights when not connected)
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    // Dismiss modal views when connection is lost
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
    
    // Remove no connection alert
    if (self.noConnectionAlert != nil) {
        [self.noConnectionAlert dismissWithClickedButtonIndex:[self.noConnectionAlert cancelButtonIndex] animated:YES];
        self.noConnectionAlert = nil;
    }
    
    // Start local authenticion process
    /***************************************************
     doAuthentication will start the push linking
     *****************************************************/

    [self performSelector:@selector(doAuthentication) withObject:nil afterDelay:0.5];
}
```

**The heartbeat in the SDK will reguarly update the Bridge Resources Cache** 

```objc
/**
 Starts the local heartbeat with a 10 second interval
 */
- (void)enableLocalHeartbeat {
    /***************************************************
     The heartbeat processing collects data from the bridge
     so now try to see if we have a bridge already connected
     *****************************************************/

    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    if (cache != nil && cache.bridgeConfiguration != nil && cache.bridgeConfiguration.ipaddress != nil) {
        // Some bridge is known
        [self.phHueSDK enableLocalConnectionUsingInterval:10];
    }
    else {
        /***************************************************
         No bridge connected so start the bridge search process
         *****************************************************/
        
        // No bridge known
        [self searchForBridgeLocal];
    }
}
``` 

**We use UPnP/NUPnP/IP scan to find local bridges**

**The PHBridgeSearching class instance should be retained, because searching for bridges will be handled in the background.**
 
```objc  
/**
 Search for bridges using UPnP and portal discovery, shows results to user or gives error when none found.
 */
- (void)searchForBridgeLocal {
    // Stop heartbeats
    [self disableLocalHeartbeat];
    
    // Show search screen
    [self showLoadingViewWithText:NSLocalizedString(@"Searching...", @"Searching for bridges text")];
    /***************************************************
     A bridge search is started using UPnP to find local bridges
     *****************************************************/
    
    // Start search
    [self.bridgeSearching startSearchWithCompletionHandler:^(NSDictionary *bridgesFound) {
        // Done with search, remove loading view
        [self removeLoadingView];
        /***************************************************
        The search is complete, check whether we found a bridge
         *****************************************************/
       
        // Check for results
        if (bridgesFound.count > 0) {
            // Results were found, show options to user (from a user point of view, you should select automatically when there is only one bridge found)
            self.bridgeSelectionViewController = [[PHBridgeSelectionViewController alloc] initWithNibName:@"PHBridgeSelectionViewController" bundle:[NSBundle mainBundle] bridges:bridgesFound delegate:self];
            /***************************************************
             Use the list of bridges, present them to the user, so one can be selected.
             *****************************************************/

            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.bridgeSelectionViewController];
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
            [self.navigationController presentViewController:navController animated:YES completion:nil];
        }
        else {
            /***************************************************
             No bridge was found was found. Tell the user and offer to retry..
             *****************************************************/

            
            // No bridges were found, show this to the user
            self.noBridgeFoundAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No bridges", @"No bridge found alert title")
                                                                 message:NSLocalizedString(@"Could not find bridge", @"No bridge found alert message")
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:NSLocalizedString(@"Retry", @"No bridge found alert retry button"), nil];
            self.noBridgeFoundAlert.tag = 1;
            [self.noBridgeFoundAlert show];
        }
    }];
}
```

**We store the details of the found and selected bridge** 

```objc
/**
 Delegate method for PHbridgeSelectionViewController which is invoked when a bridge is selected
 */
- (void)bridgeSelectedWithIpAddress:(NSString *)ipAddress andMacAddress:(NSString *)macAddress {
    /***************************************************
    Removing the selection view controller takes us to 
     the 'normal' UI view
     *****************************************************/

    // Remove the selection view controller
    self.bridgeSelectionViewController = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    // Show a connecting view while we try to connect to the bridge
    [self showLoadingViewWithText:NSLocalizedString(@"Connecting...", @"Connecting text")];
    
    // Set SDK to use bridge and our default username (which should be the same across all apps, so pushlinking is only required once)
    NSString *username = [PHUtilities whitelistIdentifier];
    /***************************************************
     Set the username, ipaddress and mac address,
     as the bridge properties that the SDK framework will use
     *****************************************************/
    [UIAppDelegate.phHueSDK setBridgeToUseWithIpAddress:ipAddress macAddress:macAddress andUsername:username];
    
    /***************************************************
     Setting the hearbeat running will cause the SDK
     to regularly update the cache with the status of the 
     bridge resources
     *****************************************************/

    // Start local heartbeat again
    [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
}
```

**We start Push Linking**

```objc
/**
 Start the local authentication process
 */
- (void)doAuthentication {
    // Disable heartbeats
    [self disableLocalHeartbeat];
    /***************************************************
     To be certain that we own this bridge we must manually 
     push link it. Here we display the view to do this.
     *****************************************************/
    
    // Create an interface for the pushlinking
    self.pushLinkViewController = [[PHBridgePushLinkViewController alloc] initWithNibName:@"PHBridgePushLinkViewController" bundle:[NSBundle mainBundle] hueSDK:UIAppDelegate.phHueSDK delegate:self];
    
    [self.navigationController presentViewController:self.pushLinkViewController animated:YES completion:^{
        /***************************************************
        Start the push linking process.
         *****************************************************/
       // Start pushlinking when the interface is shown
        [self.pushLinkViewController startPushLinking];
    }];
}

/**
 Delegate method for PHBridgePushLinkViewController which is invoked if the pushlinking was successful
 */
- (void)pushlinkSuccess {
    // Remove pushlink view controller
    /***************************************************
     Push linking succeeded we are authenticated against 
     the chosen bridge.
     *****************************************************/
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.pushLinkViewController = nil;
    
    // Start local heartbeat
    [self performSelector:@selector(enableLocalHeartbeat) withObject:nil afterDelay:1];
}
```

**PHBridgePushLinkViewController:
Used for the push linking**

```objc
@implementation PHBridgePushLinkViewController

/**
 Starts the pushlinking process
 */
- (void)startPushLinking {
    /***************************************************
     Set up the notifications for push linkng
     *****************************************************/

    // Register for notifications about pushlinking
    PHNotificationManager *phNotificationMgr = [PHNotificationManager defaultManager];
    
    [phNotificationMgr registerObject:self withSelector:@selector(authenticationSuccess) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION];
    [phNotificationMgr registerObject:self withSelector:@selector(authenticationFailed) forNotification:PUSHLINK_LOCAL_AUTHENTICATION_FAILED_NOTIFICATION];
    [phNotificationMgr registerObject:self withSelector:@selector(noLocalConnection) forNotification:PUSHLINK_NO_LOCAL_CONNECTION_NOTIFICATION];
    [phNotificationMgr registerObject:self withSelector:@selector(noLocalBridge) forNotification:PUSHLINK_NO_LOCAL_BRIDGE_KNOWN_NOTIFICATION];
    [phNotificationMgr registerObject:self withSelector:@selector(buttonNotPressed:) forNotification:PUSHLINK_BUTTON_NOT_PRESSED_NOTIFICATION];
    
    // Call to the hue SDK to start pushlinking process
    /***************************************************
     Call the SDK to start Push linking.
     The notifications sent by the SDK will confirm success 
     or failure of push linking
     *****************************************************/

    [self.phHueSDK startPushlinkAuthentication];
}

/**
 Notification receiver which is called when the pushlinking was successful
 */
- (void)authenticationSuccess {
    /***************************************************
     The notification PUSHLINK_LOCAL_AUTHENTICATION_SUCCESS_NOTIFICATION
     was received. We have confirmed the bridge.
     De-register for notifications and call
     pushLinkSuccess on the delegate
     *****************************************************/
    // Deregister for all notifications
    [[PHNotificationManager defaultManager] deregisterObjectForAllNotifications:self];
    
    // Inform delegate
    [self.delegate pushlinkSuccess];
}
```

**PHBridgeSelectionViewController:
used to choose a bridge** 

```objc
@implementation PHBridgeSelectionViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Sort bridges by mac address
    NSArray *sortedKeys = [self.bridgesFound.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    /***************************************************
     The choice of bridge to use is made, store the mac 
     and ip address for this bridge
     *****************************************************/
    
    // Get mac address and ip address of selected bridge
    NSString *mac = [sortedKeys objectAtIndex:indexPath.row];
    NSString *ip = [self.bridgesFound objectForKey:mac];
    
    // Inform delegate
    [self.delegate bridgeSelectedWithIpAddress:ip andMacAddress:mac];
}
```

**PHViewController:
The base view for the Sample App:**

```objc
@implementation PHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"Sample app";
    /***************************************************
     The localConnection notification will notify that 
     the bridge heartbeat occurred and the bridge resources
     cache data has been updated
     *****************************************************/
    
    // Listen for notifications
    PHNotificationManager *notificationManager = [PHNotificationManager defaultManager];
    [notificationManager registerObject:self withSelector:@selector(localConnection) forNotification:LOCAL_CONNECTION_NOTIFICATION];
    [notificationManager registerObject:self withSelector:@selector(noLocalConnection) forNotification:NO_LOCAL_CONNECTION_NOTIFICATION];
}
    
/**
 Action for the show lights button
 */
- (IBAction)showLights:(id)sender {
    /***************************************************
     Show the lights view controller for the lights 
     status
     *****************************************************/

    PHLightsViewController *lightsViewController = [[PHLightsViewController alloc] initWithStyle:UITableViewCellStyleSubtitle];
    [self.navigationController pushViewController:lightsViewController animated:YES];
    }

    /**
     Notification receiver for successful local connection
     */
    - (void)localConnection {
    /***************************************************
     PHBridgeResourcesReader readBridgeResourcesCache, 
     returns the up to date PHBridgeResourcesCache status
     Here it is used to display the bridge ipaddress
     *****************************************************/

    // Read latest cache, update ip of bridge in interface
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    self.currentBridgeLabel.text = cache.bridgeConfiguration.ipaddress;
    
    // Set current time as last successful local heartbeat time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    /***************************************************
     Displays the current time to show when the last
     heartbeat was executed.
     *****************************************************/
    
    self.lastLocalHeartbeatLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}
```

**PHLightsViewController:
Used to show the current lights in the bridge** 

```objc
@implementation PHLightsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self updateLights];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set title of this view
    self.title = @"Lights";
    /***************************************************
     Each bridge resource has a notification when it has been 
     updated. Here we register for the lights cache updated 
     notification
     *****************************************************/

    
    // Add notification listener for cache update of lights
    [[PHNotificationManager defaultManager] registerObject:self withSelector:@selector(updateLights) forNotification:LIGHTS_CACHE_UPDATED_NOTIFICATION];
}

/**
 Gets the list of lights from the cache and updates the tableview
 */
- (void)updateLights {
    /***************************************************
     The notification of changes to the lights information
     in the Bridge resources cache called this method.
     Now we access Bridge resources cache to get updated
     information and reload the displayed lights table.
     *****************************************************/

    // Gets lights from cache
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    self.lights = cache.lights;
    
    // Update tableview based on new lights
    [self.tableView reloadData];
    }
    #pragma mark - Table view delegate

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Sort the light identifiers, so you get the correct light identifier
    NSArray *sortedKeys = [self.lights.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    /***************************************************
     The user has selected a light, prepare the PHLightViewController
     for that light and push it onto display
     *****************************************************/
    
    // Get light
    PHLight *light = [self.lights objectForKey:[sortedKeys objectAtIndex:indexPath.row]];
    
    // Create new view controller for displaying light
    PHLightViewController *lightViewController = [[PHLightViewController alloc] initWithNibName:@"PHLightViewController" bundle:nil light:light];
    [self.navigationController pushViewController:lightViewController animated:YES];
}
```

**PHLightViewController: 
Showing and setting an individual light state**

```objc
@implementation PHLightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil light:(PHLight *)light {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.light = light;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.light.name;
    
    self.redButton.backgroundColor = [UIColor redColor];
    self.blueButton.backgroundColor = [UIColor blueColor];
    self.greenButton.backgroundColor = [UIColor greenColor];
    self.yellowButton.backgroundColor = [UIColor yellowColor];
    self.violetButton.backgroundColor = [UIColor purpleColor];
    self.orangeButton.backgroundColor = [UIColor orangeColor];
    }

    - (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    }

    - (void)viewDidUnload {
    [self setSendOn:nil];
    [self setSendHue:nil];
    [self setSendSat:nil];
    [self setSendBri:nil];
    [self setSendXY:nil];
    [self setSendEffect:nil];
    [self setSendAlert:nil];
    [self setValueOn:nil];
    [self setValueHue:nil];
    [self setValueSat:nil];
    [self setValueBri:nil];
    [self setValueX:nil];
    [self setValueY:nil];
    [self setValueEffect:nil];
    [self setValueAlert:nil];
    [self setSendTransitionTime:nil];
    [self setValueTransitionTime:nil];
    [super viewDidUnload];
}

/**
 Action for the send state local button
 */
- (IBAction)sendState:(id)sender {
    // Create a lightstate based on selected options
    PHLightState *lightState = [self createLightState];
    
    /***************************************************
     The BridgeSendAPI is used to send commands to the bridge.
     Here we are updating the settings chosen by the user
     for the selected light.
     These settings are sent as a PHLightState to update
     the light with the given light identifiers.
     Subsequent checking of the Bridge Resources cache after the next heartbeat will
     show that changed settings have occurred.
     *****************************************************/
    
    // Create a bridge send api, used for sending commands to bridge locally
    id<PHBridgeSendAPI> bridgeSendAPI = [[[PHOverallFactory alloc] init] bridgeSendAPI];
    
    // Send lightstate to light
    [bridgeSendAPI updateLightStateForId:self.light.identifier withLighState:lightState completionHandler:^(PHError *error) {
        // Check for errors
        if (error != nil) {
            // Error occured
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:error.description
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"Ok", nil];
            [errorAlert show];
        }
    }];    
}

- (IBAction)redButton:(id)sender {
    [self setupForColor:[UIColor redColor]];
}

- (IBAction)blueButton:(id)sender {
    [self setupForColor:[UIColor blueColor]];
}

- (IBAction)greenButton:(id)sender {
    [self setupForColor:[UIColor greenColor]];
}

- (IBAction)yellowButton:(id)sender {
    [self setupForColor:[UIColor yellowColor]];
}

- (IBAction)violetButton:(id)sender {
    [self setupForColor:[UIColor purpleColor]];
}

- (IBAction)orangeButton:(id)sender {
    [self setupForColor:[UIColor orangeColor]];
}

- (void)setupForColor:(UIColor *)color {
    CGPoint xyPoint;
    float brightness;
    [PHUtilities calculateXY:&xyPoint andBrightness:&brightness fromColor:color forModel:self.light.modelNumber];
    
    self.sendHue.on = NO;
    self.sendSat.on = NO;
    self.sendEffect.on = NO;
    self.sendAlert.on = NO;
    self.sendTransitionTime.on = NO;
    
    self.sendOn.on = YES;
    self.valueOn.on = YES;
    self.sendBri.on = YES;
    self.valueBri.value = 255.0f;
    self.sendXY.on = YES;
    self.valueX.value = xyPoint.x;
    self.valueY.value = xyPoint.y;
}

/**
 Creates a lightstate based on selected options in the user interface
 @return the lightstate
 */
- (PHLightState *)createLightState {
    /***************************************************
     The PHLightState class is used as a parameter for the
     Hue SDK. It contains the attribute settings for an individual\
     light. This method creates it from the current
     user interface settings for the light
     *****************************************************/
        
    // Create an empty lightstate
    PHLightState *lightState = [[PHLightState alloc] init];
    
    // Check if on value should be send
    if (self.sendOn.on) {
        [lightState setOnBool:self.valueOn.on];
    }
    
    // Check if hue value should be send
    if (self.sendHue.on) {
        [lightState setHue:[NSNumber numberWithInt:((int)self.valueHue.value)]];
    }
    
    // Check if saturation value should be send
    if (self.sendSat.on) {
        [lightState setSaturation:[NSNumber numberWithInt:((int)self.valueSat.value)]];
    }
    
    // Check if brightness value should be send
    if (self.sendBri.on) {
        [lightState setBrightness:[NSNumber numberWithInt:((int)self.valueBri.value)]];
    }
    
    // Check if xy values should be send
    if (self.sendXY.on) {
        [lightState setX:[NSNumber numberWithFloat:self.valueX.value]];
        [lightState setY:[NSNumber numberWithFloat:self.valueY.value]];
    }
    
    // Check if effect value should be send
    if (self.sendEffect.on) {
        if (self.valueEffect.selectedSegmentIndex == 0) {
            [lightState setEffectMode:EFFECT_NONE];
        }
        else if (self.valueEffect.selectedSegmentIndex == 1) {
            [lightState setEffectMode:EFFECT_COLORLOOP];
        }
    }
    
    // Check if alert value should be send
    if (self.sendAlert.on) {
        if (self.valueAlert.selectedSegmentIndex == 0) {
            [lightState setAlertMode:ALERT_NONE];
        }
        else if (self.valueAlert.selectedSegmentIndex == 1) {
            [lightState setAlertMode:ALERT_SELECT];
        }
        else if (self.valueAlert.selectedSegmentIndex == 2) {
            [lightState setAlertMode:ALERT_LSELECT];
        }
    }
    
    // Check if transition time should be send
    if (self.sendTransitionTime.on) {
        [lightState setTransitionTime:[NSNumber numberWithInt:((int)self.valueTransitionTime.value)]];
    }
    
    return lightState;
}

@end
```

Philips releases this SDK with friendly house rules. These friendly house rules are part of a legal framework; this to protect both the developers and hue. The friendly house rules cover e.g. the naming of Philips and of hue which can only be used as a reference (a true and honest statement) and not as a an brand or identity. Also covered is that the hue SDK and API can only be used for hue and for no other application or product. Very common sense friendly rules that are common practice amongst leading brands that have released their SDK’s.


Copyright (c) 2012- 2013, Philips Electronics N.V. All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 
* Neither the name of Philips Electronics N.V. , nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOTLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FORA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER ORCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, ORPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OFLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDINGNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THISSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


