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


@interface APMFrontViewController (){
    
    BOOL isLoading;
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    
    
    //NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
/*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"] &&
        [_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil&& [_keychain objectForKey:(__bridge id)kSecValueData]!=nil)*/
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasPassLogin"] )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasPassLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
            APMLoginViewController *loginVC=[[APMLoginViewController alloc]init];
            
            [self presentViewController:loginVC animated:YES completion:nil];

            
        
        
        
    }
    
    // Do any additional setup after loading the view from its nib.
    
    [self.donorTableView registerNib:[self FrontCellNib] forCellReuseIdentifier:FrontCell];
    
    UINib *cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];

    cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    
    [self.donorTableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    
    [self updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:NO];
    
   // self.title=@"Angel Politics";
    
    //Hardcoding donorsinfo
    
   
    
    self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
    self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
                    
    
    [self loadData];
    
    
    isLoading=YES;
}


-(UINib *)FrontCellNib
{
    return [UINib nibWithNibName:@"APMFrontCell" bundle:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    
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
    leadsModel.donorCity=[dictionary objectForKey:@"d"];
    leadsModel.donorState=[dictionary objectForKey:@"e"];
    leadsModel.donorPhoneNumber=[dictionary objectForKey:@"f"];
    leadsModel.donorEmail=[dictionary objectForKey:@"g"];
    
    
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
    
    
    
}

-(void)loadData{
    
   
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.password};
    
    // NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/leads.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
           // NSLog(@"Resulta JSON MenuVC %@",JSON);
            
           [self parseArray:JSON];
            isLoading=NO;
            
            [self.donorTableView reloadData];
            
            
        }else{
            
            isLoading=NO;
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Usuario no registrado" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
            NSLog(@"Usuario no registrado");
            
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
    return [UIImage imageNamed:@"ic_Search"];
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
    
    NSLog(@" Search Button");
    
}

- (void)updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:(BOOL)animated
{
    if (self.slideMenuController.slideDirection == NVSlideMenuControllerSlideFromLeftToRight)
	{
		[self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:animated];
        [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:animated];
	
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
    cell.amountLabel.text=leadsModel.ask;
    cell.cityLabel.text=leadsModel.donorCity;
    
    
      
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

@end
