//
//  APMMenuViewController.m
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMMenuViewController.h"
#import "APMFrontViewController.h"
#import "NVSlideMenuController.h"
#import "MenuCell.h"
#import "APMCandidateCell.h"
#import "KeychainItemWrapper.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "APMCandidateModel.h"
#import "APMLoginViewController.h"
#import "APMCallHelpViewController.h"
#import "APMPhone.h"
#import "APMAppDelegate.h"
#import "APMEditProfileViewController.h"
#import "UIImageView+AFNetworking.h"

static NSString *const CandidateCellIdentifier=@"CandidateCell";
static NSString *const MenuCellIdentifier=@"MenuCell";
static NSString *const UrlImage=@"https://www.angelpolitics.com/uploads/profile-pictures/candidates/";
enum {
    MenuCandidate=0,
   // MenuHomeRow ,
    MenuProfile,
    MenuFundRaising,
    MenuMessages,
    MenuSettings,
    MenuHelp,
    MenuLogout,
    MenuRowCount
};


@interface APMMenuViewController (){
    
      NSOperationQueue *queue;
    
}

@property(nonatomic,strong)NSMutableArray *candidateArray;
@property(strong,nonatomic)KeychainItemWrapper *keychain;
@property(copy,nonatomic)NSString *email;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,strong)NSMutableArray *menuResults;

@end

@implementation APMMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        queue=[[NSOperationQueue alloc]init];
    }
    return self;
}


#pragma mark LoginDelegate
-(void)dissmissLoginController:(APMLoginViewController *)controller
{
    NSLog(@"Login menu Controller");
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
    
        NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
         NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
        
        [self downloadCandidateData];
        
    }
    
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle=NO;
    
    [self.tableView registerNib:[self menuCellNib] forCellReuseIdentifier:MenuCellIdentifier];
    [self.tableView registerNib:[self candidateCellNib] forCellReuseIdentifier:CandidateCellIdentifier];
    
   // self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 300);
    
    
  

    
    NSLog(@"Menu!");
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
        
    
    //NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
   // NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
    
    
    
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
    
        
        [self downloadCandidateData];

    }

    
   
}



-(APMCandidateModel *)parseDataResult:(NSDictionary *)dictionary{
    
    APMCandidateModel *candidateModel=[[APMCandidateModel alloc]init];
    
    candidateModel.candidateName=[dictionary valueForKey:@"a"];
    candidateModel.candidateLastName=[dictionary valueForKey:@"b"];
    candidateModel.officeCandidate=[dictionary valueForKey:@"c"];
    candidateModel.candidateImage=[dictionary valueForKey:@"d"];
    candidateModel.city=[dictionary valueForKey:@"e"];
    candidateModel.supportes=[dictionary valueForKey:@"f"];
    candidateModel.funraised=[dictionary valueForKey:@"g"];
    candidateModel.dayToElection=[dictionary valueForKey:@"h"];
    candidateModel.colorParty=[dictionary valueForKey:@"i"];
    
    
    return candidateModel;
    
}

-(void)parseData:(NSDictionary *)dictionary{
    
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    [array addObject:dictionary];
    
    
    
    self.menuResults=[[NSMutableArray alloc]init];
    
    for (NSDictionary *resultDict in array) {
        
        APMCandidateModel *candidatoModel;
        
        candidatoModel=[self parseDataResult:resultDict];
        
        if(candidatoModel!=nil){
            
            [self.menuResults addObject:candidatoModel];
            
            NSLog(@"results %@",self.menuResults);
            
        }
        
        
    }

    
    
    
    
    
    
}

-(void)downloadCandidateData{
    
    
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.password};
    
   // NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/login.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
            NSLog(@"Resulta JSON MenuVC %@",JSON);
            
            [self parseData:JSON];
            
            [self.tableView reloadData];
            
           
            
            
        }else{
            
            
            
            
            NSLog(@"Usuario no registrado");
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    [queue addOperation:operation];
    
    
    
}
- (UINib *)menuCellNib {
    return [UINib nibWithNibName:@"MenuCell" bundle:nil];
}

-(UINib *)candidateCellNib
{
    return [UINib nibWithNibName:@"APMCandidateCell" bundle:nil];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MenuRowCount;
}

- (void)configureCell:(MenuCell *)cell forIndexPath:(NSIndexPath *)indexPath {
   
    switch (indexPath.row) {
            
        /*
    
        case MenuHomeRow:
            cell.menuLabel.text = @"Home";
            
            break;*/
            
        case MenuProfile:
            cell.menuLabel.text = @"Edit Profile";
            cell.menuImageView.image=[UIImage imageNamed:@"ic_profile"];
            break;
            
        case MenuFundRaising:
            cell.menuLabel.text = @"Fundraise";
            cell.menuImageView.image=[UIImage imageNamed:@"ic_fundraise"];
            break;
            
        case MenuMessages:
            cell.menuLabel.text = @"Messages";
            cell.menuImageView.image=[UIImage imageNamed:@"ic_msg"];
            break;
            
        case MenuSettings:
            cell.menuLabel.text = @"Settings";
            cell.menuImageView.image=[UIImage imageNamed:@"ic_settings"];
            break;
            
        case MenuHelp:
            cell.menuLabel.text=@"Call for Free Assistance";
            cell.menuImageView.image=[UIImage imageNamed:@"ic_help"];
            break;
            
        case MenuLogout:
            cell.menuLabel.text=@"Logout";
            cell.menuImageView.image=[UIImage imageNamed:@"logout"];
            break;
            
        default:
            break;
    }
}


