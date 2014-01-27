//
//  APMAppDelegate.m
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMAppDelegate.h"
#import "NVSlideMenuController.h"
#import "APMFrontViewController.h"
#import "APMMenuViewController.h"
#import "TestFlight.h"
#import "KeychainItemWrapper.h"
#import "APMPhone.h"

NSString *const FBSessionStateChangedNotification =
@"com.angelpolitics.AngelPolitics:FBSessionStateChangedNotification";


@implementation APMAppDelegate

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}
/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = @[
                             @"basic_info",
                             @"email",
                             @"user_likes"];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   
    

    
    self.phone = [[APMPhone alloc] init];
    /*
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"APUser" accessGroup:nil];
    
    [keychainItem resetKeychainItem];*/
    
    [TestFlight takeOff:@"c7da1f26-d375-4758-b8ee-e6a58d64f9b9"];
    
    [self customizeAppearance];
    
    
    APMMenuViewController *menuViewController=[[APMMenuViewController alloc]init];
    
    
/*
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([self.viewController respondsToSelector:@selector(setEdgesForExtendedLayout:)])  {
        self.viewController.edgesForExtendedLayout &= ~UIRectEdgeTop;
    }
#endif
#endif
#endif*/
      
    self.viewController=[[APMFrontViewController alloc]initWithNibName:@"APMFrontViewController" bundle:nil];
    
    UINavigationController *navc=[[UINavigationController alloc]initWithRootViewController:self.viewController];
    
    
  
    
    
    NVSlideMenuController *slideMenuController=[[NVSlideMenuController alloc]initWithMenuViewController:menuViewController andContentViewController:navc];
    
#ifdef __IPHONE_7_0
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    if ([slideMenuController respondsToSelector:@selector(setEdgesForExtendedLayout:)])  {
        slideMenuController.edgesForExtendedLayout &= ~UIRectEdgeTop;
    }
#endif
#endif
#endif
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    self.window.rootViewController=slideMenuController;
    
    return YES;
}



-(void)customizeAppearance
{
    
    UIImage *barImage=[UIImage imageNamed:@"bg_tCall_Btn"];
    
   // [[UISearchBar appearance]setBackgroundImage:barImage];
    
    [[UINavigationBar appearance]setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    /*
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0]];*/
    
    
    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:barImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
  
    
    [[UISearchBar appearance]setBackgroundImage:barImage];
     
    /*
    [[UIButton appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:barImage forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearance]setBackgroundImage:barImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];*/
    
    [[UIBarButtonItem appearance]setTintColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0]];
    
    [[UIToolbar appearance] setBackgroundImage:barImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  
    
    
    /*
    UIColor *tintColor=[UIColor colorWithRed:40/255.0f green:50/255.0f blue:50/255.0f alpha:1.0f];
    
    
    [[UISegmentedControl appearance]setTintColor:tintColor];*/
    
    
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
