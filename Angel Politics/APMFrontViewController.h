//
//  APMFrontViewController.h
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "APMFrontCellProtocol.h"
#import "APMLoginViewController.h"
@class APMFrontViewController;
@class APMCandidateModel;



@interface APMFrontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,APMFrontCellProtocol,LoginDelegate>


@property (weak, nonatomic) IBOutlet UILabel *FrontLineOne;

@property (weak, nonatomic) IBOutlet UILabel *frontLineTwo;


@property (weak, nonatomic) IBOutlet UILabel *frontNumber;


@property (weak, nonatomic) IBOutlet UITableView *donorTableView;
@property (weak, nonatomic) IBOutlet UIButton *donorButton;

@property (weak, nonatomic) IBOutlet UIButton *pledgeButton;

@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@property (nonatomic, strong) NSIndexPath *swipedCell;

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath;
-(void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath;

- (IBAction)pledgeButton:(id)sender;


- (IBAction)donorMatchButton:(id)sender;

- (IBAction)PitchLeadsButton:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *pitchUIView;

@property (weak, nonatomic) IBOutlet UIView *donorUIView;
@property (weak, nonatomic) IBOutlet UIView *pledgeUIView;


@end
