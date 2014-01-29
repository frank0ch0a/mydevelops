//
//  APMDonorDetailController.m
//  Angel Politics
//
//  Created by Francisco on 28/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMDonorDetailController.h"
#import "APMCallOutComeViewController.h"
#import "APMCallViewController.h"
#import "APMLeadsModel.h"
#import "KeychainItemWrapper.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "APMDetailModel.h"
#import "SVProgressHUD.h"
#import "APMContributionsModel.h"
#import "DonorDetailCell.h"
#import "APMCallHelpViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APMPhone.h"
#import "APMAppDelegate.h"
#import "TestFlight.h"
#import "APMFrontViewController.h"
#import "APMPosibleContributionsModel.h"
#import "APMTourTipsViewController.h"

@interface APMDonorDetailController (){
    
    BOOL isLoading;
    BOOL isPossible;
    NSOperationQueue *queue;
    NSString *phoneDial;
    CGFloat ySupport;

    
    
}

@property (nonatomic,strong)NSArray *lastDonations;
@property (nonatomic,strong)NSArray *amounts;
@property(strong,nonatomic)KeychainItemWrapper *keychain;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *pass;
@property(nonatomic,strong)NSMutableArray *detailsResults;
@property(nonatomic,strong)NSMutableArray *contributionsResults;
@property(nonatomic,strong)NSMutableArray *possibleContributions;
@property(nonatomic,strong)NSString *donorinOut;
@property (nonatomic,strong)UIView *tableHeaderView;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;


@end
static NSString *const LoadingCellIdentifier=@"LoadingCell";
static NSString *const DonorDetailCellIdentifier=@"DonorDetailCell";
static NSString *const UrlImage=@"https://www.angelpolitics.com/uploads/profile-pictures/candidates/";

