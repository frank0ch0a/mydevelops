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
#import "APMCandidateViewController.h"
#import "APMFrontCell.h"
#import "KeychainItemWrapper.h"
#import "APMLoginViewController.h"
#import "AFHTTPClient.h"
#import "APMLeadsModel.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "APMSearchResultsViewController.h"


@interface APMFrontViewController (){
    
    BOOL isLoading;
    BOOL isSearch;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
   
    self.searchBar.delegate=self;
    
     NSLog(@"Front!");
    
    //NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
/*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"] &&
        [_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil&& [_keychain objectForKey:(__bridge id)kSecValueData]!=nil)*/
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"]&&[_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [_keychain objectForKey:(__bridge id)kSecValueData]!=nil )
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        
    }else{
        
        /*
        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasPassLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
      
        
        
            APMLoginViewController *loginVC=[[APMLoginViewController alloc]init];
        
            loginVC.delegate=self;
        
            [self presentViewController:loginVC animated:NO completion:nil];*/

        
        
        
        
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
            
            
        self.donorType=@"Pitch    Lead";
            
            [SVProgressHUD show];

        }
        
    }

    
   
    
    

    
  
    
    
    
}


#pragma mark Login Delegate

-(void)dissmissLoginController:(APMLoginViewController *)controller{
    
    NSLog(@"delegado login");
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        
        NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
        NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
        
        self.fundRaiseType=@"/mobile/leads.php";
        
        [self loadData];
        
    }
    
    
}

