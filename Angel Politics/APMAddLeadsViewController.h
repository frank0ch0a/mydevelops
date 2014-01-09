//
//  APMAddLeadsViewController.h
//  Angel Politics
//
//  Created by Francisco on 25/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

@class APMAddLeadsViewController;
@protocol AddLeadsDelegate <NSObject>

-(void)dismissController:(APMAddLeadsViewController *)delegate;

@end

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface APMAddLeadsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)closeAddLeadVC:(id)sender;

@property(nonatomic,weak)id<AddLeadsDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *saveLeadButton;

@property (weak, nonatomic) IBOutlet UITextField *leadsNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsLastNTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsPhone;

@property (weak, nonatomic) IBOutlet UITextField *leadsDetailTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsAskTextField;

@property (weak, nonatomic) IBOutlet UITextField *leadsEmailTextField;


@property (weak, nonatomic) IBOutlet UITextField *leadsZipTextFiels;


- (IBAction)saveSelectedItem:(id)sender;

- (IBAction)saveLeads:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *addLeadsUIView;

- (IBAction)addContact:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong,nonatomic) UISearchDisplayController *searchController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar2;

- (IBAction)addAllContacs:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *selectToolbar;

@end
