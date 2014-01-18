//
//  APMFrontViewController.m
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMFrontViewController.h"
#import "NVSlideMenuController.h"
#import "AFJSONRequestOperation.h"
#import "APMCandidateModel.h"
#import "APMDonorDetailController.h"
#import "APMFrontCell.h"
#import "KeychainItemWrapper.h"
#import "APMLoginViewController.h"
#import "AFHTTPClient.h"
#import "APMLeadsModel.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "APMSearchResultsViewController.h"
#import "TestFlight.h"


@interface APMFrontViewController (){
    
    BOOL isLoading;
    BOOL isSearch;
    BOOL isResult;
    BOOL isSelect;
    BOOL isView;
    BOOL isTour;
    NSInteger donorKind;
    CGFloat quickSearchY;
    BOOL checked;
    NSString *phone;
    ABAddressBookRef addresBook;
    
}

// Lazy buttons
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property(strong,nonatomic)KeychainItemWrapper *keychain;
//@property(nonatomic,strong)KeychainItemWrapper *passwordItem;
@property(copy,nonatomic)NSString *email;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,strong)NSMutableArray *leadsResults;
@property(nonatomic,strong)NSString *fundRaiseType;
@property(nonatomic,strong)NSString *donorType;
@property(nonatomic,strong)NSMutableArray *searchResults;
@property(nonatomic,strong)NSArray *states;
@property(nonatomic,strong)NSMutableArray *tourContacs;

@end
static NSString *const LoadingCellIdentifier=@"LoadingCell";
static NSString *const FrontCell=@"FrontCell";



@implementation APMFrontViewController
{
    
      NSOperationQueue *queue;
    
}

@synthesize isTour=_isTour;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if ((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        queue=[[NSOperationQueue alloc]init];
        
        

    }
    
    return self;
}

#pragma mark Reachability


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    UIImage* myImage = [UIImage imageNamed:@"nav_logo"];
    self.myImageView = [[UIImageView alloc] initWithImage:myImage];
    self.myImageView.frame=CGRectMake(80, 8, 145, 26);
    [self.navigationController.navigationBar addSubview:self.myImageView];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    
    self.myImageView=nil;
    
    
}

-(void)TourBegin:(NSNotification *)notic{
    
    if ([notic.object boolValue]) {
        
        self.isTour=[notic.object boolValue];
        
        NSLog(@" IsTour %hhd",self.isTour);
        
        [self viewDidLoad];
        
        if (self.isTour) {
            NSLog(@"Is tourrrr");
        }
        
        
        
    }
    
    
    
    
}

