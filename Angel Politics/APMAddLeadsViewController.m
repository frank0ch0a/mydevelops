//
//  APMAddLeadsViewController.m
//  Angel Politics
//
//  Created by Francisco on 25/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMAddLeadsViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "KeychainItemWrapper.h"
#import "APMLeadsModel.h"
#import "APMFrontViewController.h"
#import "NVSlideMenuController.h"


@interface APMAddLeadsViewController (){
    
    CGFloat yAddView;
    NSOperationQueue *queue;
    ABAddressBookRef addresBook;
    NSMutableArray *contacs;
    
}

@property(nonatomic,strong)KeychainItemWrapper *keychain;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* pass;
@property(nonatomic,strong)UILocalizedIndexedCollation *collation;
@property(nonatomic,strong)NSMutableArray *nameList;
@property(nonatomic,strong)NSArray *indexTitlesArray;
@property(nonatomic,strong)NSArray *filteredName;
@property(nonatomic,strong)NSMutableArray *selectArray;




@end

@implementation APMAddLeadsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        queue=[[NSOperationQueue alloc]init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *imageButton=[[UIImage imageNamed:@"btn_login_up"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.saveLeadButton setBackgroundImage:imageButton forState:UIControlStateNormal];
    
    self.selectToolbar.hidden=YES;
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    yAddView=self.addLeadsUIView.frame.origin.y;
    
    self.leadsDetailTextField.delegate=self;
    self.leadsNameTextField.delegate=self;
    self.leadsLastNTextField.delegate=self;
    self.leadsEmailTextField.delegate=self;
    self.leadsAskTextField.delegate=self;
    self.leadsZipTextFiels.delegate=self;
    self.leadsPhone.delegate=self;
    
    self.collation=[UILocalizedIndexedCollation currentCollation];
    
    [self LoadContacts];
    
    
    
    self.contactsTableView.allowsMultipleSelection=YES;
    
    self.selectArray=[[NSMutableArray alloc]initWithCapacity:100];

   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAddLeadVC:(id)sender {
    
    [self.delegate dismissController:self];

}

#pragma mark TextField Delegate


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField==self.leadsDetailTextField || textField==self.leadsAskTextField) {
        
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.addLeadsUIView.frame=CGRectMake(self.addLeadsUIView.frame.origin.x
                                                 , -170, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
            
        } completion:nil];
        
        
    }
    
    
    
    
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.addLeadsUIView.frame=CGRectMake(self.addLeadsUIView.frame.origin.x
                                                 , yAddView, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
            
            [textField resignFirstResponder];
            
        } completion:nil];
        
    }
    
    return YES;
    
    
}


- (IBAction)saveSelectedItem:(id)sender {
    
    self.selectToolbar.hidden=YES;
   // [self.delegate dismissController:self];
    NSLog(@"Select array %@",self.selectArray);
    

    
    NSMutableArray *arrayContacs=[[NSMutableArray alloc]init];
    
    
    NSDictionary *dict;
    
    for (NSInteger i=0; i<[self.selectArray count]; i++) {
        
        APMLeadsModel *donorModel=[self.selectArray objectAtIndex:i];
        
        NSString *name=donorModel.donorName;
        NSString *lastname=donorModel.donorLastName;
        NSString *phone=donorModel.donorPhoneNumber;
        NSString *email=donorModel.donorEmail;
        NSString *address=donorModel.address;
        
        if (name==nil) {
            name=@"N/A";
            donorModel.donorName=name;
            
        }else{
            
            name=donorModel.donorName;
        }
        
        if (lastname==nil) {
            lastname=@"N/A";
            donorModel.donorLastName=lastname;
        }else{
            
            lastname=donorModel.donorLastName;
        }
        
        if (phone==nil) {
            phone=@"N/A";
            donorModel.donorPhoneNumber=phone;
        }else{
            
            phone=donorModel.donorPhoneNumber;
            
        }
        
        if (email==nil) {
            
            email=@"N/A";
            donorModel.donorEmail=email;
        }else{
            
            email=donorModel.donorEmail;
            
            
        }
        
        if (address==nil) {
            
            address=@"N/A";
            donorModel.address=email;
        }else{
            
            address=donorModel.address;
            
            
        }
        
        
        
        dict=@{@"name": donorModel.donorName,@"lastname":donorModel.donorLastName,
               @"phone": donorModel.donorPhoneNumber,@"email":donorModel.donorEmail,@"address":donorModel.address
               };
        
        [arrayContacs addObject:dict];
        
    }
    
    NSLog(@"arraycontacts %@",arrayContacs);
    
    [self sendAllContacts:arrayContacs];
    
    
    
    
}

