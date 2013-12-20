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
    NSInteger donorKind;
    CGFloat quickSearchY;
    BOOL checked;
    NSString *phone;
}

// Lazy buttons
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property(strong,nonatomic)UIImageView* myImageView;
@property(strong,nonatomic)KeychainItemWrapper *keychain;
//@property(nonatomic,strong)KeychainItemWrapper *passwordItem;
@property(copy,nonatomic)NSString *email;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,strong)NSMutableArray *leadsResults;
@property(nonatomic,strong)NSString *fundRaiseType;
@property(nonatomic,strong)NSString *donorType;
@property(nonatomic,strong)NSMutableArray *searchResults;
@property(nonatomic,strong)NSArray *states;

@end
static NSString *const LoadingCellIdentifier=@"LoadingCell";
static NSString *const FrontCell=@"FrontCell";

@implementation APMFrontViewController{
    
      NSOperationQueue *queue;
    
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    quickSearchY=self.quickSearchUIView.frame.origin.y;
   
    
 
    
    self.pitchUIView.backgroundColor=[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0];
    
    [self.donorButton setTitleColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0] forState:UIControlStateNormal];
    
        donorKind=1;
    
     self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
   
    self.searchBar.delegate=self;
    
    // get register to fetch notification
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(yourNotificationHandler:)
                                                 name:@"MODELVIEW DISMISS" object:nil];

    
    
    
    //NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
/*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"] &&
        [_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil&& [_keychain objectForKey:(__bridge id)kSecValueData]!=nil)*/
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"] )
    {
          NSLog(@"Front!");
        
       // APMLoginViewController *loginVC=[[APMLoginViewController alloc]init];
        
        //loginVC.delegate=self;
       
        
        
    }else{
        
        /*
        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasPassLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];*/
        
      
        NSLog(@" No entro");
        
        
        
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
        [self viewDidLoad];
    }
    
    
}

-(UINib *)FrontCellNib
{
    return [UINib nibWithNibName:@"APMFrontCell" bundle:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.stateTableView.hidden=YES;
   
    
   
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    
    self.donorButton.layer.borderWidth=1.0f;
    self.donorButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.pledgeButton.layer.borderWidth=1.0f;
    self.pledgeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.otherButton.layer.borderWidth=1.0f;
    self.otherButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.FrontLineOne.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];
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
    
    
    
    [self.navigationController presentViewController:addLeads animated:YES completion:nil];
    
    
    
    
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self viewDidLoad];
    
    
}

-(void)dealloc{
    
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    
    [center removeObserver:self];
}


@end
