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



@interface APMDonorDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,CallHelpDelegate,UIScrollViewDelegate>

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

@property (nonatomic)NSInteger donorType;
@property(nonatomic)BOOL isTour;

@property (nonatomic,copy)NSString *title;
@property (nonatomic)BOOL isADonor;


@property (weak, nonatomic) IBOutlet UIButton *emailOutlet;

@property (weak, nonatomic) IBOutlet UIButton *callButton;


- (IBAction)callOutcome:(id)sender;

- (IBAction)emailButton:(id)sender;


- (IBAction)addLeadAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *avgUIView;

@property (weak, nonatomic) IBOutlet UIView *bestUIView;

@property (weak, nonatomic) IBOutlet UIView *askUIView;
@property (weak, nonatomic) IBOutlet UILabel *askForLabel;
@property (weak, nonatomic) IBOutlet UIView *highlightsUIView;

@property (weak, nonatomic) IBOutlet UIView *donorMainUIView;
@property (weak, nonatomic) IBOutlet UIView *callMailUView;
@property (weak, nonatomic) IBOutlet UIView *highLightsBarUIView;

@property (weak, nonatomic) IBOutlet UIImageView *bgCallImageView;

@end
