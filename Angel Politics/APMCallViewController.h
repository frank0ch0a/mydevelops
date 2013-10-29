//
//  APMCallViewController.h
//  Angel Politics
//
//  Created by Francisco on 28/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface APMCallViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

- (IBAction)DialButton:(id)sender;

- (IBAction)hangUpButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *callingUIView;
- (IBAction)closeCallVC:(id)sender;

@end