- (IBAction)saveLeads:(id)sender {
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.addLeadsUIView.frame=CGRectMake(self.addLeadsUIView.frame.origin.x
                                                                 , yAddView, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
                            
                            
                            
                        } completion:nil];
    
    
    [self.leadsAskTextField resignFirstResponder];
    [self.leadsEmailTextField resignFirstResponder];
    [self.leadsAskTextField resignFirstResponder];
    [self.leadsDetailTextField resignFirstResponder];
    [self.leadsZipTextFiels resignFirstResponder];
    
    if ([self.leadsNameTextField.text length]>0 || [self.leadsLastNTextField.text length]>0 || [self.leadsEmailTextField.text length]>0 || [self.leadsPhone.text length ]>0 || [self.leadsZipTextFiels.text length ]>0) {
        
        self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
        
        if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
            
            self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
            self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
            
        }
        
        
        [SVProgressHUD show];
        
        NSDictionary *dict=@{@"email":self.email,@"pass":self.pass,@"zipcode":self.leadsZipTextFiels.text,@"firstname":self.leadsNameTextField.text,@"lastname":self.leadsLastNTextField.text,@"phone":self.leadsPhone.text,@"details":self.leadsDetailTextField.text,@"inboxmail":self.leadsEmailTextField.text,@"ask":self.leadsAskTextField.text};
        
        NSLog(@"Parameters %@",dict);
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
        
        [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/mobile/addmyleads.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            if (JSON !=nil) {
                
                [SVProgressHUD dismiss];
                
                if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                    
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:[NSString stringWithFormat:@"You have successfully added  a lead."] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    [self.delegate dismissController:self];

                    
                    NSLog(@"Resulta AddLeads %@",JSON);
                }
                
                
                
                
                
            }else{
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Data do not send try again, please" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                
                
            }
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error %@", [error description]);
            
        }];
        
        operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
        
        
        
        
        [queue addOperation:operation];
        
        
    }else{
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Any field required can not be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        
        
        
    }

    
}

-(void)configureSections
{

   
    
    self.nameList=[[NSMutableArray alloc]init];
    
    for (APMLeadsModel *theName in contacs) {
        
        NSInteger section=[self.collation sectionForObject:theName
                                     collationStringSelector:@selector(donorLastName)];
        theName.section=section;
        
    }
    
    NSInteger sectionCount=[[self.collation sectionTitles]count];
    
    NSMutableArray *sectionsArray=[NSMutableArray arrayWithCapacity:sectionCount];
    
    for (NSInteger i=0; i<sectionCount; i++) {
        
        NSMutableArray *singleSectionArray=[NSMutableArray arrayWithCapacity:1];
        [sectionsArray addObject:singleSectionArray];

    }
    
    
    for (APMLeadsModel *theName in contacs) {
        [(NSMutableArray *) [sectionsArray objectAtIndex:theName.section]addObject:theName];
    }

    
    //Iterate over each section array to sort the items in the section
    
    for (NSMutableArray *singleSectionArray in sectionsArray) {
        // Use the UILocalizedIndexedCollation sortedArrayFromArray: method to sort each array
        NSArray *sortedSection = [self.collation sortedArrayFromArray:singleSectionArray collationStringSelector:@selector(donorLastName)];
        
        [self.nameList addObject:sortedSection];
        
     
    
    }
    
    
       [self.contactsTableView reloadData];
    
    // Create and configure the search controller
    self.searchController=[[UISearchDisplayController alloc]initWithSearchBar:self.searchBar2
                                                           contentsController:self];
    
    self.searchController.searchResultsDelegate=self;
    self.searchController.searchResultsDataSource=self;
    

    
    
}

