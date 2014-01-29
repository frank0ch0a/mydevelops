//
//  APMOAuthViewController.h
//  AngelPolitics
//
//  Created by Francisco on 22/01/14.
//  Copyright (c) 2014 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@interface APMOAuthViewController : UIViewController<UIWebViewDelegate>
{
   
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    
    OAToken *requestToken;
    OAToken *accessToken;
    OAConsumer *consumer;
    
    NSDictionary *profile;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
}

@property(nonatomic, strong) OAToken *requestToken;
@property(nonatomic, strong) OAToken *accessToken;
@property(nonatomic, strong) NSDictionary *profile;
@property(nonatomic, strong) OAConsumer *consumer;

- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;




@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
