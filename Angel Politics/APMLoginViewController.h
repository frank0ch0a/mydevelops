//
//  APMLoginViewController.h
//  Angel Politics
//
//  Created by Francisco on 26/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

@class APMLoginViewController;
@protocol LoginDelegate <NSObject>

-(void)dissmissLoginController:(APMLoginViewController *)controller;


@end



#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "KeychainItemWrapper.h"

@interface APMLoginViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic,weak)id<LoginDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic,strong)KeychainItemWrapper *keyChain;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIView *loginUIView;

- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *emailLine;

@property (weak, nonatomic) IBOutlet UIView *passLine;

- (IBAction)btnFacebookPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIView *scrollUIView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *takeTourBtn;
- (IBAction)takeTour:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *tryTourUIView;



@end
