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
#import "KeychainItemWrapper.h"

@interface APMLoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,weak)id<LoginDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(nonatomic,strong)KeychainItemWrapper *keyChain;

@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@property (weak, nonatomic) IBOutlet UIView *loginUIView;

- (IBAction)loginButton:(id)sender;

@end