-(APMLeadsModel *)logPersonEmails:(ABRecordRef)paramPerson
{
    APMLeadsModel *donorModel=[[APMLeadsModel alloc]init];
    
    NSString *name;
    NSString *lastName;
    
    
    if (paramPerson==NULL) {
        NSLog(@"The given person is NULL");
        
    }
    
    name=(__bridge_transfer NSString *)ABRecordCopyValue(paramPerson, kABPersonFirstNameProperty);
    
    if (name ==NULL)
    {
        name=@"";
        donorModel.donorName=name;
        
    }else{
        
        name=(__bridge_transfer NSString *)ABRecordCopyValue(paramPerson, kABPersonFirstNameProperty);
        
        donorModel.donorName=name;
        
    }
    
    lastName=(__bridge_transfer NSString *)ABRecordCopyValue(paramPerson, kABPersonLastNameProperty);
    
    if (lastName ==NULL) {
        
        lastName=@"";
        donorModel.donorLastName=lastName;
        

    }else{
        
        lastName=(__bridge_transfer NSString *)ABRecordCopyValue(paramPerson, kABPersonLastNameProperty);
        
        donorModel.donorLastName=lastName;
        
        
    }
    
    
    
    
    ABMultiValueRef emails=ABRecordCopyValue(paramPerson,kABPersonEmailProperty);
    
    if (emails==NULL) {
        NSLog(@"This contact does no have any emails");
        
    }
    
//Go trough all the emails
    
    NSUInteger emailCounter=0;
    
    for (emailCounter=0; emailCounter<ABMultiValueGetCount(emails) ; emailCounter++) {
        
        
        if (emails !=NULL) {
            
            donorModel.donorEmail=(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, emailCounter);
            
            NSLog(@"email %@",donorModel.donorEmail);
            
        }
        
        
         
         
    }
    
    CFRelease(emails);
    
    
    ABMultiValueRef phones=ABRecordCopyValue(paramPerson,kABPersonPhoneProperty);
    
    if (phones==NULL) {
                
    }
    
    
    //Go trough all the phone
    
    NSUInteger phoneCounter=0;
    
    for (phoneCounter=0; phoneCounter<ABMultiValueGetCount(phones) ; phoneCounter++)
    
    {
        
        //Get the label of the email (if any)
        /*
         NSString *emailLabel=(__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(emails, emailCounter);
         
         NSString *localizedEmailLabel=(__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel((__bridge CFStringRef)emailLabel);
         
         //And then get the email address itself
         
         NSString *email=(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, emailCounter);
         
         NSLog(@"Label= %@ Localized Label=%@, Email=%@",emailLabel,localizedEmailLabel,email);*/
        
        if (phones !=NULL) {
            
            donorModel.donorPhoneNumber=(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, phoneCounter);
            
          }
        
        
        
    }
    
    CFRelease(phones);
    
    
 
    
    
    ABMultiValueRef address=ABRecordCopyValue(paramPerson,kABPersonAddressProperty);
    
    if (address==NULL) {
        
    }
    
    
    
    NSUInteger addressCounter=0;
    
    for (addressCounter=0; addressCounter<ABMultiValueGetCount(address) ; addressCounter++) {
        
        
        if (address !=NULL) {
            
            donorModel.address=(__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(address, addressCounter);
            
            NSLog(@"address %@",donorModel.address);
            
        }
        
        
        
        
    }
    
    CFRelease(address);
    
    return donorModel;
    
}

-(void)readFromAddressBook:(ABAddressBookRef)paramAddressBook{
    
   
    
   
    
    
    
    NSArray *arrayOfAllPeople=(__bridge_transfer NSArray *)
    ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    
    
    
    NSUInteger peopleCounter=0;
    
    contacs=[[NSMutableArray alloc]init];
    
    //Send only 30 contacts no all [arrayOfAllPeople count]
    
    for (peopleCounter=0; peopleCounter< [arrayOfAllPeople count]; peopleCounter++) {
        
        ABRecordRef thisPerson=(__bridge ABRecordRef)[arrayOfAllPeople objectAtIndex:peopleCounter];
        
        APMLeadsModel *donorModel;
        
        
        donorModel=[self logPersonEmails:thisPerson];
        
        /*
        NSString *firstName=(__bridge_transfer NSString *)ABRecordCopyValue(thisPerson, kABPersonFirstNameProperty);
        
        NSString *lastName=(__bridge_transfer NSString *)ABRecordCopyValue(thisPerson, kABPersonLastNameProperty);
        
        NSString *phoneNumber=(__bridge_transfer NSString *)ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
        
        
       NSString *email=(__bridge_transfer NSString *)ABRecordCopyValue(thisPerson, kABPersonEmailProperty);
        
        NSLog(@"First Name=%@",firstName);
        NSLog(@"Last Name=%@",lastName);
        NSLog(@"Phone=%@",phoneNumber);
        [self logPersonEmails:thisPerson];*/
        
        if (donorModel !=nil) {
            
            
            [contacs addObject:donorModel];
            
           
            
         
            
            
            
        }
        
        
    }
    
 

     [self configureSections];
    
    
    
    
     NSLog(@" contacts %@",contacs);
    
}

-(void)LoadContacts{
    
    
    
    CFErrorRef error=NULL;
    addresBook=ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(addresBook, ^(bool granted, CFErrorRef error) {
        if (granted) {
            NSLog(@"Access granted");
            
            [self readFromAddressBook:addresBook];
            
            // [self.contactsTableView reloadData];
            
        }else{
            
            NSLog(@"Acces was not granted");
            
        }
        
        if (addresBook !=NULL) {
            CFRelease(addresBook);
        }
    });
    
    
    
    

    
    
    
}
- (IBAction)addContact:(id)sender {
    
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         
                         self.addLeadsUIView.frame=CGRectMake(-400
                                                              , self.addLeadsUIView.frame.origin.y, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
                     } completion:nil];
    

    [self.contactsTableView reloadData];
    
    
    
}