@implementation APMDonorDetailController
{
    
    double  headerImageYOffset;
}
@synthesize isADonor;
@synthesize donorType=_donorType;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if ((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        queue=[[NSOperationQueue alloc]init];
        
        
        
    }
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ySupport=self.supportAmount.frame.origin.y;
  
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    UIView *blackBorderView;
 
        
        // Create an empty table header view with small bottom border view
        self.tableHeaderView = [[UIView alloc] initWithFrame: CGRectMake(6.0, 470.0, 309, 159.0)];
        _tableHeaderView.backgroundColor=[UIColor clearColor];
        
        blackBorderView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 179.0, self.view.frame.size.width, 1.0)];
        blackBorderView.backgroundColor = [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 0.8];
        [_tableHeaderView addSubview: blackBorderView];
        
    self.candTableView.tableHeaderView = _tableHeaderView;
    
    self.candTableView.backgroundColor=[UIColor clearColor];
    
    // Create the underlying imageview and offset it
        headerImageYOffset = 290.0;
        //_headerImage = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"fondo1.png"]];
        CGRect headerImageFrame = self.highlightsUIView.frame;
        headerImageFrame.origin.y = headerImageYOffset;
        self.highlightsUIView.frame = headerImageFrame;
    
        [self.view insertSubview: self.highlightsUIView belowSubview: self.candTableView];
        
        
    
    
   
    
    /*
    
    self.lastDonations=@[@"Michele Stuart",@"Charles Stanton",@"Megan Surrell"];
    self.amounts=@[@"$ 1,600",@"$ 800",@"$ 500"];*/
    
    if (self.leadsModel.donor_id !=nil &&[_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
        
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        if ([self.leadsModel.statusNet isEqualToString:@"in"] || isADonor || self.leadsModel.statusNet ==nil) {
            
            self.donorinOut=@"/mobile/donordetails.php";
            
            NSLog(@"donortype %d",self.donorType);
            
            NSLog(@"Es IN!");
            [self loadData];
            
        }else{
            
            
            if (self.donorType==1) {
                  self.donorinOut=@"/mobile/donoroutdetails_leads.php";
                
            }else if (self.donorType==3){
                
                self.donorinOut=@"/mobile/donoroutdetails_pledge.php";
                self.callButton.enabled=NO;
            }
            
            [self loadData];
             NSLog(@"Es OUT!");
            
            
            
            
            
            /*
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"User out of network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
        [alertView show];*/
            
            
            
           

        }
        
        
     
    }
    
    if (_isTour) {
        
        
        self.donorinOut=@"/mobile/donordetails_tour.php";
        
        [self loadData];
       
        
        NSLog(@"donorinout %@",self.donorinOut);
    }
    
    [self.candTableView registerNib:[self DonorDetailCellNib] forCellReuseIdentifier:DonorDetailCellIdentifier];
    
    UINib *cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    
    cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    
    [self.candTableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    self.candTableView.rowHeight=50.f;
    
    NSLog(@"isTour %hhd",self.isTour);
    
    isLoading=YES;
    
    switch (self.donorType) {
            
        case 0:
            self.emailOutlet.enabled=NO;
            self.callButton.enabled=NO;
            if (!_isTour) {
                 self.navigationItem.rightBarButtonItem=[self btnAddLead];
            }
           
            
            if (_isTour) {
                self.callButton.enabled=YES;
                 self.bgCallImageView.image=[UIImage imageNamed:@"bg_fundraise"];
            }
            
            NSLog(@"Hay Busqueda o Tour");
            
            break;
            
        case 1:
            self.emailOutlet.enabled=NO;
            break;
            
        case 2:
            self.emailOutlet.enabled=NO;
            break;
            
        case 3:
            self.emailOutlet.enabled=YES;
            break;
            
        default:
            break;
    }
    
    
    if (_isTour) {
        /*
        UIImageView *tourImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tour_call_iphone"]];
        tourImageView.alpha=2.0f;
        
        [self.view addSubview:tourImageView];*/
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    CGFloat scrollOffset=scrollView.contentOffset.y;
    CGRect headerImageFrame=self.highlightsUIView.frame;
    
    if (scrollOffset < 0) {
        //Adjust image Proportionally
        
        headerImageFrame.origin.y=headerImageYOffset-((scrollOffset / 3));
        
    }else{
        
        //We're scrolling up, return  to normal behavior
        
        headerImageFrame.origin.y=headerImageYOffset-scrollOffset;
        
        
        
    }
    
    self.highlightsUIView.frame=headerImageFrame;
    
    
}

-(UINib *)DonorDetailCellNib
{
    return [UINib nibWithNibName:@"DonorDetailCell" bundle:nil];
    
    
}


-(APMPosibleContributionsModel *)parsePossibleContributions:(NSDictionary *)dictionary{
    
    APMPosibleContributionsModel *possibleContributionsModel=[[APMPosibleContributionsModel alloc]init];
    
   
    possibleContributionsModel.contributorName=[dictionary objectForKey:@"a"];
    
    possibleContributionsModel.contributionDate=[dictionary objectForKey:@"b"];
    possibleContributionsModel.contributionAmount=[dictionary objectForKey:@"c"];
    possibleContributionsModel.image=[dictionary objectForKey:@"d"];

    
    return possibleContributionsModel;
    
    
}
-(void)parsePossible:(NSDictionary *)dictionary{
    
    
    
    NSArray *array=[dictionary objectForKey:@"posible"];
                    
                    if (array==nil) {
                        NSLog(@"Expected 'results' array");
                        
                        return;
                        
                        }
    
    self.possibleContributions=[[NSMutableArray alloc]init];
    
   
    
    for(NSDictionary *resultDict in array){
        
         APMPosibleContributionsModel *possibleContributionsModel;
        
        
        possibleContributionsModel=[self parsePossibleContributions:resultDict];
        
        
        
        
        if(possibleContributionsModel !=nil){
            
            
            [self.possibleContributions addObject:possibleContributionsModel];
            
            NSLog(@"Possible count %d ",[self.possibleContributions count]);
            
        }
        
        
    }
    
    

    
    
                    
                    
    
    
}


-(APMContributionsModel *)parseContributions:(NSDictionary *)dictionary{
    
    APMContributionsModel *contributionsModel=[[APMContributionsModel alloc]init];
    
    contributionsModel.contributorName=[dictionary objectForKey:@"a"];
    contributionsModel.contributionDate=[dictionary objectForKey:@"b"];
    contributionsModel.contributionAmount=[dictionary objectForKey:@"c"];
    contributionsModel.image=[dictionary objectForKey:@"d"];
    
    
    return contributionsModel;
    
}

-(void)parseDictionaryContributions:(NSDictionary *)dictionary{
    
   
    
    
    NSArray *array=[dictionary objectForKey:@"contribuciones"];
    
    
    if (array==nil) {
        NSLog(@"Expected 'results' array");
        
        return;
        
    }
    
    self.contributionsResults=[[NSMutableArray alloc]init];
    
    for(NSDictionary *resultDict in array){
        
        APMContributionsModel *contributionsModel;
        
        
        contributionsModel=[self parseContributions:resultDict];
        
        
        
        
        if(contributionsModel !=nil){
            
            
            [self.contributionsResults addObject:contributionsModel];
            
            NSLog(@"contributions array %@",self.contributionsResults);
            
            NSLog(@"contributions count %d",[self.contributionsResults count]);
        
        }
        
        
    }

    
    
    
}

    
    
-(APMDetailModel *)parseDetails:(NSDictionary *)dictionary
{
    
    self.detailModel=[[APMDetailModel alloc]init];
    
    if ([self.leadsModel.statusNet isEqualToString:@"in"] || self.leadsModel.statusNet ==nil) {
        
    
    
        if ([dictionary objectForKey:@"a"] != (id)[NSNull null] && [dictionary objectForKey:@"a"] != nil  ) {
            
            self.detailModel.ask=[dictionary valueForKey:@"a"];
        }
        
        if ([dictionary objectForKey:@"b"] != (id)[NSNull null] && [dictionary objectForKey:@"b"] != nil   ) {
            
            self.detailModel.name=[dictionary valueForKey:@"b"];
        }

        if ([dictionary objectForKey:@"c"] != (id)[NSNull null] && [dictionary objectForKey:@"c"] != nil  ) {
            
            self.detailModel.lastName=[dictionary valueForKey:@"c"];
        }
        
        if ([dictionary objectForKey:@"d"] != (id)[NSNull null] && [dictionary objectForKey:@"d"] != nil ) {
            
            self.detailModel.city=[dictionary valueForKey:@"d"];

        }
   
        if ([dictionary objectForKey:@"e"] != (id)[NSNull null] && [dictionary objectForKey:@"e"] != nil  ) {
            self.detailModel.state=[dictionary valueForKey:@"e"];

            
        }
   
        if ([dictionary objectForKey:@"f"] != (id)[NSNull null] && [dictionary objectForKey:@"f"] != nil  ) {
           self.detailModel.phone=[dictionary valueForKey:@"f"];
            
            
        }
        
   
        
    if ([dictionary objectForKey:@"g"] != (id)[NSNull null] && [dictionary objectForKey:@"g"] !=nil  ) {
         self.detailModel.party=[dictionary valueForKey:@"g"];
    }
   
    self.detailModel.average=[dictionary valueForKey:@"h"];
    self.detailModel.best=[dictionary valueForKey:@"i"];
        
    if ([dictionary objectForKey:@"j"] != (id)[NSNull null] && [dictionary objectForKey:@"j"] !=nil ) {
         self.detailModel.highlights1=[dictionary valueForKey:@"j"];
    }
    if ([dictionary objectForKey:@"k"] != (id)[NSNull null] && [dictionary objectForKey:@"k"] !=nil  ) {
        self.detailModel.highlights2=[dictionary valueForKey:@"k"];
    }
    
    if ([dictionary objectForKey:@"l"] != (id)[NSNull null] && [dictionary objectForKey:@"l"] !=nil  ) {
        self.detailModel.supportName=[dictionary valueForKey:@"l"];
    }
    
    if ([dictionary objectForKey:@"m"] != (id)[NSNull null] && [dictionary objectForKey:@"m"] !=nil  ) {
         self.detailModel.supportAmount=[dictionary valueForKey:@"m"];
    }
    
        if ([dictionary objectForKey:@"n"] != (id)[NSNull null] && [dictionary objectForKey:@"n"] !=nil  ) {
             self.detailModel.cand_id=[dictionary valueForKey:@"n"];
        }
        
        
        if ([dictionary objectForKey:@"o"] != (id)[NSNull null] && [dictionary objectForKey:@"o"] !=nil  ) {
            self.detailModel.donor_id=[dictionary valueForKey:@"o"];
        }

    
    
    if ([dictionary objectForKey:@"p"] != (id)[NSNull null] && [dictionary objectForKey:@"p"] !=nil  ) {
        self.detailModel.call=[dictionary valueForKey:@"p"];
    }

    
    if ([dictionary objectForKey:@"q"] != (id)[NSNull null] && [dictionary objectForKey:@"q"] !=nil  ) {
        self.detailModel.inOut=[dictionary valueForKey:@"q"];
    }
        
       
    
    
    }else if ([self.leadsModel.statusNet isEqualToString:@"out"] && self.donorType==1 ){
        
        if ([dictionary objectForKey:@"a"] != (id)[NSNull null] && [dictionary objectForKey:@"a"] != nil  ) {
            
            self.detailModel.ask=[dictionary valueForKey:@"a"];
        }
        
        if ([dictionary objectForKey:@"b"] != (id)[NSNull null] && [dictionary objectForKey:@"b"] != nil   ) {
            
            self.detailModel.name=[dictionary valueForKey:@"b"];
        }
        
        if ([dictionary objectForKey:@"c"] != (id)[NSNull null] && [dictionary objectForKey:@"c"] != nil  ) {
            
            self.detailModel.lastName=[dictionary valueForKey:@"c"];
        }
        
        if ([dictionary objectForKey:@"d"] != (id)[NSNull null] && [dictionary objectForKey:@"d"] != nil ) {
            
            self.detailModel.city=[dictionary valueForKey:@"d"];
            
            
            
        }
        
        if ([dictionary objectForKey:@"e"] != (id)[NSNull null] && [dictionary objectForKey:@"e"] != nil  ) {
            self.detailModel.state=[dictionary valueForKey:@"e"];
            
            
        }
        
        if ([dictionary objectForKey:@"f"] != (id)[NSNull null] && [dictionary objectForKey:@"f"] != nil  ) {
            self.detailModel.phone=[dictionary valueForKey:@"f"];
            
            
        }
        
        
        
        if ([dictionary objectForKey:@"g"] != (id)[NSNull null] && [dictionary objectForKey:@"g"] !=nil  ) {
            self.detailModel.party=[dictionary valueForKey:@"g"];
        }
        
        self.detailModel.average=[dictionary valueForKey:@"h"];
        self.detailModel.best=[dictionary valueForKey:@"i"];
        
        if ([dictionary objectForKey:@"j"] != (id)[NSNull null] && [dictionary objectForKey:@"j"] !=nil ) {
            self.detailModel.highlights1=[dictionary valueForKey:@"j"];
        }
        if ([dictionary objectForKey:@"k"] != (id)[NSNull null] && [dictionary objectForKey:@"k"] !=nil  ) {
            self.detailModel.highlights2=[dictionary valueForKey:@"k"];
        }
        
        if ([dictionary objectForKey:@"l"] != (id)[NSNull null] && [dictionary objectForKey:@"l"] !=nil  ) {
            self.detailModel.supportName=[dictionary valueForKey:@"l"];
        }
        
        if ([dictionary objectForKey:@"m"] != (id)[NSNull null] && [dictionary objectForKey:@"m"] !=nil  ) {
            self.detailModel.supportAmount=[dictionary valueForKey:@"m"];
        }

        
        if ([dictionary objectForKey:@"n"] != (id)[NSNull null] && [dictionary objectForKey:@"n"] !=nil ) {
            
            self.detailModel.cand_id=[dictionary valueForKey:@"n"];
        }
        
        if ([dictionary objectForKey:@"o"] != (id)[NSNull null] && [dictionary objectForKey:@"o"] !=nil ) {
            
            self.detailModel.donor_id=[dictionary valueForKey:@"o"];
        }
       
        
        if ([dictionary objectForKey:@"p"] != (id)[NSNull null] && [dictionary objectForKey:@"p"] !=nil  ) {
            self.detailModel.call=[dictionary valueForKey:@"p"];
        }
        
        
        if ([dictionary objectForKey:@"q"] != (id)[NSNull null] && [dictionary objectForKey:@"q"] !=nil  ) {
            self.detailModel.inOut=[dictionary valueForKey:@"q"];
        }

        
        
        
    }else if ([self.leadsModel.statusNet isEqualToString:@"out"] && self.donorType==3){
        
        if ([dictionary objectForKey:@"a"] != (id)[NSNull null] && [dictionary objectForKey:@"a"] != nil  ) {
            
            self.detailModel.ask=[dictionary valueForKey:@"a"];
        }
        
        if ([dictionary objectForKey:@"b"] != (id)[NSNull null] && [dictionary objectForKey:@"b"] != nil   ) {
            
            self.detailModel.name=[dictionary valueForKey:@"b"];
        }
        
        if ([dictionary objectForKey:@"c"] != (id)[NSNull null] && [dictionary objectForKey:@"c"] != nil  ) {
            
            self.detailModel.lastName=[dictionary valueForKey:@"c"];
        }
        
        if ([dictionary objectForKey:@"d"] != (id)[NSNull null] && [dictionary objectForKey:@"d"] != nil ) {
            
            self.detailModel.email=[dictionary valueForKey:@"d"];
            
            
            
        }
        
        if ([dictionary objectForKey:@"e"] != (id)[NSNull null] && [dictionary objectForKey:@"e"] != nil  ) {
            self.detailModel.details=[dictionary valueForKey:@"e"];
            
            
        }
        
        if ([dictionary objectForKey:@"f"] != (id)[NSNull null] && [dictionary objectForKey:@"f"] != nil  ) {
            self.detailModel.cand_id=[dictionary valueForKey:@"f"];
            
            
        }
        
        
        
        if ([dictionary objectForKey:@"g"] != (id)[NSNull null] && [dictionary objectForKey:@"g"] !=nil  ) {
            self.detailModel.donor_id=[dictionary valueForKey:@"g"];
        }
        
        self.detailModel.call=[dictionary valueForKey:@"h"];
        self.detailModel.inOut=[dictionary valueForKey:@"i"];

        
        
        
        
        
    }
    
    return self.detailModel;
    
    
}


- (UIBarButtonItem *)btnAddLead {
    
    
    _rightBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Add Lead" style:UIBarButtonItemStyleBordered
                                                        target:self
                                                        action:@selector(addLeadAction:)];
    
    
    [_rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"bg_tCall_Btn"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    return _rightBarButtonItem;
}
/*
- (void)addAll:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Coming Soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    
    [alert show];
    
}*/


-(void)parseDictionary:(NSDictionary *)dictionary{
    
    
    
    NSArray *array=[dictionary objectForKey:@"detalles"];
  
    
    if (array==nil) {
        NSLog(@"Expected 'results' array");
        
        return;
        
    }
    
    for(NSDictionary *resultDict in array){
        
        
        
            self.detailModel=[self parseDetails:resultDict];
        
            
       
        
        if(self.detailModel!=nil){
            
            self.askLabel.text=self.detailModel.ask;
            self.donorLabel.text=[NSString stringWithFormat:@"%@ %@",self.detailModel.name,self.detailModel.lastName];
            if (self.detailModel.city !=(id)[NSNull null] && self.detailModel.state !=(id)[NSNull null]) {
                self.cityAndStateLabel.text=[NSString stringWithFormat:@"%@, %@",self.detailModel.city,self.detailModel.state];
            }
            
            if ([self.leadsModel.statusNet isEqualToString:@"out"] && self.donorType==3) {
                self.cityAndStateLabel.hidden=YES;
                self.partyLabel.hidden=YES;
            }else if ([self.leadsModel.statusNet isEqualToString:@"out"] && self.donorType==1){
                
                self.partyLabel.hidden=YES;
                
            }
            
            NSLog(@" party %@",self.detailModel.party);
            self.partyLabel.text=self.detailModel.party;
            
            self.averageLabel.text=self.detailModel.average;
            self.bestLabel.text=self.detailModel.best;
            self.highlight1.text=self.detailModel.highlights1;
            self.highlight2.text=self.detailModel.highlights2;
            
            if (self.donorType==0) {
                
              
                
               
                
                self.supportAmount.frame=CGRectMake(self.supportAmount.frame.origin.x, 48, self.supportAmount.frame.size.width, self.supportAmount.frame.size.height);
                self.supportAmount.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
                self.nameSupport.hidden=YES;
                
            }else{
                
                if (self.detailModel.supportAmount ==nil) {
                    self.supportAmount.text=@"Supported with N/A $";
                    
                   
                }else{
                                         self.supportAmount.text=[NSString stringWithFormat:@"Supported with %@ $",self.detailModel.supportAmount];
                     NSLog(@"Suppor text %@",self.supportAmount.text);
                }
                
            }
           
            
            [self.detailsResults addObject:self.detailModel];
        }
        
        
    }
    
    
    
    
    
    
}


-(void)parseData:(NSArray *)array{
    
    
    for (NSDictionary *resultDict in array) {
       
        
            [self parseDictionary:resultDict];
        
        if ([resultDict objectForKey:@"contribuciones"]!=nil && [resultDict objectForKey:@"contribuciones"] !=(id)[NSNull null]) {
             [self parseDictionaryContributions:resultDict];
            
        }
        
        
        
        // Check count objects in posible array
        if ([resultDict objectForKey:@"posible"]!=nil && [[resultDict objectForKey:@"posible"]count]>0) {
            
           isPossible=YES;
            [self parsePossible:resultDict];
        }
        
        
        
        
    }
    
    
    
}

-(void)loadData{
    
    NSDictionary *dict;
    
    if ([self.leadsModel.statusNet isEqualToString:@"in"] || self.leadsModel.statusNet==nil ) {
        
    
    
    if (self.donorType == 3) {
        
        dict=@{@"email":self.email ,@"pass":self.pass,@"dn":self.leadsModel.donor_id,@"call":self.leadsModel.pledgeID,@"inout":self.leadsModel.statusNet};
        
        
    }else{
        
      
        if (!_isTour) {
            dict=@{@"email":self.email ,@"pass":self.pass,@"dn":self.leadsModel.donor_id};
            NSLog(@" dict matches %@",dict);
        }
       
        
    }
        
    }else{
        
        if (self.donorType==1 ) {
            dict=@{@"email":self.email ,@"pass":self.pass,@"dn":self.leadsModel.donor_id,@"call":@"320",@"inout":self.leadsModel.statusNet};
            
           
            

        }else if (self.donorType==3){
        
        
            dict=@{@"email":self.email ,@"pass":self.pass,@"dn":self.leadsModel.donor_id,@"call":self.leadsModel.pledgeID,@"inout":self.leadsModel.statusNet};
            
            NSLog(@" dict details %@",dict);
        
        
        }else if (_isTour){
             dict=@{@"dn":self.leadsModel.donor_id};
            
        }
}
    
    //NSLog(@"Donor Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:self.donorinOut
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
           NSLog(@"Resulta JSON Donor Details %@",JSON);
            
            
            
          [self parseData:JSON];
            isLoading=NO;
            
           
            
            [self.candTableView reloadData];
            
            
        }else{
            
            isLoading=NO;
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Error loading data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
            NSLog(@"Usuario no registrado");
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    
    
    
    [queue addOperation:operation];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    
    [self setTitle:self.title];
    
    self.highlightsUIView.layer.cornerRadius=5.0f;
    
    self.askLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25];
    self.bestLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    self.averageLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    
   
    
    //Create the three circle views
    
    CGPoint saveCenter = self.avgUIView.center;
    CGRect newFrame = CGRectMake(self.avgUIView.frame.origin.x, self.avgUIView.frame.origin.y, 73, 73);
    self.avgUIView.frame = newFrame;
    self.avgUIView.layer.cornerRadius = 73 / 2.0;
    self.avgUIView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.avgUIView.layer.borderWidth=1.5f;
    self.avgUIView.center = saveCenter;
    
    
    CGPoint saveCenter2 = self.bestUIView.center;
    CGRect newFrame2 = CGRectMake(self.bestUIView.frame.origin.x, self.bestUIView.frame.origin.y, 73, 73);
    self.bestUIView.frame = newFrame2;
    self.bestUIView.layer.cornerRadius = 73 / 2.0;
    self.bestUIView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.bestUIView.layer.borderWidth=1.5f;
    self.bestUIView.center = saveCenter2;
    
    
    CGPoint saveCenter3 = self.askUIView.center;
    CGRect newFrame3 = CGRectMake(self.askUIView.frame.origin.x, self.askUIView.frame.origin.y, 107, 107);
    self.askUIView.frame = newFrame3;
    self.askUIView.layer.cornerRadius = 107 / 2.0;
    self.askUIView.layer.borderColor=[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0].CGColor;
    self.askUIView.layer.borderWidth=1.5f;
    self.askUIView.center = saveCenter3;
        
    
    
    //[self.askLabel setTextColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0 ]];
    [self.askForLabel setTextColor:[UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0 ]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (!isPossible) {
        return 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (isLoading) {
        return 1;
    }else{
        
        if (isPossible && section==0) {
            return self.contributionsResults.count;
        }else if (isPossible && section==1){
            
            return  self.possibleContributions.count;
        }
        
        return self.contributionsResults.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (isLoading) {
        return  [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
    }else{
        
        DonorDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DonorDetailCellIdentifier];
        
        if (cell==nil) {
            
            cell=[[DonorDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DonorDetailCellIdentifier];
        }
    
        if (isPossible && indexPath.section==0) {
            APMContributionsModel *contributionsModel=[self.contributionsResults objectAtIndex:indexPath.row];
            
            cell.donorDetailNameLabel.text=contributionsModel.contributorName;
            
            NSLog(@"datemodel %@",contributionsModel.contributionDate);
            
            NSString *dateStr=contributionsModel.contributionDate;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            NSDate *date=[dateFormatter dateFromString:dateStr];
            
            
            
            NSDateFormatter *displayFormatter=[[NSDateFormatter alloc]init];
            [displayFormatter setDateFormat:@"MM/dd/yyyy"];
            
            
            
            NSString *displayDate=[displayFormatter stringFromDate:date];
            
            
            
            
            cell.donorDetailDateLabel.text=displayDate;
            cell.donorDetailAmountLabel.text=[NSString stringWithFormat:@"$ %@",contributionsModel.contributionAmount];
            //cell.donorDetailImage.image=[UIImage imageNamed:@"men"];
            
            [cell.donorDetailImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlImage,contributionsModel.image]] placeholderImage:[UIImage imageNamed:@"men"]];
            
            
            
            
            return cell;
        }else if (isPossible && indexPath.section==1){
            
            APMContributionsModel *contributionsModel=[self.possibleContributions objectAtIndex:indexPath.row];
            
            cell.donorDetailNameLabel.text=contributionsModel.contributorName;
            
            NSLog(@"datemodel %@",contributionsModel.contributionDate);
            
            NSString *dateStr=contributionsModel.contributionDate;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            NSDate *date=[dateFormatter dateFromString:dateStr];
            
            
            
            NSDateFormatter *displayFormatter=[[NSDateFormatter alloc]init];
            [displayFormatter setDateFormat:@"MM/dd/yyyy"];
            
            
            
            NSString *displayDate=[displayFormatter stringFromDate:date];
            
            
            
            
            cell.donorDetailDateLabel.text=displayDate;
            cell.donorDetailAmountLabel.text=[NSString stringWithFormat:@"$ %@",contributionsModel.contributionAmount];
            //cell.donorDetailImage.image=[UIImage imageNamed:@"men"];
            
            [cell.donorDetailImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlImage,contributionsModel.image]] placeholderImage:[UIImage imageNamed:@"men"]];
            
            
            
            
            return cell;

            
        }else{
            
            
            APMContributionsModel *contributionsModel=[self.contributionsResults objectAtIndex:indexPath.row];
            
            cell.donorDetailNameLabel.text=contributionsModel.contributorName;
            
            NSLog(@"datemodel %@",contributionsModel.contributionDate);
            
            NSString *dateStr=contributionsModel.contributionDate;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            NSDate *date=[dateFormatter dateFromString:dateStr];
            
            
            
            NSDateFormatter *displayFormatter=[[NSDateFormatter alloc]init];
            [displayFormatter setDateFormat:@"MM/dd/yyyy"];
            
            
            
            NSString *displayDate=[displayFormatter stringFromDate:date];
            
            
            
            
            cell.donorDetailDateLabel.text=displayDate;
            cell.donorDetailAmountLabel.text=[NSString stringWithFormat:@"$ %@",contributionsModel.contributionAmount];
            //cell.donorDetailImage.image=[UIImage imageNamed:@"men"];
            
            [cell.donorDetailImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlImage,contributionsModel.image]] placeholderImage:[UIImage imageNamed:@"men"]];
            
            
            
            
            return cell;

            
            
        }

        }
        
    
    
}

