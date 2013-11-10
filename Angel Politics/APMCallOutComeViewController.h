//
//  APMCallOutComeViewController.h
//  Angel Politics
//
//  Created by Francisco on 8/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
@class APMDetailModel;

@interface APMCallOutComeViewController : UIViewController<UITextFieldDelegate>

- (IBAction)callStatusButton:(id)sender;

- (IBAction)pledgeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *callStatusTextField;

@property (weak, nonatomic) IBOutlet UITextField *pledgeTextField;

@property (weak, nonatomic) IBOutlet UIView *mainCallOutUIView;

@property (weak, nonatomic) IBOutlet UITextField *amountPledgeTextField;

@property (weak, nonatomic) IBOutlet UILabel *askLabel;

@property (weak, nonatomic) IBOutlet UILabel *bestLabel;


@property (weak, nonatomic) IBOutlet UILabel *averageLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property(nonatomic,strong)APMDetailModel *detailModel;


@end
