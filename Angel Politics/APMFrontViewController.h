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
#import "APMAddLeadsViewController.h"
#import <AddressBook/AddressBook.h>

@class APMFrontViewController;
@class APMCandidateModel;



@interface APMFrontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,APMFrontCellProtocol,UISearchBarDelegate,AddLeadsDelegate>


@property (weak, nonatomic) IBOutlet UILabel *FrontLineOne;

@property (weak, nonatomic) IBOutlet UILabel *frontLineTwo;

@property (weak, nonatomic) IBOutlet UILabel *fundraiseLabel;

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

@property (weak, nonatomic) IBOutlet UIToolbar *searchToolbar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)closeSearchButton:(id)sender;

- (IBAction)addLeadsButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *searchByPhoneButton;

- (IBAction)searchByPhone:(id)sender;
- (IBAction)selectState:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *stateTableView;

@property (weak, nonatomic) IBOutlet UIButton *addLeadsButtonOut;

@property (weak, nonatomic) IBOutlet UIView *quickSearchUIView;

@property (weak, nonatomic) IBOutlet UITextField *stateTextField;

@property(strong,nonatomic)UIImageView* myImageView;

@property (weak, nonatomic) IBOutlet UIButton *addLeadsBig;
@property (weak, nonatomic) IBOutlet UIView *bigButtonUIView;

@property(nonatomic)BOOL isTour;

@property (weak, nonatomic) IBOutlet UIButton *bigButton;
@property (weak, nonatomic) IBOutlet UIView *waveBigBtnView;
@property (weak, nonatomic) IBOutlet UILabel *bigBtnLabel;


@property (weak, nonatomic) IBOutlet UIView *bgFundUIView;

@property (weak, nonatomic) IBOutlet UIImageView *bgFundImageView;
@end