- (UIView *) tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    
    
    
    if (isPossible && section ==0 && [self.contributionsResults count]>0 ) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
        
        
        
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"call_grey_bar"]];
        
        /*
         UIImage *image = [UIImage imageNamed:@"encabezadoMenu.png"];
         
         UIImageView *headerImage = [[UIImageView alloc] initWithImage: image];
         
         [headerView addSubview:headerImage];*/
        
        UILabel *menuText=[[UILabel alloc]initWithFrame:CGRectMake(15, 6, 240, 30)];
        menuText.backgroundColor=[UIColor clearColor];
        menuText.text=@"Last Donations";
        menuText.font=[UIFont fontWithName:@"Helvetica75" size:17.0];
        
        [headerView addSubview:menuText];
        
        
        
        
        return headerView;

        
    }else if (isPossible && section==1 && [self.possibleContributions count]>0){
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
        
        
        
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"call_grey_bar"]];
        
        /*
         UIImage *image = [UIImage imageNamed:@"encabezadoMenu.png"];
         
         UIImageView *headerImage = [[UIImageView alloc] initWithImage: image];
         
         [headerView addSubview:headerImage];*/
        
        UILabel *menuText=[[UILabel alloc]initWithFrame:CGRectMake(15, 6, 240, 30)];
        menuText.backgroundColor=[UIColor clearColor];
        menuText.text=@"Possible Contributions";
        menuText.font=[UIFont fontWithName:@"Helvetica75" size:17.0];
        
        [headerView addSubview:menuText];
        
        
        
        
        return headerView;
        
        
        
    }
    
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
    
    
    
    headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"call_grey_bar"]];
    
    /*
     UIImage *image = [UIImage imageNamed:@"encabezadoMenu.png"];
     
     UIImageView *headerImage = [[UIImageView alloc] initWithImage: image];
     
     [headerView addSubview:headerImage];*/
    
    UILabel *menuText=[[UILabel alloc]initWithFrame:CGRectMake(15, 6, 240, 30)];
    menuText.backgroundColor=[UIColor clearColor];
    menuText.text=@"Last Donations";
    menuText.font=[UIFont fontWithName:@"Helvetica75" size:17.0];
    
    [headerView addSubview:menuText];
    
   
    
    
        return headerView;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 40.0;
    
}


