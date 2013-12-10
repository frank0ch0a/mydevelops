//
//  APMAppDelegate.h
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;

@class APMFrontViewController;
@class APMPhone;

@interface APMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) APMFrontViewController *viewController;
@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property(nonatomic,strong)APMPhone *phone;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;



@end