- (void) addPopAnimationToLayer:(CALayer *)aLayer
                     withBounce:(CGFloat)bounce
                           damp:(CGFloat)damp{
    // TESTED WITH BOUNCE = 0.2, DAMP = 0.055
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 70;
    
    int steps = 100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    double value = 0;
    float e = 0.89;
    for (int t=0; t<500; t++) {
        //value = pow(e, -damp*t) * sin(bounce*t) + 1;
        value=e*cos(bounce*t)+e*sin(bounce*t);
        
        [values addObject:[NSNumber numberWithFloat:value]];
    }
    animation.values = values;
    [aLayer addAnimation:animation forKey:@"appear"];
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
    
    if (address!=NULL) {
        
        
        
        for (CFIndex j = 0; j<ABMultiValueGetCount(address);j++){
            CFDictionaryRef dict = ABMultiValueCopyValueAtIndex(address, j);
            //  CFStringRef typeTmp = ABMultiValueCopyLabelAtIndex(address, j);
            //   CFStringRef labeltype = ABAddressBookCopyLocalizedLabel(typeTmp);
            NSString *street = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStreetKey) copy];
            // NSString *city = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCityKey) copy];
            //  NSString *state = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressStateKey) copy];
            NSString *zip = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressZIPKey) copy];
            //   NSString *country = [(NSString *)CFDictionaryGetValue(dict, kABPersonAddressCountryKey) copy];
            
            donorModel.street=street;
            donorModel.zipCode=zip;
            
            
            CFRelease(dict);
            //   CFRelease(labeltype);
            //   CFRelease(typeTmp);
        }
        CFRelease(address);
        
        
    }
    
    return donorModel;
    
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
                                                                path:@"/mobile/ios_contact_tour.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            
            if (JSON !=nil) {
                
                [SVProgressHUD dismiss];
                
                NSLog(@"Result contacts %@",JSON);
                
                
                [self parseArray:JSON];
                
                self.FrontLineOne.text=@"Donor Results";
                self.frontLineTwo.hidden=YES;
                donorKind=0;
                
                [self.donorTableView reloadData];
                
                isLoading=NO;
                isSearch=NO;
                isView=YES;
                /*
                if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                    
                    
                    
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:[NSString stringWithFormat:@"You have successfully added %@ lead(s). ",[@([array count])stringValue]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    [self loadData];
                    
                   // [self.delegate dismissController:self];
                    
                    
                    
                }*/
                
                
                
                
                
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

-(void)prepareAllTourContactsToSend
{
    
    NSMutableArray *arrayContacs=[[NSMutableArray alloc]init];
    
    
    NSDictionary *dict;
    
    for (NSInteger i=0; i<[self.tourContacs count]; i++) {
        
        APMLeadsModel *donorModel=[self.tourContacs objectAtIndex:i];
        
        NSString *name=donorModel.donorName;
        NSString *lastname=donorModel.donorLastName;
        NSString *phoneContact=donorModel.donorPhoneNumber;
        NSString *email=donorModel.donorEmail;
        NSString *street=donorModel.street;
        NSString *zip=donorModel.zipCode;
        
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
        
        if (phoneContact==nil) {
            phoneContact=@"N/A";
            donorModel.donorPhoneNumber=phone;
        }else{
            
            phoneContact=donorModel.donorPhoneNumber;
            
        }
        
        if (email==nil) {
            
            email=@"N/A";
            donorModel.donorEmail=email;
        }else{
            
            email=donorModel.donorEmail;
            
            
        }
        
        if (street==nil) {
            
            street=@"N/A";
            donorModel.street=street;
        }else{
            
            street=donorModel.street;
            
            
        }
        
        
        if (zip==nil) {
            zip=@"N/A";
            donorModel.zipCode=zip;
        }else{
            
            zip=donorModel.zipCode;
            
        }
        
        
        
        dict=@{@"name": donorModel.donorName,@"lastname":donorModel.donorLastName,
               @"phone": donorModel.donorPhoneNumber,@"email":donorModel.donorEmail,@"address":donorModel.street,@"zip":donorModel.zipCode
               };
        
        [arrayContacs addObject:dict];
        
    }
    
    NSLog(@"arraycontacts %@",arrayContacs);
    
    [self sendAllContacts:arrayContacs];
    
    
    
    
    
    
    
    
}

-(void)readFromAddressBook:(ABAddressBookRef)paramAddressBook{

    
    
    NSArray *arrayOfAllPeople=(__bridge_transfer NSArray *)
    ABAddressBookCopyArrayOfAllPeople(paramAddressBook);
    
    
    
    NSUInteger peopleCounter=0;
    
    self.tourContacs=[[NSMutableArray alloc]init];
    
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
            
            
            [self.tourContacs addObject:donorModel];
            
           
            
            
            
            
            
        }
        
        
    }
    
    
    
     [self prepareAllTourContactsToSend];
    //[self configureSections];
    
    
    
    
    NSLog(@" contacts %@",self.tourContacs);
    
}

