//
//  APMDonorDetailController.h
//  Angel Politics
//
//  Created by Francisco on 28/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "APMCallHelpViewController.h"
@class APMLeadsModel;
@class APMDetailModel;



@interface APMDonorDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,CallHelpDelegate>

@property(nonatomic,strong)APMLeadsModel *leadsModel;
@property(nonatomic,strong)APMDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UILabel *donorLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityAndStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *partyLabel;

@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;

@property (weak, nonatomic) IBOutlet UILabel *bestLabel;

@property (weak, nonatomic) IBOutlet UITableView *candTableView;

@property (weak, nonatomic) IBOutlet UILabel *highlight2;

@property (weak, nonatomic) IBOutlet UILabel *highlight1;

@property (weak, nonatomic) IBOutlet UILabel *supportAmount;

@property (weak, nonatomic) IBOutlet UILabel *nameSupport;

@property (nonatomic,copy)NSString *title;
@property (nonatomic)BOOL isADonor;



- (IBAction)callOutcome:(id)sender;

- (IBAction)emailButton:(id)sender;


@end