#pragma mark UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    
    if (tableView==self.contactsTableView) {
         return [self.nameList count];
    }else{
        
        return 1;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    return contacs.count;*/
    
    // Just return the count of the productsl like before
    
    if (tableView==self.contactsTableView) {
        return [[self.nameList objectAtIndex:section] count];
    }
        
        // We need the count for the filtered table
        //  First, we have to flatten the array of arrays self.products
        NSMutableArray *flattenedArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSMutableArray *theArray in self.nameList)
        {
            for (int i=0; i<[theArray count];i++)
            {
                [flattenedArray addObject:[theArray objectAtIndex:i]];
            }
        }
        
        // Set up an NSPredicate to filter the rows
        NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                  @"donorLastName beginswith[c] %@", self.searchBar2.text];
        self.filteredName = [flattenedArray
                              filteredArrayUsingPredicate:predicate];
        
        return self.filteredName.count;
        
        
        
    
    

    
}

-(void)configureCheckmarkForCell:(UITableViewCell *)cell
               withChecklistItem:(APMLeadsModel *)item{
    
   
    
    UILabel *label=(UILabel *)[cell viewWithTag:1000];
    
    
    if (item.checked) {
        
        label.text=@"√";
        
        
       [self.selectArray addObject:item];
        
       
        
        NSLog(@"Se selecciona!");
       self.selectToolbar.hidden=NO;
        
        
    }else{
        
        label.text=@"";
     
        NSLog(@"se deselecciona!");
        
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //APMLeadsModel *donorModel=[contacs objectAtIndex:indexPath.row];
    
   
    
    static NSString *CellIdentifier=@"CellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView==self.contactsTableView) {
        
         APMLeadsModel *donorModel=[[self.nameList objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",donorModel.donorName,donorModel.donorLastName];
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f];

        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(230, 10, 20, 20)];
        label.text=@"";
        label.tag=1000;
        
        UIImage *image = [UIImage imageNamed:@"btn_plus"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;	// match the button's size with the image size
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        
        // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
        [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = button;
        
         [cell addSubview:label];
        
        
        
        
        [self configureCheckmarkForCell:cell withChecklistItem:donorModel];
        
        
       return  cell;
        
    }else{
        
         APMLeadsModel *donorModel=[self.filteredName objectAtIndex:indexPath.row];
        
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 0, 40, 40)];
        label.text=@"";
        label.tag=1000;
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",donorModel.donorName,donorModel.donorLastName];
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f];
        
        UIImage *image = [UIImage imageNamed:@"btn_plus"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;	// match the button's size with the image size
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        
        
        // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
        [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = button;
        
        [cell addSubview:label];
        
       
        
        [self configureCheckmarkForCell:cell withChecklistItem:donorModel];
       
        return  cell;
        
    }
    
    
    
    
    
    
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.contactsTableView];
    
	NSIndexPath *indexPath = [self.contactsTableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.contactsTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
  
    
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    

    APMLeadsModel *item=[[self.nameList objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        
        
    
    [item toggleChecked];
    

    
    [self configureCheckmarkForCell:cell withChecklistItem:item];
        
        
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    

    
    
    


}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    

    
    if (tableView==self.contactsTableView) {
        
        self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
        
        if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
            
            self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
            self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
            
        }
        
        APMLeadsModel *donorModel=[[self.nameList objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
        
        
        NSString *name=donorModel.donorName;
        NSString *lastname=donorModel.donorLastName;
        NSString *phone=donorModel.donorPhoneNumber;
        NSString *email=donorModel.donorEmail;
        
        if (name==nil) {
            name=@"N/A";
            donorModel.donorName=name;
            
        }else{
            
            name=donorModel.donorName;
        }
        
        if (lastname==nil) {
            lastname=@"N/A";
            donorModel.donorLastName=lastname;
        }else{
            
            lastname=donorModel.donorLastName;
        }
        
        if (phone==nil) {
            phone=@"N/A";
            donorModel.donorPhoneNumber=phone;
        }else{
            
            phone=donorModel.donorPhoneNumber;
            
        }
        
        if (email==nil) {
            
            email=@"N/A";
            donorModel.donorEmail=email;
        }else{
            
            email=donorModel.donorEmail;
            
            
        }

        
        NSDictionary *dict=@{@"email":self.email,@"pass":self.pass,@"firstname":name,@"lastname":lastname,@"phone":phone,@"inboxmail":email};
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
        
        [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/mobile/addmyleads.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            if (JSON !=nil) {
                
                [SVProgressHUD dismiss];
                
                if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                    
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"You have successfully added lead." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    [self.delegate dismissController:self];
                    
                    
                    NSLog(@"Resulta AddLeads %@",JSON);
                }
                
                
                
                
                
            }else{
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Data do not send try again, please" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                
                
            }
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error %@", [error description]);
            
        }];
        
        operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
        
        
        
        
        [queue addOperation:operation];
        
        
    }else{
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Any field required can not be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        
        
        
    }

        
        
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    
    if (tableView==self.contactsTableView) {
        if ([[self.nameList objectAtIndex:section] count] > 0) {
            // If it does, get the section title from the UILocalizedIndexedCollation object
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles]
                    objectAtIndex:section];
        }
    }
    
    return nil;
    
}
-(void)sendAllContacts:(NSMutableArray *)array
{
    
    /*
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    

    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
    }
 
  */
    
   /*
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"JSON error: %@", error);
    } else {
        
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSLog(@"JSON OUTPUT: %@",JSONString);
        
        //URL
        
        NSURL *url=[NSURL URLWithString:@"https://www.angelpolitics.com/mobile/ios_contact.php"];
        
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"people" forHTTPHeaderField:@"JSON"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:[NSString stringWithFormat:@"%d",[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:jsonData];
        
        
        //NSURLResponse *response=nil;
        //  NSError *error=nil;
        
        //NSData *resultData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (error==nil){
                NSDictionary *dictJson=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                
                NSLog(@"Dictionary Json %@",dictJson);
                
            
                
            }
            
        }];
        

        
        
    }*/
    
    
    if ([NSJSONSerialization isValidJSONObject:array]) {
        
        
        NSDictionary *dict=@{@"people":array};
        NSLog(@"dict %@",dict);
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
        
        [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/mobile/ios_contact.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            
            if (JSON !=nil) {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Result contacts %@",JSON);
                
                
                
                
                if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                    
                    
                    
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:[NSString stringWithFormat:@"You have successfully added %@ lead(s). ",[@([array count])stringValue]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    [self.delegate dismissController:self];
                    
                    
                
                }
                
                
                
                
                
            }else{
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Data do not send try again, please" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                
                
            }
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error %@", [error description]);
            
        }];
        
        operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
        
        
        
        
        [queue addOperation:operation];
        
        
        
        

    
    
    }
    
    
    
    
    
    

    
}