-(void)addAllTourContacts{
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    // get register to fetch notification to dissmis login Tour
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TourBegin:)
                                                 name:@"MODELVIEW TOUR" object:nil];
    
    
    
    
    self.stateTableView.hidden=YES;
    
    
    
    [self.bigButton setBackgroundImage:[UIImage imageNamed:@"bigBtnBG"] forState:UIControlStateNormal];
    
    if ([[UIScreen mainScreen] bounds].size.height == 480 && [[NSUserDefaults standardUserDefaults] boolForKey:@"IsTour"]) {
        
        self.bigButton.frame=CGRectMake(self.bigButton.frame.origin.x, -6, self.bigButton.frame.size.width, self.bigButton.frame.size.height);
        
         self.waveBigBtnView.frame=CGRectMake(self.waveBigBtnView.frame.origin.x, 44, self.waveBigBtnView.frame.size.width, self.waveBigBtnView.frame.size.height);
        self.bigButton.titleLabel.font=[UIFont systemFontOfSize:19];
        
        self.bigBtnLabel.frame=CGRectMake(self.bigBtnLabel.frame.origin.x+10, 102, self.bigBtnLabel.frame.size.width*0.9, self.bigBtnLabel.frame.size.height);
        
        self.bigBtnLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:12];
        
        
        //Make a circle button
        CGPoint saveCenter2 = self.bigButton.center;
        CGRect newFrame2 = CGRectMake(self.bigButton.frame.origin.x, self.bigButton.frame.origin.y, 200*0.80, 200*0.80);
        self.bigButton.frame = newFrame2;
        self.bigButton.layer.cornerRadius = 200*0.80 / 2.0;
        self.bigButton.center = saveCenter2;
        
        //Make a circle view
        CGPoint saveCenter = self.waveBigBtnView.center;
        CGRect newFrame = CGRectMake(self.waveBigBtnView.frame.origin.x, self.waveBigBtnView.frame.origin.y, 200*0.80, 200*0.80);
        self.waveBigBtnView.frame = newFrame;
        self.waveBigBtnView.layer.cornerRadius = 200*0.80 / 2.0;
        self.waveBigBtnView.center = saveCenter;

        
        
    }else{
    
    //Make a circle button
    CGPoint saveCenter2 = self.bigButton.center;
    CGRect newFrame2 = CGRectMake(self.bigButton.frame.origin.x, self.bigButton.frame.origin.y, 200, 200);
    self.bigButton.frame = newFrame2;
    self.bigButton.layer.cornerRadius = 200 / 2.0;
    self.bigButton.center = saveCenter2;
    
    //Make a circle view
    CGPoint saveCenter = self.waveBigBtnView.center;
    CGRect newFrame = CGRectMake(self.waveBigBtnView.frame.origin.x, self.waveBigBtnView.frame.origin.y, 200, 200);
    self.waveBigBtnView.frame = newFrame;
    self.waveBigBtnView.layer.cornerRadius = 200 / 2.0;
    self.waveBigBtnView.center = saveCenter;
    
    }
   
    
    
    
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    
    self.donorButton.layer.borderWidth=1.0f;
    self.donorButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.pledgeButton.layer.borderWidth=1.0f;
    self.pledgeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.otherButton.layer.borderWidth=1.0f;
    self.otherButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsTour"] ){
        self.FrontLineOne.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        
    }else{
        
        self.FrontLineOne.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];
    }
    
    
    
    self.frontLineTwo.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12.5];
    
    
    
    /*
     self.donorUIView.hidden=YES;
     self.pledgeUIView.hidden=YES;*/
    
    self.donorButton.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    
    self.pledgeButton.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    
    self.otherButton.titleLabel.font= [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
    
    
    
    
    
    self.fundraiseLabel.font=[UIFont fontWithName:@"Helvetica75" size:22];
    
    self.searchToolbar.hidden=YES;
    
    
    
    
    
    
}

-(void)addTourContacts:(UIButton *)sender{
    
    NSLog(@"Add all Contacts");
    
    [self addAllTourContacts];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.bigButtonUIView.hidden=YES;
    self.donorTableView.hidden=NO;
    
    [self.bigButton addTarget:self
                       action:@selector(addTourContacts:)
             forControlEvents:UIControlEventTouchUpInside];
    
    
    
    quickSearchY=self.quickSearchUIView.frame.origin.y;
   
    
    self.pitchUIView.backgroundColor=[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0];
    
    [self.donorButton setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0] forState:UIControlStateNormal];
    
        donorKind=1;
    
     self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
   
    self.searchBar.delegate=self;
    
    // get register to fetch notification to dissmis login
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(yourNotificationHandler:)
                                                 name:@"MODELVIEW DISMISS" object:nil];
    
    

    
    
    
    //NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