-(void)configureCandidateCell:(APMCandidateCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==MenuCandidate) {
        
        APMCandidateModel *candidateModel=[self.menuResults objectAtIndex:indexPath.row];
        
        cell.candidateNameLabel.text=[NSString stringWithFormat:@"%@ %@",candidateModel.candidateName,candidateModel.candidateLastName];
        cell.candidateOficceAndCityLabel.text=[NSString stringWithFormat:@"%@,%@",candidateModel.officeCandidate,candidateModel.city];
        cell.candidateSupportersLabel.text=candidateModel.supportes;
        cell.candidateFundRaisedLabel.text=candidateModel.funraised;
        cell.candidateDayToElectLabel.text=candidateModel.dayToElection;
        
       // cell.candImageView.image=[UIImage imageNamed:@"men"];
        
        [cell.candImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlImage,candidateModel.candidateImage]] placeholderImage:[UIImage imageNamed:@"men"]];
        
        if (candidateModel.colorParty!=nil) {
           
            if ([candidateModel.colorParty isEqualToString:@"blue"]) {
                cell.colorBgPartyUIView.backgroundColor=[UIColor blueColor];

            }else if ([candidateModel.colorParty isEqualToString:@"red"]){
                
                cell.colorBgPartyUIView.backgroundColor=[UIColor redColor];
                
            }else{
                
                cell.colorBgPartyUIView.backgroundColor=[UIColor greenColor];
            }
            
            
            
        }
        
        NSString *signCandidate=[NSString stringWithFormat:@"%@ %@",candidateModel.candidateName,candidateModel.candidateLastName];
       
        NSUserDefaults *registro=[NSUserDefaults standardUserDefaults];
        [registro setObject:signCandidate forKey:@"nombreCandidato"];
        [registro synchronize];

    
    }
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==MenuCandidate) {
        
        APMCandidateCell *cell=[tableView dequeueReusableCellWithIdentifier:CandidateCellIdentifier];
        
        [self configureCandidateCell:cell forIndexPath:indexPath];
        
       
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 120,320, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:lineView];
        
         return cell;
        
    }else{
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier];
    
    [self configureCell:cell forIndexPath:indexPath];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45,320, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:lineView];
        
      

        return cell;

    }
    
    
    
}

#pragma mark - table view delegate

- (BOOL)isShowingClass:(Class)class {
    UIViewController *controller = self.slideMenuController.contentViewController;
    if ([controller isKindOfClass:class]) {
        return YES;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)controller;
        if ([navController.visibleViewController isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)showControllerClass:(Class)class {
    if ([self isShowingClass:class]) {
        [self.slideMenuController toggleMenuAnimated:self];
    } else {
        id mainVC = [[class alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        [self.slideMenuController setContentViewController:nav
                                                  animated:YES
                                                completion:nil];
    }
}

- (void)showMainController {
    [self showControllerClass:[APMFrontViewController class]];
}

- (void)showLogoutController {
    //[self showControllerClass:[AboutViewController class]];
    
    APMLoginViewController *loginVC=[[APMLoginViewController alloc]init];
    
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HasPassLogin"];
   
    
    [_keychain resetKeychainItem];
    
    NSUserDefaults *registro=[NSUserDefaults standardUserDefaults];
    [registro removeObjectForKey:@"nombreCandidato"];
    [registro synchronize];
    
    
    loginVC.delegate=self;
    
    [self presentViewController:loginVC animated:NO completion:nil];
    
    
    APMFrontViewController *vc=[[APMFrontViewController alloc]init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
}

-(void)showHelpController{
    APMCallHelpViewController *helpCall=[[APMCallHelpViewController alloc]init];
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    [phone connect:@"+19143253307"];
    
    [self presentViewController:helpCall animated:YES completion:nil];
    
    
    
    
    
    
    //APMFrontViewController *vc=[[APMFrontViewController alloc]init];
    
    
    /*
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];*/
}

-(void)showProfileController{
    
    
    APMEditProfileViewController *editProfile=[[APMEditProfileViewController alloc]init];
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editProfile];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
    
    
}

-(void)showFundRaiseController{
    
    APMFrontViewController *frontVC=[[APMFrontViewController alloc]init];

    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:frontVC];
    [self.slideMenuController closeMenuBehindContentViewController:navController animated:YES completion:nil];
    

    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
            
            
        case MenuLogout:
            [self showLogoutController];
            break;
            
           
        case MenuHelp:
            [self showHelpController];
            break;
            
        case MenuProfile:
            [self showProfileController];
            break;
            
            case MenuFundRaising:
            
            [self showFundRaiseController];
            break;
}
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==MenuCandidate) {
         return 120.0f;
    }
   
    return 45.0f;
    
}


@end
