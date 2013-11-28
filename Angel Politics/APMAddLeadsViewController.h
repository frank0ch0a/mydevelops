//
//  APMAddLeadsViewController.h
//  Angel Politics
//
//  Created by Francisco on 25/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APMAddLeadsViewController : UIViewController<UITextFieldDelegate>
- (IBAction)closeAddLeadVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveLeadButton;
@property (weak, nonatomic) IBOutlet UITextField *leadsNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsLastNTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsPhone;

@property (weak, nonatomic) IBOutlet UITextField *leadsDetailTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsAskTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsEmailTextField;


@property (weak, nonatomic) IBOutlet UITextField *leadsZipTextFiels;



- (IBAction)saveLeads:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *addLeadsUIView;


@end