- (IBAction)addAllContacs:(id)sender {
    
    NSMutableArray *arrayContacs=[[NSMutableArray alloc]init];
    
    
    NSDictionary *dict;
    
    for (NSInteger i=0; i<[contacs count]; i++) {
        
        APMLeadsModel *donorModel=[contacs objectAtIndex:i];
        
        NSString *name=donorModel.donorName;
        NSString *lastname=donorModel.donorLastName;
        NSString *phone=donorModel.donorPhoneNumber;
        NSString *email=donorModel.donorEmail;
        NSString *address=donorModel.address;
        
        if (name==nil) {
            name=@"N/A";
            donorModel.donorName=name;
       
        }else{
            
            name=donorModel.donorName;
        }
        
        if (lastname==nil) {
            lastname=@"N/A";
            donorModel.donorLastName=lastname;
        }else{
            
            lastname=donorModel.donorLastName;
        }
        
        if (phone==nil) {
            phone=@"N/A";
            donorModel.donorPhoneNumber=phone;
        }else{
            
            phone=donorModel.donorPhoneNumber;
            
        }
        
        if (email==nil) {
            
            email=@"N/A";
            donorModel.donorEmail=email;
        }else{
            
            email=donorModel.donorEmail;
            
            
        }
        
        if (address==nil) {
            
            address=@"N/A";
            donorModel.address=email;
        }else{
            
            address=donorModel.address;
            
            
        }
        
        
        
        dict=@{@"name": donorModel.donorName,@"lastname":donorModel.donorLastName,
               @"phone": donorModel.donorPhoneNumber,@"email":donorModel.donorEmail,@"address":donorModel.address
               };
        
        [arrayContacs addObject:dict];
        
    }
    
    NSLog(@"arraycontacts %@",arrayContacs);
    
    [self sendAllContacts:arrayContacs];
    
    
    
}
@end