/*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"] &&
        [_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil&& [_keychain objectForKey:(__bridge id)kSecValueData]!=nil)*/
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"IsTour"] )
    {
          NSLog(@"Estamos de Tour!");
        
        isTour=YES;
       self.donorTableView.hidden=YES;
       self.bigButtonUIView.hidden=NO;
        
        [self addPopAnimationToLayer:self.waveBigBtnView.layer withBounce:0.099 damp:1];
      
        
        self.FrontLineOne.frame=CGRectMake(10, self.FrontLineOne.frame.origin.y
                                           , 290, self.FrontLineOne.frame.size.height);
        
        
        self.FrontLineOne.text=@"You don't have contacts to show yet";
        self.FrontLineOne.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:10.0];
        self.frontLineTwo.hidden=YES;

        
        
        
       // APMLoginViewController *loginVC=[[APMLoginViewController alloc]init];
        
        //loginVC.delegate=self;
       
        
        
    }else{
        
        isTour=NO;
        
        /*
        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasPassLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];*/
        
      
        NSLog(@" No Es Tour");
        
        
        
        //  [self presentViewController:loginVC animated:NO completion:nil];

        
        
        
        
    }
    
    // Do any additional setup after loading the view from its nib.
    
    [self.donorTableView registerNib:[self FrontCellNib] forCellReuseIdentifier:FrontCell];
    
    UINib *cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];

    cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    
    [self.donorTableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    
    [self updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:NO];
    
   // self.title=@"Angel Politics";
    
    //Hardcoding donorsinfo
    
    //Test Network
    
    if (![self connected]) {
        // not connected
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Oopss..It seems you have no internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else {
        // connected, do some internet stuff
        
        self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
        
        if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
            
            self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
            self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
            
            self.fundRaiseType=@"/mobile/leads.php";
            
            [self loadData];
            
            isLoading=YES;
            
            
        self.donorType=@"My Leads";
            
            [SVProgressHUD show];

        }
        
    }

    
   
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"states" ofType:@"plist"];
    
    self.states=[[NSArray alloc]initWithContentsOfFile:path];

    
  
    
    
}

-(void)yourNotificationHandler:(NSNotification *)notic{
    
    
    if ([notic.object isEqualToString:@"YES"]) {
        
       //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsTour"];
        
        [self viewDidLoad];
    }
    
    
}

-(UINib *)FrontCellNib
{
    return [UINib nibWithNibName:@"APMFrontCell" bundle:nil];
    
    
}



-(void)showNetworkError
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Whoops.."
                                                     message:@"There was sn error reading from Server. please try again." delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil ];
    
    [alertView show];
    
    
    
}

-(APMLeadsModel *)parseData:(NSDictionary *)dictionary{
    
    APMLeadsModel *leadsModel=[[APMLeadsModel alloc]init];
    
    if (!isResult) {
        leadsModel.ask=[dictionary objectForKey:@"a"];

    
    
    
    leadsModel.donorName=[dictionary objectForKey:@"b"];
    leadsModel.donorLastName=[dictionary objectForKey:@"c"];
    if ([dictionary objectForKey:@"d"]!=(id)[NSNull null] && [dictionary objectForKey:@"d"] !=nil ) {
      leadsModel.donorCity=[dictionary objectForKey:@"d"];
    }
    if ([dictionary objectForKey:@"e"]!=(id)[NSNull null]) {
        leadsModel.donorState=[dictionary objectForKey:@"e"];
    }
    
    
    leadsModel.donorPhoneNumber=[dictionary objectForKey:@"f"];
    
    if (!isSearch && [dictionary objectForKey:@"g"]!=(id)[NSNull null] && [dictionary objectForKey:@"g" ] != nil) {
        
        leadsModel.donor_id=[dictionary objectForKey:@"g"];
        
    }else{
        
    
        leadsModel.donorEmail=[dictionary objectForKey:@"g"];
    }
    
    
    
    if (!isSearch && [ dictionary objectForKey:@"h"] !=nil && [dictionary objectForKey:@"h"] != (id)[NSNull null]) {
           leadsModel.donor_id=[dictionary objectForKey:@"h"];
    }
    

    
    if ([dictionary objectForKey:@"i"] !=nil && [dictionary objectForKey:@"i"] != (id)[NSNull null]) {
        leadsModel.statusNet=[dictionary objectForKey:@"i"];
    }
    
    if ([dictionary objectForKey:@"j"] !=nil && [dictionary objectForKey:@"j"] != (id)[NSNull null]) {
        leadsModel.pledgeID=[dictionary objectForKey:@"j"];
    }
        
    }else{
        
        
        leadsModel.ask=[dictionary objectForKey:@"h"];
        leadsModel.party=[dictionary objectForKey:@"a"];
        leadsModel.donorName=[dictionary objectForKey:@"b"];
        leadsModel.donorLastName=[dictionary objectForKey:@"c"];
        leadsModel.donorCity=[dictionary objectForKey:@"d"];
        leadsModel.donorState=[dictionary objectForKey:@"e"];
        leadsModel.donor_id=[dictionary objectForKey:@"g"];
        
        
        
        
    }
    
    return leadsModel;
    

    
}


