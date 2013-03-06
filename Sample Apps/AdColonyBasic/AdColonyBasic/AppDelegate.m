//
//  AppDelegate.m
//  AdColonyBasic
//
//  Created by John Fernandes-Salling on 8/14/12.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // Initialize AdColony only once, on initial launch
    [AdColony initAdColonyWithDelegate:self];
    
    return YES;
}

#pragma mark -
#pragma mark AdColony-specific

// Provide the AdColony app ID for your application
// This can be retrieved from your account on adcolony.com
-(NSString *)adColonyApplicationID
{
    return @"appbdee68ae27024084bb334a"; // AdColony app ID
}

// Provide a dictionary of AdColony zone IDs for all zones in use throughout the app.
// These can be retrieved from your account on adcolony.com
// Slot numbers are arbitrary integers
-(NSDictionary *)adColonyAdZoneNumberAssociation
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"vzf8fb4670a60e4a139d01b5", [NSNumber numberWithInt:1], // AdColony interstitial zone ID, slot number
            nil];
}

// Enable helpful console log messages
-(NSString *)adColonyLoggingStatus
{
    return AdColonyLoggingOn;
}

@end
