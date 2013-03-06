//
//  AppDelegate.m
//  AdColonyV4VC
//
//  Created by John Fernandes-Salling on 8/15/12.
//

#import "AppDelegate.h"
#import "Constants.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
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
            @"vzf8e4e97704c4445c87504e", [NSNumber numberWithInt:1], // AdColony zone ID, slot number
            nil];
}



// Callback activated when currency was awarded
// This implementation is designed for client-side virtual currency without a server
// It uses NSUserDefaults for persistent client-side storage of the currency balance
// For applications with a server, contact the server to retrieve an updated currency balance
-(void)adColonyVirtualCurrencyAwardedByZone:(NSString *)zone currencyName:(NSString *)name currencyAmount:(int)amount {
    NSLog(@"Zone %@ awarded %i %@", zone, amount, name);
    
    NSUserDefaults* storage = [NSUserDefaults standardUserDefaults];
    
    // Get currency balance from persistent storage and update it
    NSNumber* wrappedBalance = [storage objectForKey:kCurrencyBalance];
    NSUInteger balance = wrappedBalance && [wrappedBalance isKindOfClass:[NSNumber class]] ? [wrappedBalance unsignedIntValue] : 0;
    balance += amount;
    
    // Persist the currency balance
    [storage setValue:[NSNumber numberWithUnsignedInt:balance] forKey:kCurrencyBalance];
    [storage synchronize];
    
    // Post a notification so the rest of the app knows the balance changed
    [[NSNotificationCenter defaultCenter] postNotificationName:kCurrencyBalanceChange object:nil];
}

// Callback activated when a currency award failed; we do not recommend displaying the reason to users
// This implementation notifies other parts of the app via NSNotification so that they can disable V4VC UI elements
-(void)adColonyVirtualCurrencyNotAwardedByZone:(NSString *)zone currencyName:(NSString *)name currencyAmount:(int)amount reason:(NSString *)reason {
    NSLog(@"Zone %@ failed to award %i %@ with reason %@", zone, amount, name, reason);
    [[NSNotificationCenter defaultCenter] postNotificationName:kZoneOff object:nil];
}



-(void)adColonyNoVideoFillInZone:(NSString *)zone
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kZoneOff object:nil];
}

-(void)adColonyVideoAdsReadyInZone:(NSString *)zone
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kZoneReady object:nil];
}

-(void)adColonyVideoAdsNotReadyInZone:(NSString *)zone
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kZoneLoading object:nil];
}



// Provide a logging level for AdColony
// This implementation enables helpful console log messages
-(NSString *)adColonyLoggingStatus
{
    return AdColonyLoggingOn;
}

@end