-(void)parseArray:(NSArray *)array
{
    
    if (array==nil) {
        NSLog(@"Expected 'results' array");
        
        return;
    }
    self.leadsResults=[[NSMutableArray alloc]init];
    
    for (NSDictionary *resultDict in array) {
        
        APMLeadsModel *leadsModel;
        
        leadsModel=[self parseData:resultDict];
        
        if(leadsModel !=nil){
            
            [self.leadsResults addObject:leadsModel];
            
            
        }
        
        
    }
    
     self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
}

-(void)loadData{
    
    
    
    
   
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.password};
    
    // NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:self.fundRaiseType
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
            [SVProgressHUD dismiss];
      NSLog(@"Resulta JSON frontVC %@",JSON);
            
            isResult=NO;
            
           [self parseArray:JSON];
            isLoading=NO;
            
            [self.donorTableView reloadData];
            isView=NO;
            
            
        }else{
            
            isLoading=NO;
            
            
            
         
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
  

    
    [queue addOperation:operation];
    
    
}

#pragma mark - Lazy buttons

- (UIImage *)listImage {
    return [UIImage imageNamed:@"ic_menu"];
}
- (UIImage *)searchImage {
    return [UIImage imageNamed:@"ic_search"];
}


- (UIBarButtonItem *)leftBarButtonItem
{
	if (!_leftBarButtonItem)
	{
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self listImage]
                                         style:UIBarButtonItemStyleBordered
                                        target:self.slideMenuController
                                        action:@selector(toggleMenuAnimated:)];
        
        [_leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barPattern"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        /*
        
		_leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
																		   target:self.slideMenuController
																		   action:@selector(toggleMenuAnimated:)];*/
	}
	return _leftBarButtonItem;
}

-(UIBarButtonItem *)rightBarButtonItem;
{
    
    
	if (!_rightBarButtonItem)
	{
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self searchImage]
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(mainSearch:)];
        
        
        [_rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barPattern"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    }
    
    
    return _rightBarButtonItem;
    
    
}


-(void)mainSearch:(id)sender {
    
    if (!isSearch) {
        self.navigationController.navigationBarHidden=YES;
        self.searchToolbar.hidden=NO;
        [self.searchBar becomeFirstResponder];
        self.addLeadsButtonOut.hidden=YES;
        self.addLeadsBig.hidden=YES;
        self.pitchUIView.backgroundColor=[UIColor whiteColor];
        self.donorUIView.backgroundColor=[UIColor whiteColor];
        self.pledgeUIView.backgroundColor=[UIColor whiteColor];
        [self.donorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.pledgeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.quickSearchUIView.frame=CGRectMake(0, 42, self.quickSearchUIView.frame.size.width, self.quickSearchUIView.frame.size.height);
            
            
        } completion:nil];
        
    }
    
    
    
}

