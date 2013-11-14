//
//  APMEditCandProfileViewController.h
//  Angel Politics
//
//  Created by Francisco on 7/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//
@class APMEditCandProfileViewController;

#import <UIKit/UIKit.h>

@protocol EditCandidateDelegate <NSObject>

-(void)configEditDidUpdate:(APMEditCandProfileViewController *)controller;

@end

@interface APMEditCandProfileViewController : UIViewController<UITextFieldDelegate>{
    

        BOOL checked;
        NSString *active;


}

@property(nonatomic,weak)id<EditCandidateDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *editCandidateName;

@property (weak, nonatomic) IBOutlet UITextField *editPhone1;
@property (weak, nonatomic) IBOutlet UITextField *editPhone2;
@property (weak, nonatomic) IBOutlet UITextField *editPhone3;


@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton1;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton2;

@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton3;


- (IBAction)checkButton1:(id)sender;

- (IBAction)checkButton2:(id)sender;

- (IBAction)checkButton3:(id)sender;


- (IBAction)saveButton:(id)sender;



@end
