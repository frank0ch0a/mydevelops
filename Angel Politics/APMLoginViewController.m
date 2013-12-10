//
//  APMLoginViewController.m
//  Angel Politics
//
//  Created by Francisco on 26/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMLoginViewController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"
#import "APMAppDelegate.h"

@interface APMLoginViewController (){
    CGFloat loginy;
}

@end

@implementation APMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIColor *color = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIColor *color2 = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color2}];
    
    UIImage *imageButton=[[UIImage imageNamed:@"btn_login_up"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.loginButtonOutlet setBackgroundImage:imageButton forState:UIControlStateNormal];
    self.loginButtonOutlet.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15.0];
    
    UIImage *imageButton2=[[UIImage imageNamed:@"btnFacebook"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.btnFacebook setBackgroundImage:imageButton2 forState:UIControlStateNormal];
    self.btnFacebook.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15.0];
    
    loginy=self.loginUIView.frame.origin.y;
    
  
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create instance keyChain
    
   self.keyChain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    if ([_keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
         self.emailTextField.text= [_keyChain objectForKey:(__bridge id)kSecAttrAccount];
    }
    
   

    
    
    /*    [self.passwordTextField setText:[self.keyChain objectForKey:(__bridge id)kSecValueData]];
    NSLog(@"password: %@", [self.passwordTextField text]);*/
    
    self.emailTextField.delegate=self;
    self.passwordTextField.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailLogin = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailLogin];
    return [emailTest evaluateWithObject:emailStr];
}


#pragma mark -UITexfield Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
    if (textField==self.emailTextField || textField==self.passwordTextField) {
        
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                
                                
                                self.loginUIView.frame=CGRectMake(0, -150, self.loginUIView.frame.size.width, self.loginUIView.frame.size.height);
                                self.emailLine.backgroundColor=[UIColor whiteColor];
                                self.emailLine.alpha=0.6f;
                                self.passLine.backgroundColor=[UIColor whiteColor];
                                self.passLine.alpha=0.6f;
                                
                                
                            } completion:nil];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.loginUIView.frame=CGRectMake(0,loginy , self.loginUIView.frame.size.width, self.loginUIView.frame.size.height);
                            
                            
                            
                        } completion:nil];
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.emailLine.backgroundColor=[UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    self.passLine.backgroundColor=[UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];

    
    return YES;
    
}

-(void)dissmissModelView:(NSString *)text{
    
 
    
    //raise notification about dismiss
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MODELVIEW DISMISS" object:text];
    
}

-(void)loginSuccess{
    
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.loginUIView.frame=CGRectMake(0,loginy , self.loginUIView.frame.size.width, self.loginUIView.frame.size.height);
                            
                            
                            
                        } completion:nil];
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    self.emailLine.backgroundColor=[UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    self.passLine.backgroundColor=[UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    
    NSLog(@"Login Success");
    
     [_keyChain resetKeychainItem];
    
    // Store username to keychain
    if (self.emailTextField.text){
        NSLog(@"email text %@",self.emailTextField.text);
        
        [self.keyChain setObject:self.emailTextField.text forKey:(__bridge id)kSecAttrAccount];}
    
    // Store password to keychain
    if (self.passwordTextField.text){
        
        NSLog(@"pass text %@",self.passwordTextField.text);
        [self.keyChain setObject:self.passwordTextField.text forKey:(__bridge id)(kSecValueData)];}
    
    
    
    
    [self.delegate dissmissLoginController:self];
    
    
    [self dissmissModelView:@"YES"];
    
    
    
}

- (IBAction)loginButton:(id)sender {
    
    if(self.emailTextField.text.length==0 || [self.emailTextField.text isEqualToString:@""]){
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"The email field can not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }else{
        
        if(self.passwordTextField.text.length==0 ||[self.passwordTextField.text isEqualToString:@""]){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"The password field can not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
            
        }else{
            if(![self validateEmail:[self.emailTextField text]]) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"incorrect email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }else{
                
               
                
                [SVProgressHUD show];

                
                
                NSDictionary *dict=@{@"email":self.emailTextField.text ,@"pass":self.passwordTextField.text};
                
                NSLog(@"Parameters login %@",dict);
                  
                AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
                
                [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
                [httpClient setParameterEncoding:AFFormURLParameterEncoding];
                NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                                        path:@"/mobile/login.php"
                                                                  parameters:dict
                                                ];
                
                AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    
                    if (JSON !=nil) {
                        
                        //NSLog(@"Result %@",JSON);
                        
                        [SVProgressHUD dismiss];
                        
                        [self loginSuccess];
                        
                        
                    }else{
                        
                        [SVProgressHUD dismiss];
                        
                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Unregistered User" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alertView show];

                        
                       // NSLog(@"Usuario no registrado");
                        
                    }
                    
                    
                    
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    NSLog(@"error %@", [error description]);
                    
                }];
                [operation start];                [operation start];
                
                operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];

                            [operation start];
                
              
                

                
            }
            
                      
    

        }
        
        
    }
  
}


- (IBAction)btnFacebookPress:(id)sender {
    
    APMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The person using the app has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The person has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