- (void)updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:(BOOL)animated
{
    if (self.slideMenuController.slideDirection == NVSlideMenuControllerSlideFromLeftToRight)
	{
		[self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:animated];
        
	}
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.donorTableView) {
        if (isLoading) {
            return 1;
        }else{
            
            return self.leadsResults.count;
        }
    }else{
        
        return self.states.count;
        
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.donorTableView) {
        if (isLoading) {
            return  [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
        }else{
            
            APMFrontCell *cell = [tableView dequeueReusableCellWithIdentifier:FrontCell];
            
            if (cell==nil) {
                
                cell=[[APMFrontCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FrontCell];
            }
            
            
            
            cell.indexPath = indexPath;
            cell.delegate = self;
            
            APMLeadsModel *leadsModel=[self.leadsResults objectAtIndex:indexPath.row];
            
            cell.donorLabel.text=[NSString stringWithFormat:@"%@ %@",leadsModel.donorName,leadsModel.donorLastName];
            cell.amountLabel.text=[NSString stringWithFormat:@"%@",leadsModel.ask];
            
            if (leadsModel.donorCity != (id)[NSNull null]&&leadsModel.donorState != (id)[NSNull null] ) {
                cell.cityLabel.text=[NSString stringWithFormat:@"%@, %@",leadsModel.donorCity,leadsModel.donorState];
            }else{
                
                cell.cityLabel.text=@"";
            }
            
            cell.donorTypeLabel.text=self.donorType;
            
            /*
            if (isView) {
                cell.amountLabel.text=@"";
                
            }*/
            
            
            
            return cell;
            
        }
        
    }else{
        
        static NSString *CellIdentifier=@"CellIdentifier";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell==nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        cell.textLabel.text=[self.states objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];

        
        
        return  cell;
    }
    
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.leadsResults count]==0 || isLoading) {
        return nil;
    }else{
        
        return indexPath;
        
    }
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.donorTableView) {
        APMDonorDetailController *donorDetailVC=[[APMDonorDetailController alloc]init];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        APMLeadsModel *leadsModel=[self.leadsResults objectAtIndex:indexPath.row];
        
        donorDetailVC.leadsModel=leadsModel;
        donorDetailVC.title=self.donorType;
        donorDetailVC.donorType=donorKind;
        
        self.myImageView.hidden=YES;
        
        
        
        [self.navigationController pushViewController:donorDetailVC animated:YES];
        
         self.myImageView.hidden=YES;
    
    }else{
        
        self.stateTextField.text=[self.states objectAtIndex:indexPath.row];
        
        self.stateTableView.hidden=YES;
        
        [self.searchBar becomeFirstResponder];
        
        
    }
    
    
    
    
    
   

    
    
    
}

#pragma mark -
#pragma mark SwipeCellDelegate methods

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath{
    
    if ([_swipedCell compare:indexPath] != NSOrderedSame) {
        
        // Unswipe the currently swiped cell
        APMFrontCell *currentlySwipedCell = (APMFrontCell *)[self.donorTableView cellForRowAtIndexPath:_swipedCell];
        [currentlySwipedCell didSwipeLeftInCell:self];
        
    }
    
    // Set the _swipedCell property
    _swipedCell = indexPath;
    
}

-(void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath {
    
    if ([_swipedCell compare:indexPath] == NSOrderedSame) {
        
        _swipedCell = nil;
        
    }
    
}

- (IBAction)pledgeButton:(id)sender {
    
     isLoading=YES;
    
    NSLog(@"pledge press");
    self.fundRaiseType=@"/mobile/pledges.php";
    /*
    self.donorUIView.hidden=YES;
    self.pitchUIView.hidden=YES;*/
  
    self.donorType=@"Owes Me";
    self.FrontLineOne.text=@"Pledges to collect";
    self.frontLineTwo.hidden=NO;
    self.frontLineTwo.text=@"Lets turn these pledges into contributions!";
    self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
    
    if (!isSelect) {
        self.pledgeUIView.backgroundColor=[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0];
        self.donorUIView.backgroundColor=[UIColor whiteColor];
        self.pitchUIView.backgroundColor=[UIColor whiteColor];
       
       [self.pledgeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.donorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.otherButton setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0] forState:UIControlStateNormal];
          donorKind=3;
        
        isSelect = NO;
        [self loadData];
         [SVProgressHUD show];
        
        
    }
    
    else if (isSelect) {
        self.pledgeUIView.hidden=YES;
        isSelect = NO;
    }
    

    
    
    
    
   

}

