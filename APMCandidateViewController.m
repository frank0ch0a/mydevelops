//
//  APMCandidateViewController.m
//  Angel Politics
//
//  Created by Francisco on 28/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMCandidateViewController.h"
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

@interface APMCandidateViewController (){
    
    BOOL isLoading;
    NSOperationQueue *queue;
    
    
}

@property (nonatomic,strong)NSArray *lastDonations;
@property (nonatomic,strong)NSArray *amounts;
@property(strong,nonatomic)KeychainItemWrapper *keychain;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *pass;
@property(nonatomic,strong)NSMutableArray *detailsResults;
@property(nonatomic,strong)NSMutableArray *contributionsResults;

@end
static NSString *const LoadingCellIdentifier=@"LoadingCell";
static NSString *const DonorDetailCellIdentifier=@"DonorDetailCell";
static NSString *const UrlImage=@"https://www.angelpolitics.com/uploads/profile-pictures/candidates/";

@implementation APMCandidateViewController
@synthesize isADonor;


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
    /*
    
    self.lastDonations=@[@"Michele Stuart",@"Charles Stanton",@"Megan Surrell"];
    self.amounts=@[@"$ 1,600",@"$ 800",@"$ 500"];*/
    
    if (self.leadsModel.donor_id !=nil &&[_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
        
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        if ([self.leadsModel.statusNet isEqualToString:@"in"] || isADonor) {
            
            NSLog(@"Es IN!");
            [self loadData];
        }else{
            
             NSLog(@"Es OUT!");
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"User out of network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
        
        
     
    }
    
    
    [self.candTableView registerNib:[self DonorDetailCellNib] forCellReuseIdentifier:DonorDetailCellIdentifier];
    
    UINib *cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    
    cellNib=[UINib nibWithNibName:LoadingCellIdentifier bundle:nil];
    
    [self.candTableView registerNib:cellNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    self.candTableView.rowHeight=50.f;
    
    isLoading=YES;
    
}


-(UINib *)DonorDetailCellNib
{
    return [UINib nibWithNibName:@"DonorDetailCell" bundle:nil];
    
    
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
            
            //NSLog(@"contributions array %@",self.contributionsResults);
        }
        
        
    }

    
    
    
}

    
    
    
    
    
    

-(APMDetailModel *)parseDetails:(NSDictionary *)dictionary
{
    
    self.detailModel=[[APMDetailModel alloc]init];
    
    self.detailModel.ask=[dictionary valueForKey:@"a"];
    self.detailModel.name=[dictionary valueForKey:@"b"];
    self.detailModel.lastName=[dictionary valueForKey:@"c"];
    self.detailModel.city=[dictionary valueForKey:@"d"];
    self.detailModel.state=[dictionary valueForKey:@"e"];
    self.detailModel.phone=[dictionary valueForKey:@"f"];
    self.detailModel.party=[dictionary valueForKey:@"g"];
    self.detailModel.average=[dictionary valueForKey:@"h"];
    self.detailModel.best=[dictionary valueForKey:@"i"];
    self.detailModel.highlights1=[dictionary valueForKey:@"j"];
    self.detailModel.highlights2=[dictionary valueForKey:@"k"];
    self.detailModel.supportName=[dictionary valueForKey:@"l"];
    self.detailModel.supportAmount=[dictionary valueForKey:@"m"];
    self.detailModel.cand_id=[dictionary valueForKey:@"n"];
    self.detailModel.donor_id=[dictionary valueForKey:@"o"];
    
    
    return self.detailModel;
    
    
}

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
            self.cityAndStateLabel.text=[NSString stringWithFormat:@"%@, %@",self.detailModel.city,self.detailModel.state];
            self.averageLabel.text=self.detailModel.average;
            self.bestLabel.text=self.detailModel.best;
            self.highlight1.text=self.detailModel.highlights1;
            self.highlight2.text=self.detailModel.highlights2;
            
            if (self.detailModel.supportAmount !=(id)[NSNull null]) {
                self.supportAmount.text=[NSString stringWithFormat:@"Supported with %@ $",self.detailModel.supportAmount];
            }
            if (self.detailModel.supportName !=(id)[NSNull null]) {
                self.nameSupport.text=self.detailModel.supportName;
            }

            
            [self.detailsResults addObject:self.detailModel];
        }
        
        
    }
    
    
    
    
    
    
}


-(void)parseData:(NSArray *)array{
    
    
    for (NSDictionary *resultDict in array) {
       
        
            [self parseDictionary:resultDict];
            
            [self parseDictionaryContributions:resultDict];
        
    }
    
    
    
}

-(void)loadData{
    
    
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.pass,@"dn":self.leadsModel.donor_id};
    
    // NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/donordetails.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
            NSLog(@"Resulta JSON MenuVC %@",JSON);
            
          [self parseData:JSON];
            isLoading=NO;
            
           
            
            [self.candTableView reloadData];
            
            
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    [self setTitle:self.title];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
        APMContributionsModel *contributionsModel=[self.contributionsResults objectAtIndex:indexPath.row];
        
        cell.donorDetailNameLabel.text=contributionsModel.contributorName;
        cell.donorDetailDateLabel.text=contributionsModel.contributionDate;
        cell.donorDetailAmountLabel.text=[NSString stringWithFormat:@"$ %@",contributionsModel.contributionAmount];
        //cell.donorDetailImage.image=[UIImage imageNamed:@"men"];
        
        [cell.donorDetailImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlImage,contributionsModel.image]] placeholderImage:[UIImage imageNamed:@"men"]];

      
    
    
    return cell;
        
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
    
    
    
    headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"call_grey_bar"]];
    
    /*
     UIImage *image = [UIImage imageNamed:@"encabezadoMenu.png"];
     
     UIImageView *headerImage = [[UIImageView alloc] initWithImage: image];
     
     [headerView addSubview:headerImage];*/
    
    UILabel *menuText=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, 240, 30)];
    menuText.backgroundColor=[UIColor clearColor];
    menuText.text=@"Last Donations";
    
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
    
    NSUserDefaults *phoneCall=[NSUserDefaults standardUserDefaults];
    
    NSString *phoneDial=[phoneCall objectForKey:@"phone"];
    
   // NSString *codeNumber=[NSString stringWithFormat:@"+1%@",phoneDial];
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    [phone connect:phoneDial];
    
    NSLog(@"phonetest %@",phoneDial);

    
    APMCallHelpViewController *callVC=[[APMCallHelpViewController alloc]init];
    
    callVC.delegate=self;
    
    [self presentViewController:callVC animated:NO completion:nil];
    
    callVC.callLabel.text=[NSString stringWithFormat:@"Calling    %@",self.detailModel.name];
    
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

- (IBAction)emailButton:(id)sender {
    
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
        
        
    }
    

}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

#pragma mark CallHelpDelegate

-(void)CallHelpDidDismiss:(APMCallHelpViewController *)controller{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    APMCallOutComeViewController *callOut=[[APMCallOutComeViewController alloc]init];
    
    callOut.detailModel=self.detailModel;
    
    [self.navigationController pushViewController:callOut animated:YES];
    
    
}


@end
