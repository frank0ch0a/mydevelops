//
//  APMEditProfileViewController.m
//  Angel Politics
//
//  Created by Francisco on 6/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMEditProfileViewController.h"
#import "APMPhone.h"
#import "APMAppDelegate.h"
#import "KeychainItemWrapper.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NVSlideMenuController.h"
#import "APMGetPhoneModel.h"
#import "SVProgressHUD.h"
#import "APMEditCandProfileViewController.h"
#import "APMPhone.h"
#import "APMAppDelegate.h"
@interface APMEditProfileViewController (){
    
    NSOperationQueue *queue;
    NSString *numbertoDial;
    
    
}

@property(strong,nonatomic)KeychainItemWrapper *keychain;
@property(copy,nonatomic)NSString *email;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,strong)NSMutableArray *profileResults;
// Lazy buttons
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@property(strong,nonatomic)APMGetPhoneModel *phoneModel;


@end

@implementation APMEditProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        queue=[[NSOperationQueue alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    
    
    //NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
    // NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
    
    [self updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:NO];
    
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        
        [self downloadCandidateData];
        
    }

    [SVProgressHUD show];
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

- (void)updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:(BOOL)animated
{
    if (self.slideMenuController.slideDirection == NVSlideMenuControllerSlideFromLeftToRight)
	{
		[self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:animated];
        [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:animated];
        
	}
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.title=@"Edit Profile";
    
    
}


-(APMGetPhoneModel *)parseData:(NSDictionary *)dictionary{
    
    APMGetPhoneModel *getPhoneModel=[[APMGetPhoneModel alloc]init];
    
    
    getPhoneModel.phoneOne=[dictionary objectForKey:@"a"];
    getPhoneModel.phoneTwo=[dictionary objectForKey:@"b"];
    getPhoneModel.phoneThree=[dictionary objectForKey:@"c"];
    getPhoneModel.activePhone=[dictionary objectForKey:@"d"];
    
    
    
    
    return getPhoneModel;
    
    
    
    
    
    
}

-(void)parseArray:(NSArray *)array{
    
    
    
    if (array==nil) {
       // NSLog(@"Expected 'results' array");
        
        return;
    }
    self.profileResults=[[NSMutableArray alloc]init];
    
    for (NSDictionary *resultDict in array) {
        
        
        
        self.phoneModel=[self parseData:resultDict];
        
        if(self.phoneModel!=nil){
            
            [self.profileResults addObject:self.phoneModel];
            
            NSUserDefaults *candName= [NSUserDefaults standardUserDefaults];
            
            NSString *sign=[candName objectForKey:@"nombreCandidato"];
            
            self.nameProfileLabel.text=sign;
            self.phone1Label.text=self.phoneModel.phoneOne;
            self.phone2Label.text=self.phoneModel.phoneTwo;
            self.phone3Label.text=self.phoneModel.phoneThree;

            switch ([self.phoneModel.activePhone integerValue]) {
                case 1:
                    numbertoDial=self.phoneModel.phoneOne;
                    self.phone1Label.text=[NSString stringWithFormat:@"%@ (Act)",self.phoneModel.phoneOne];
                    
                    break;
                    
                case 2:
                    numbertoDial=self.phoneModel.phoneTwo;
                    self.phone2Label.text=[NSString stringWithFormat:@"%@ (Act)",self.phoneModel.phoneTwo];
                    
                    break;
                case 3:
                    numbertoDial=self.phoneModel.phoneThree;
                    self.phone3Label.text=[NSString stringWithFormat:@"%@ (Act)",self.phoneModel.phoneThree];
                    
                    break;
                    
                default:
                    break;
            }
            
            
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
                                                            path:@"/mobile/getphones.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
            NSLog(@"Resulta JSON phones %@",JSON);
            
            [self parseArray:JSON];
            [SVProgressHUD dismiss];
            
            
            
            
            
        }else{
            
            
            
            
            NSLog(@"Usuario no registrado");
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    [queue addOperation:operation];

    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editCandprofile:(id)sender {
    
    APMEditCandProfileViewController *editCanVC=[[APMEditCandProfileViewController alloc]init];
    editCanVC.delegate=self;
    
    
    
    [self presentViewController:editCanVC animated:YES completion:nil];
    /*
    editCanVC.editPhone1.text=self.phoneModel.phoneOne;
    editCanVC.editPhone2.text=self.phoneModel.phoneTwo;
    editCanVC.editPhone3.text=self.phoneModel.phoneThree;*/
    
    NSUserDefaults *phone=[NSUserDefaults standardUserDefaults];
    [phone removeObjectForKey:@"phone"];
    [phone  synchronize];

    
    
}

- (IBAction)dialButton:(id)sender {
    
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    NSString *dialNumber=[NSString stringWithFormat:@"+1%@",numbertoDial];
    [phone connect:numbertoDial];
    
    NSLog(@"numero activo %@",dialNumber);
    
}

- (IBAction)hangUpButton:(id)sender {
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    
    [phone disconnect];
    
}

-(void)configEditDidUpdate:(APMEditCandProfileViewController *)controller{
    
    [self viewDidLoad];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}
@end