#pragma mark tableviewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}


- (IBAction)callOutcome:(id)sender {
    
    
    if (_isTour) {
        
        APMTourTipsViewController *tourVC=[[APMTourTipsViewController alloc]init];
        
        
        [self.view addSubview:tourVC.view];
        [self addChildViewController:tourVC];
        
        [tourVC didMoveToParentViewController:self];
        
        
        
    }else {
    
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Check"] ){
        
       
        
    NSUserDefaults *phoneCall=[NSUserDefaults standardUserDefaults];
        
       phoneDial=[phoneCall objectForKey:@"phone"];
        
    }else{
        
        if (self.detailModel.phone !=nil || self.detailModel.phone !=(id)[NSNull null]) {
            
            phoneDial=self.detailModel.phone;
            
        }
        
        
    }
    
   
    
   // NSString *codeNumber=[NSString stringWithFormat:@"+1%@",phoneDial];
    
    //Get appdelegate class to make a call
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    [phone connect:phoneDial];
    
    [TestFlight passCheckpoint:@"Call test"];
    
    [TestFlight submitFeedback:phoneDial];
    
    NSLog(@"phonetest %@",phoneDial);

    
    APMCallHelpViewController *callVC=[[APMCallHelpViewController alloc]init];
    
    callVC.delegate=self;
    
    [self presentViewController:callVC animated:NO completion:nil];
    
    callVC.callLabel.text=[NSString stringWithFormat:@"Calling \n %@ %@",self.detailModel.name,self.detailModel.lastName];
    callVC.ask.text=self.detailModel.ask;
    callVC.cityAndState.text=[NSString stringWithFormat:@"%@, %@",self.detailModel.city,self.detailModel.state];
    callVC.high1Label.text=self.detailModel.highlights1;
    callVC.high2Label.text=self.detailModel.highlights2;
    
    
    
    /*
    APMCallOutComeViewController *callOut=[[APMCallOutComeViewController alloc]init];
    
    callOut.detailModel=self.detailModel;
    
    [self.navigationController pushViewController:callOut animated:YES];*/
    
    
    
    /*
    APMCallViewController *apmCallVC=[[APMCallViewController alloc]init];
    
    [self.view addSubview:apmCallVC.view];
    [self addChildViewController:apmCallVC];
    [apmCallVC didMoveToParentViewController:self];*/

    }
}