- (IBAction)donorMatchButton:(id)sender {
    
    isLoading=YES;
    NSLog(@"DonorMatch Press");
    self.fundRaiseType=@"/mobile/donormatch.php";
    /*
    self.pitchUIView.hidden=YES;
    self.pledgeUIView.hidden=YES;*/
    
    self.donorType=@"New Matches";
    self.FrontLineOne.text=@"Donor-match available";
    self.frontLineTwo.hidden=NO;
    self.frontLineTwo.text=@"Unlock new donors. Make a call.";
     self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
    if (!isSelect) {
        
        self.donorUIView.backgroundColor=[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0];
        self.pitchUIView.backgroundColor=[UIColor whiteColor];
        self.pledgeUIView.backgroundColor=[UIColor whiteColor];
        
        [self.pledgeButton setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [self.donorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        isSelect = NO;
        donorKind=2;
        [self loadData];
        [SVProgressHUD show];
    }
    
    else if (isSelect) {
        self.donorUIView.hidden=YES;
         isSelect = NO;
       
    }

    
    
    
   
    
    

    
    
}

- (IBAction)PitchLeadsButton:(id)sender {
    
    isLoading=YES;
    
    NSLog(@"Pitch Press");
   self.fundRaiseType=@"/mobile/leads.php";
    /*
    self.pledgeUIView.hidden=YES;
    self.donorUIView.hidden=YES;*/
   
    self.donorType=@"My Leads";
    self.FrontLineOne.text=@"Leads available ";
    self.frontLineTwo.hidden=NO;
    self.frontLineTwo.text=@"Let’s get some contributions!";
    self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
    if (!isSelect) {
        self.pitchUIView.backgroundColor=[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0];
        self.donorUIView.backgroundColor=[UIColor whiteColor];
        self.pledgeUIView.backgroundColor=[UIColor whiteColor];
        [self.donorButton setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0] forState:UIControlStateNormal];
        [self.pledgeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         [self.otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        donorKind=1;
        
        isSelect = NO;
        [self loadData];
        
        [SVProgressHUD show];
        
    }
    
    else if (isSelect) {
        self.pitchUIView.hidden=YES;
         isSelect = NO;
        
    }
    
   
    


}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_swipedCell) {
        
        APMFrontCell *currentlySwipedCell = (APMFrontCell *)[self.donorTableView cellForRowAtIndexPath:_swipedCell];
        [currentlySwipedCell didSwipeLeftInCell:self];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.donorTableView) {
        return 65.0;
    }else{
        
        return 25.0;
    }
    
    
    
}

- (IBAction)closeSearchButton:(id)sender {
    
    self.navigationController.navigationBarHidden=NO;
    self.searchToolbar.hidden=YES;
    self.addLeadsButtonOut.hidden=NO;
    self.addLeadsBig.hidden=NO;
    self.stateTableView.hidden=YES;
    
    [self PitchLeadsButton:self];
    
    [self.searchBar resignFirstResponder];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.quickSearchUIView.frame=CGRectMake(0, quickSearchY, self.quickSearchUIView.frame.size.width, self.quickSearchUIView.frame.size.height);
        
        
    } completion:nil];
}

- (IBAction)addLeadsButton:(id)sender


{
    
    NSLog(@"tocaste addLead");
    
    [TestFlight passCheckpoint:@"press AddLeads button"];
    
    APMAddLeadsViewController *addLeads=[[APMAddLeadsViewController alloc]init];
    
    addLeads.delegate=self;
    
    
    
    [self presentViewController:NAVIFY(addLeads)
                       animated:YES
                     completion:^{
                        
                     }];
    
     self.myImageView.hidden=YES;
    //[self  presentViewController:addLeads animated:YES completion:nil];
    
    
    
    
    
}

