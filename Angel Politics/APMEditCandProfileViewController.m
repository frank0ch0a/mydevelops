//
//  APMEditCandProfileViewController.m
//  Angel Politics
//
//  Created by Francisco on 7/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMEditCandProfileViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "KeychainItemWrapper.h"
#import "NVSlideMenuController.h"
#import "TestFlight.h"

@interface APMEditCandProfileViewController (){
    
    
    
}

@property(strong,nonatomic)KeychainItemWrapper *keychain;
@property(copy,nonatomic)NSString *email;
@property(nonatomic,copy)NSString *password;
// Lazy buttons
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;

@end

@implementation APMEditCandProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
     [self updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:NO];
    
    
    NSUserDefaults *phoneCall=[NSUserDefaults standardUserDefaults];
    
   NSString *phoneDial=[phoneCall objectForKey:@"phone"];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Check" ] && phoneDial !=nil ){
        
        
        [_checkBoxButton1 setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        
        self.editPhone1.text=phoneDial;

        
        
    }
    //NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
    // NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
    
    
    
    
   self.editCandidateName.delegate=self;
    
    self.editPhone1.delegate=self;
   self.editPhone2.delegate=self;
   self.editPhone3.delegate=self;
    
    

    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title=@"Demo";
    
    
    
    
}
#pragma mark - Lazy buttons

- (UIImage *)listImage {
    return [UIImage imageNamed:@"ic_menu"];
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
        
        
	}
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkButton1:(id)sender {
    
    if (!checked) {
        [_checkBoxButton1 setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checked = YES;
        active=@"1";
    }
    
    else if (checked) {
        [_checkBoxButton1 setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
    
    
    
    
}
- (IBAction)checkButton2:(id)sender {
    
    if (!checked) {
        [_checkBoxButton2 setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checked = YES;
        active=@"2";
    }
    
    else if (checked) {
        [_checkBoxButton2 setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}

- (IBAction)checkButton3:(id)sender {
    
    if (!checked) {
        [_checkBoxButton3 setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        checked = YES;
        active=@"3";
    }
    
    else if (checked) {
        [_checkBoxButton3 setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}

- (IBAction)saveButton:(id)sender {
    
    if (checked) {
        
        NSUserDefaults *phone=[NSUserDefaults standardUserDefaults];
        [phone setObject:self.editPhone1.text forKey:@"phone"];
        [phone  synchronize];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Check"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [TestFlight passCheckpoint:@"Save new Number"];
        
        
    }else{
        
        NSUserDefaults *phone=[NSUserDefaults standardUserDefaults];
        [phone removeObjectForKey:@"phone"];
        [phone  synchronize];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Check"];
        
        
    }
    
    [self.editPhone1 resignFirstResponder];
   
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Saved" message:@"Changes Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertView show];
    
    [self viewDidLoad];
    
    /*
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
      

        
        
    
        if (active ==nil && !checked) {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Check can not be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertview show];
        }else{
    
NSDictionary *dict=@{@"email":self.email ,@"pass":self.password,@"selphone":active,@"phone":self.editPhone1.text,@"phone2":self.editPhone2.text,@"phone3":self.editPhone3.text,@"ext":@"0",@"ext2":@"0",@"ext3":@"0"};
                             
    
    NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/editphones"
                                                      parameters:dict];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
        
        if (JSON !=nil) {
            
            NSLog(@"Resulta JSON phones %@",JSON);
            
           
        
            
            
            
            
        }else{
            
            
            
            
            NSLog(@"Usuario no registrado");
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
        [operation start];

    
       [self.delegate configEditDidUpdate:self];
    
        }
    }*/
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
    
    
}
- (IBAction)closeEdit:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