- (IBAction)emailButton:(id)sender {
    
    [queue cancelAllOperations];
    
    NSString *email;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Check"] ){
        
        
        
        NSUserDefaults *sendEmail=[NSUserDefaults standardUserDefaults];
        
        email=[sendEmail objectForKey:@"email"];
        
    }
    
    [SVProgressHUD show];
    
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.pass,@"call":self.detailModel.call,@"inout":self.detailModel.inOut,@"demomail":email};
    
    NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/sendreminder.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
            [SVProgressHUD dismiss];
            NSLog(@"Resulta JSON sendmailreminder %@",JSON);
            
            if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"email sent successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alertView show];
                
            }
           
            
            
        }else{
            
            isLoading=NO;
            
           [SVProgressHUD dismiss];
            
            
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        [SVProgressHUD dismiss];
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    
    
    
    [queue addOperation:operation];
    
    
    /*
    if ([MFMailComposeViewController canSendMail]) {
        
         NSUserDefaults *candName= [NSUserDefaults standardUserDefaults];
        
        NSString *sign=[candName objectForKey:@"nombreCandidato"];
        
        
        MFMailComposeViewController *mailComposer =[[MFMailComposeViewController alloc] init];
        
        mailComposer.mailComposeDelegate = self ;
        
        NSString *destinatario=[[NSString alloc]init];
        
        
        destinatario=@"ricardo@angelpolitics.com";
        
        NSArray *destinatarios=[NSArray arrayWithObject:destinatario];
        
        
        NSMutableString *cuerpoDelMensaje = [[NSMutableString alloc] init];
        
        [mailComposer setToRecipients:destinatarios];
        
        [mailComposer setSubject:@"Pledge Reminder"];
        
        [cuerpoDelMensaje appendString:[ NSString stringWithFormat:@"Hello %@ ,\n\n I want to express my appreciation and thank you again for your pledge of $1 that you made to my campaign on October 31st.\n\n You can make your contribution online by clicking here.\n\n %@",self.detailModel.name,sign]];
        
        [mailComposer setMessageBody:cuerpoDelMensaje isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:^{
            nil;
        }];
        
        
    }*/
    

}
/*
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}*/