- (IBAction)searchByPhone:(id)sender {
    
    if (!checked) {
        [self.searchByPhoneButton setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checked = YES;
        phone=@"1";
    }
    
    else if (checked) {
        [self.searchByPhoneButton setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }

}

- (IBAction)selectState:(id)sender {
    
    self.stateTableView.hidden=NO;
    [self.searchBar resignFirstResponder];
    
    
}


-(void)performSearch
{
    if ([self.searchBar.text length]>0) {
        
        [self.searchBar resignFirstResponder];
        
        
        self.addLeadsBig.hidden=NO;
     
        
        NSDictionary *dict;
        
        if (!checked && [self.stateTextField.text length]==0) {
            dict=@{@"email":self.email ,@"pass":self.password,@"q":self.searchBar.text};
        }else if (phone !=nil && [self.stateTextField.text length]==0) {
            
            dict=@{@"email":self.email ,@"pass":self.password,@"q":self.searchBar.text,@"phone":phone};
            
        }else if(!checked && [self.stateTextField.text length]>0){
            
             dict=@{@"email":self.email ,@"pass":self.password,@"q":self.searchBar.text,@"phone":@"0",@"state":self.stateTextField.text};
            
        }else{
            
             dict=@{@"email":self.email ,@"pass":self.password,@"q":self.searchBar.text,@"phone":phone,@"state":self.stateTextField.text};
            
        }
        
        
        
        
        
        NSLog(@"Parameters %@",dict);
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
        
        [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:@"/mobile/donorsearch.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            if (JSON !=nil && [JSON count]>0) {
                
                [SVProgressHUD dismiss];
                NSLog(@"Resulta JSON MenuVC %@",JSON);
                
               
                isResult=YES;
                
                [self parseArray:JSON];
                
         
                
                self.FrontLineOne.text=@"Donor Results";
                self.frontLineTwo.hidden=YES;
                donorKind=0;
            
                
        //APMSearchResultsViewController *searchVC=[[APMSearchResultsViewController alloc]init];
                
                //searchVC.arraySearch=JSON;
                
                
                
                [self.donorTableView reloadData];
                
                self.searchBar.text=@"";
                self.stateTextField.text=@"";
                 
                
              //  [self presentViewController:searchVC animated:YES completion:nil];
                
               
              //  [self viewDidLoad];
                
                isLoading=NO;
                isSearch=NO;
                isView=YES;
                
                
                
                
            }else{
                
                [SVProgressHUD dismiss];
                isSearch=NO;
                isLoading=NO;
                self.searchBar.text=@"";
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"No records were found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                [self viewDidLoad];
                
                
                
                
                
                
                
                
            }
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error %@", [error description]);
            
        }];
        
        operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
        
        
        
        
        [queue addOperation:operation];
        
        
        
    }
    
    
    
    
}

#pragma mark SearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    isSearch=YES;
    
    [SVProgressHUD show];
    
    self.navigationController.navigationBarHidden=NO;
    self.searchToolbar.hidden=YES;
    [self.searchBar resignFirstResponder];
     self.addLeadsButtonOut.hidden=NO;
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.quickSearchUIView.frame=CGRectMake(0, quickSearchY, self.quickSearchUIView.frame.size.width, self.quickSearchUIView.frame.size.height);
        
        
    } completion:nil];
    
    
    [self performSearch];
    
    
}

/*

#pragma mark Login Delegate

-(void)dissmissLoginController:(APMLoginViewController *)controller{
    
    NSLog(@"delegado login");
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        
        NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
        NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
        
        self.fundRaiseType=@"/mobile/leads.php";
        
        [self loadData];
        
    }
    
    
}*/


#pragma mark Add Delegate

-(void)dismissController:(APMAddLeadsViewController *)delegate{
    
    
    
   [self dismissViewControllerAnimated:YES completion:^{
       
        self.myImageView.hidden=NO;
       [self viewDidLoad];
       
       
       
   }];
    
    
    
    
    
}


-(void)dealloc{
    
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    
    [center removeObserver:self];
}


@end
