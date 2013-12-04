//
//  APMAddLeadsViewController.m
//  Angel Politics
//
//  Created by Francisco on 25/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMAddLeadsViewController.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "KeychainItemWrapper.h"

@interface APMAddLeadsViewController (){
    
    CGFloat yAddView;
    NSOperationQueue *queue;
    
}

@property(nonatomic,strong)KeychainItemWrapper *keychain;
@property(nonatomic,strong)NSString* email;
@property(nonatomic,strong)NSString* pass;


@end

@implementation APMAddLeadsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        queue=[[NSOperationQueue alloc]init];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *imageButton=[[UIImage imageNamed:@"btn_login_up"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.saveLeadButton setBackgroundImage:imageButton forState:UIControlStateNormal];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    yAddView=self.addLeadsUIView.frame.origin.y;
    
    self.leadsDetailTextField.delegate=self;
    self.leadsNameTextField.delegate=self;
    self.leadsLastNTextField.delegate=self;
    self.leadsEmailTextField.delegate=self;
    self.leadsAskTextField.delegate=self;
    self.leadsZipTextFiels.delegate=self;
    self.leadsPhone.delegate=self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAddLeadVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TextField Delegate


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if (textField==self.leadsDetailTextField || textField==self.leadsAskTextField) {
        
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.addLeadsUIView.frame=CGRectMake(self.addLeadsUIView.frame.origin.x
                                                 , -170, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
            
        } completion:nil];
        
        
    }
    
    
    
    
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.addLeadsUIView.frame=CGRectMake(self.addLeadsUIView.frame.origin.x
                                                 , yAddView, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
            
            [textField resignFirstResponder];
            
        } completion:nil];
        
    }
    
    return YES;
    
    
}


- (IBAction)saveLeads:(id)sender {
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.addLeadsUIView.frame=CGRectMake(self.addLeadsUIView.frame.origin.x
                                                                 , yAddView, self.addLeadsUIView.frame.size.width, self.addLeadsUIView.frame.size.height);
                            
                            
                            
                        } completion:nil];
    
    
    [self.leadsAskTextField resignFirstResponder];
    [self.leadsEmailTextField resignFirstResponder];
    [self.leadsAskTextField resignFirstResponder];
    [self.leadsDetailTextField resignFirstResponder];
    [self.leadsZipTextFiels resignFirstResponder];
    
    if ([self.leadsNameTextField.text length]>0 || [self.leadsLastNTextField.text length]>0 || [self.leadsEmailTextField.text length]>0 || [self.leadsPhone.text length ]>0 || [self.leadsZipTextFiels.text length ]>0) {
        
        self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
        
        if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
            
            self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
            self.pass=[self.keychain objectForKey:(__bridge id)kSecValueData];
            
        }
        
        
        [SVProgressHUD show];
        
        NSDictionary *dict=@{@"email":self.email,@"pass":self.pass,@"zipcode":self.leadsZipTextFiels.text,@"firstname":self.leadsNameTextField.text,@"lastname":self.leadsLastNTextField.text,@"phone":self.leadsPhone.text,@"details":self.leadsDetailTextField.text,@"inboxmail":self.leadsEmailTextField.text,@"ask":self.leadsAskTextField.text};
        
        NSLog(@"Parameters %@",dict);
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
        
        [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                path:@"/mobile/addmyleads.php"
                                                          parameters:dict
                                        ];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            if (JSON !=nil) {
                
                [SVProgressHUD dismiss];
                
                if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                    
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"Leads add succesfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                    [self.delegate dismissController:self];

                    
                    NSLog(@"Resulta AddLeads %@",JSON);
                }
                
                
                
                
                
            }else{
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Data do not send try again, please" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                
                
            }
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"error %@", [error description]);
            
        }];
        
        operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
        
        
        
        
        [queue addOperation:operation];
        
        
    }else{
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Any field required can not be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        
        
        
    }

    
}
@end