#pragma mark CallHelpDelegate

-(void)CallHelpDidDismiss:(APMCallHelpViewController *)controller{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    APMCallOutComeViewController *callOut=[[APMCallOutComeViewController alloc]init];
    
   
    
    //Override backBarButton title
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                style:UIBarButtonItemStyleBordered
               target:nil
               action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                    style:UIBarButtonItemStylePlain
                   target:nil
                   action:nil];
        
        [[self navigationItem] setBackBarButtonItem:backButton];
        
       
       // [backButton setImage:[UIImage imageNamed:@"ic_back"]];
     
       [[UIBarButtonItem appearance]setTintColor:[UIColor whiteColor]];
        
        

    }


    
    callOut.detailModel=self.detailModel;
    
    [self.navigationController pushViewController:callOut animated:YES];
    
    
}


- (IBAction)addLeadAction:(id)sender {
    
    NSLog(@"Tocaste Boton Lead");
    
    
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.pass,@"dn":self.leadsModel.donor_id};
    
    NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/addtolist.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"a"] isEqualToString:@"Ok"]) {
            
        
            APMFrontViewController *frontVC=[[APMFrontViewController alloc]init];
            
            [self.navigationController pushViewController:frontVC animated:YES];
    
            NSLog(@"Lead Added");
            
        }else{
            
            
            
            
            
            
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    
    
    
    [queue addOperation:operation];
    
    

}
@end
