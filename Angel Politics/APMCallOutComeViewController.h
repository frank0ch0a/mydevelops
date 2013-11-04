//
//  APMCallOutComeViewController.h
//  Angel Politics
//
//  Created by Francisco on 8/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APMCallOutComeViewController : UIViewController

- (IBAction)callStatusButton:(id)sender;

- (IBAction)pledgeButton:(id)sender;

- (IBAction)dialButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *callStatusTextField;

@property (weak, nonatomic) IBOutlet UITextField *pledgeTextField;




@end