-(UINib *)FrontCellNib
{
    return [UINib nibWithNibName:@"APMFrontCell" bundle:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    [self.navigationItem setRightBarButtonItem:[self rightBarButtonItem]];
    
    self.donorButton.layer.borderWidth=1.0f;
    self.donorButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.pledgeButton.layer.borderWidth=1.0f;
    self.pledgeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.otherButton.layer.borderWidth=1.0f;
    self.otherButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    UIImage* myImage = [UIImage imageNamed:@"nav_logo"];
    self.myImageView = [[UIImageView alloc] initWithImage:myImage];
    self.myImageView.frame=CGRectMake(80, 8, 145, 26);
    [self.navigationController.navigationBar addSubview:self.myImageView];
    
    self.donorUIView.hidden=YES;
    self.pledgeUIView.hidden=YES;
    
    self.fundraiseLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:25];
    
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
    
    leadsModel.ask=[dictionary objectForKey:@"a"];
    leadsModel.donorName=[dictionary objectForKey:@"b"];
    leadsModel.donorLastName=[dictionary objectForKey:@"c"];
    if ([dictionary objectForKey:@"d"]!=(id)[NSNull null]) {
      leadsModel.donorCity=[dictionary objectForKey:@"d"];
    }
    if ([dictionary objectForKey:@"e"]!=(id)[NSNull null]) {
        leadsModel.donorState=[dictionary objectForKey:@"e"];
    }
    
    
    leadsModel.donorPhoneNumber=[dictionary objectForKey:@"f"];
    leadsModel.donorEmail=[dictionary objectForKey:@"g"];
    leadsModel.donor_id=[dictionary objectForKey:@"h"];
    
    if ([dictionary objectForKey:@"i"] !=nil || [dictionary objectForKey:@"i"] != (id)[NSNull null]) {
        leadsModel.statusNet=[dictionary objectForKey:@"i"];
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
           // NSLog(@"Resulta JSON MenuVC %@",JSON);
            
           [self parseArray:JSON];
            isLoading=NO;
            
            [self.donorTableView reloadData];
            
            
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
    if (isLoading) {
        return 1;
    }else{
        
        return self.leadsResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    
      
    return cell;
        
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
    APMCandidateViewController *candidateVC=[[APMCandidateViewController alloc]init];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     APMLeadsModel *leadsModel=[self.leadsResults objectAtIndex:indexPath.row];

    candidateVC.leadsModel=leadsModel;
    candidateVC.title=self.donorType;
    
    [self.navigationController pushViewController:candidateVC animated:YES];
    
    self.myImageView.hidden=YES;
   

    
    
    
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
    self.donorUIView.hidden=YES;
    self.pitchUIView.hidden=YES;
    self.pledgeUIView.hidden=NO;
    self.donorType=@"Pledge Collection";
    self.FrontLineOne.text=@"Pledges to collect";
    self.frontLineTwo.text=@"Lets turn these pledges into contributions!";
    self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
        [self loadData];
    
     [SVProgressHUD show];
   

}

- (IBAction)donorMatchButton:(id)sender {
    
    isLoading=YES;
    NSLog(@"DonorMatch Press");
    self.fundRaiseType=@"/mobile/donormatch.php";
    self.pitchUIView.hidden=YES;
    self.pledgeUIView.hidden=YES;
    self.donorUIView.hidden=NO;
    self.donorType=@"Donor Match";
    self.FrontLineOne.text=@"Donor-match available";
    self.frontLineTwo.text=@"Unlock new donors. Make a call.";
     self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
    
    
    [self loadData];
    
     [SVProgressHUD show];

    
    
}

- (IBAction)PitchLeadsButton:(id)sender {
    
    isLoading=YES;
    
    NSLog(@"Pitch Press");
   self.fundRaiseType=@"/mobile/leads.php";
    self.pledgeUIView.hidden=YES;
    self.donorUIView.hidden=YES;
    self.pitchUIView.hidden=NO;
    self.donorType=@"Pitch    Lead";
    self.FrontLineOne.text=@"Leads available ";
    self.frontLineTwo.text=@"Let’s get some contributions!";
    self.frontNumber.text=[@([self.leadsResults count])stringValue];
    
    [self loadData];
    
     [SVProgressHUD show];


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
    
    return 65.0;
    
}

- (IBAction)closeSearchButton:(id)sender {
    
    self.navigationController.navigationBarHidden=NO;
    self.searchToolbar.hidden=YES;
    [self.searchBar resignFirstResponder];
}
/*
-(APMLeadsModel *)parseDataSearch:(NSDictionary *)dictionary
{
    
    APMLeadsModel *leadsModel=[[APMLeadsModel alloc]init];
    
    leadsModel.party=[dictionary objectForKey:@"a"];
    leadsModel.donorName=[dictionary objectForKey:@"b"];
    leadsModel.donorLastName=[dictionary objectForKey:@"c"];
    leadsModel.donorCity=[dictionary objectForKey:@"d"];
    leadsModel.donorState=[dictionary objectForKey:@"e"];
    leadsModel.donorPhoneNumber=[dictionary objectForKey:@"f"];
    leadsModel.donor_id=[dictionary objectForKey:@"g"];
    
    
    return leadsModel;
    
    
    
    
}
-(void)parseArraySearch:(NSArray *)array
{
    if (array==nil) {
        NSLog(@"Expected 'results' array");
        
        return;
    }
    self.searchResults=[[NSMutableArray alloc]init];
    
    for (NSDictionary *resultDict in array) {
        
        APMLeadsModel *leadsModel;
        
        leadsModel=[self parseDataSearch:resultDict];
        
        if(leadsModel !=nil){
            
            [self.searchResults addObject:leadsModel];
            
            
        }
        
        
    }
    
    
    
    
}
*/

-(void)performSearch
{
    if ([self.searchBar.text length]>0) {
        
        [self.searchBar resignFirstResponder];
        
        
        
        NSDictionary *dict=@{@"email":self.email ,@"pass":self.password,@"q":self.searchBar.text};
        
        // NSLog(@"Parameters %@",dict);
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
        
        [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                                path:@"/mobile/donorsearch.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            if (JSON !=nil) {
                
                [SVProgressHUD dismiss];
                // NSLog(@"Resulta JSON MenuVC %@",JSON);
                
        APMSearchResultsViewController *searchVC=[[APMSearchResultsViewController alloc]init];
                
                searchVC.arraySearch=JSON;
                
                [self presentViewController:searchVC animated:YES completion:nil];
                
                
                isLoading=NO;
                isSearch=NO;
                
                
                
            }else{
                
                isLoading=NO;
                
                
                
                
                
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
    
    [self performSearch];
    
    
}

@end
