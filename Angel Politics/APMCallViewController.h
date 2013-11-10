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


@property (weak, nonatomic) IBOutlet UIButton *closeButtonOutlet;

@property (weak, nonatomic) IBOutlet UIView *callingUIView;
- (IBAction)closeCallVC:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *callAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailCallTextField;

@property (weak, nonatomic) IBOutlet UITextField *psCallTextField;

@property (weak, nonatomic) IBOutlet UITextField *detailsCallTextField;

@property (weak, nonatomic) IBOutlet UIButton *callPledgeButton;
@property(nonatomic,copy)NSString *candID;
@property(nonatomic,copy)NSString *donorID;


- (IBAction)callPledgeButtonAct:(id)sender;


@end