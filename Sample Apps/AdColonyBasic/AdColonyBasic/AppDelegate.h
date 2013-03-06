//
//  AppDelegate.h
//  AdColonyBasic
//
//  Created by John Fernandes-Salling on 8/14/12.
//

#import <UIKit/UIKit.h>
#import "AdColonyPublic.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, AdColonyDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
