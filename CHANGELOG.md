#  iOS/OS X SDK Changelog



## 1.1.1beta (2013-12-05)

Features:

  - The SDK is now OS X COMPATIBLE!   The 2 frameworks (HueSDK_iOS.framework and HueSDK_OSX.framework) can now be used in any OSX project as well as in iOS projects.
  - QuickStart App released for iOS and OS X, containing minimal functionality to connect to a bridge and for getting started. Ideal for devs to start programming their Hue Apps.
    
Changes:

  - Removed JSONKit
  - Whitelist username is now a 16 character random string, and will be handled by the SDK
  - The SDK for iOS requires iOS 5.0+
  - The SDK for OS X requires OS X 10.7+ (Lion)
  - Added IPScan functionality which can be used as a fallback if the UPnP/NUPnP search fails to find any bridges
  - A PHBridgeSearching instance should be retained, since searching for bridges happens in the background now
  - Xcode 5 compatibility 

Remarks:

  - The sample app is obsolete
  - Please make sure the -ObjC linker flag has been configured in the app