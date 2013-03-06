//
//  ViewController.m
//  AdColonyAdvanced
//
//  Created by John Fernandes-Salling on 9/12/12.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"

@interface ViewController ()
{
    AVAudioPlayer* audio;
}
@property IBOutlet UILabel* currencyLabel;
@property IBOutlet UIActivityIndicatorView* spinner;
@property IBOutlet UIButton* button;
- (void)updateCurrencyBalance;
@end


@implementation ViewController
@synthesize currencyLabel, spinner, button;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


- (void) viewDidLoad
{
    // Prepare and play background music
    NSURL* audioURL = [[NSBundle mainBundle] URLForResource:@"bgmusicloop" withExtension:@"mp3"];
    audio = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    [audio setNumberOfLoops:-1];
    [audio play];
    
    // Handle virtual currency display
    [self updateCurrencyBalance];
    [self zoneLoading];
}

- (void) viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrencyBalance) name:kCurrencyBalanceChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoneReady) name:kZoneReady object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoneOff) name:kZoneOff object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoneLoading) name:kZoneLoading object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kCurrencyBalanceChange object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZoneReady object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZoneOff object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kZoneLoading object:nil];
}

- (void)zoneReady {
    [spinner stopAnimating];
    [spinner setHidden:YES];
    [button setEnabled:YES];
}

- (void)zoneOff {
    [spinner stopAnimating];
    [spinner setHidden:YES];
    [button setEnabled:NO];
}

- (void)zoneLoading {
    [spinner setHidden:NO];
    [spinner startAnimating];
    [button setEnabled:NO];
}

// Get currency balance from persistent storage and display it
- (void)updateCurrencyBalance {
    NSNumber* wrappedBalance = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrencyBalance];
    NSUInteger balance = wrappedBalance && [wrappedBalance isKindOfClass:[NSNumber class]] ? [wrappedBalance unsignedIntValue] : 0;
    [currencyLabel setText:[NSString stringWithFormat:@"%u", balance]];
}

#pragma mark -
#pragma mark AdColony-specific
// Try to play an ad from an interstitial zone, using a delegate to control the app's music
-(IBAction)triggerVideo
{
    [AdColony playVideoAdForSlot:1 withDelegate:self];
}

// Try to play an ad from a V4VC zone, using the same delegate and both of the default popups
-(IBAction)triggerV4VC
{
    [AdColony playVideoAdForSlot:2 withDelegate:self withV4VCPrePopup:YES andV4VCPostPopup:YES];
}

#pragma mark -
#pragma mark AdColonyTakeoverAdDelegate
// Callback activated when an AdColony video ad takes over the screen
//
// This implementation stops the background music
-(void)adColonyTakeoverBeganForZone:(NSString *)zone
{
    [audio stop];
}

// Callback activated when an AdColony video ad is exited by the user
//
// This implementation resumes the background music
-(void)adColonyTakeoverEndedForZone:(NSString *)zone withVC:(BOOL)withVirtualCurrencyAward
{
    [audio play];
}

// Callback activated when AdColony is unable to display an ad, which can occur when:
//  1. AdColony has not yet finished preparing ads for display
//  2. The zone has hit its session cap or V4VC cap
//  3. The zone was disabled on the adcolony.com dashboard
//  4. There was no available ad fill
//
// This implementation logs a message for record-keeping
-(void)adColonyVideoAdNotServedForZone:(NSString *)zone
{
    NSLog(@"AdColony did not play an ad for zone %@", zone);
}

@end
