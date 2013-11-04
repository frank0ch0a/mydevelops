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

@end

@implementation APMCandidateViewController


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
    
    
    self.lastDonations=@[@"Michele Stuart",@"Charles Stanton",@"Megan Surrell"];
    self.amounts=@[@"$ 1,600",@"$ 800",@"$ 500"];
    
    if (self.leadsModel.donor_id !=nil &&[_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
        
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        [self loadData];
        
        [SVProgressHUD show];
    }
    
}

-(APMDetailModel *)parseDataResult:(NSDictionary *)dictionary{
    
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
    
    
    return self.detailModel;
    
}
-(void)parseData:(NSDictionary *)dictionary{
    
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    [array addObject:dictionary];
    
    
    
    self.detailsResults=[[NSMutableArray alloc]init];
    
    for (NSDictionary *resultDict in array) {
        
        self.detailModel=[[APMDetailModel alloc]init];
        
        self.detailModel=[self parseDataResult:resultDict];
        
        
        
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
            
            NSLog(@"results %@",self.detailsResults);
            
        }
        
        
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
            
            [SVProgressHUD dismiss];
            
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
    
    // Return the number of rows in the section.
    return self.lastDonations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdent=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdent];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (cell==nil) {
        
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdent];
            
            
        }
    
    cell.textLabel.text=[self.lastDonations objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[self.amounts objectAtIndex:indexPath.row];
    
    cell.imageView.image=[UIImage imageNamed:@"men"];
    
    
    return cell;
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
    
    
   
    
    APMCallOutComeViewController *callOut=[[APMCallOutComeViewController alloc]init];
    
    callOut.detailModel=self.detailModel;
    
    [self.navigationController pushViewController:callOut animated:YES];
    
    
    
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
@end
