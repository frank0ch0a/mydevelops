//
//  APMEditProfileViewController.h
//  Angel Politics
//
//  Created by Francisco on 6/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APMEditCandProfileViewController.h"

@interface APMEditProfileViewController : UIViewController<EditCandidateDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameProfileLabel;

@property (weak, nonatomic) IBOutlet UITextField *phone1Label;

@property (weak, nonatomic) IBOutlet UITextField *phone2Label;
@property (weak, nonatomic) IBOutlet UITextField *phone3Label;
- (IBAction)editCandprofile:(id)sender;
- (IBAction)dialButton:(id)sender;

- (IBAction)hangUpButton:(id)sender;


@end
