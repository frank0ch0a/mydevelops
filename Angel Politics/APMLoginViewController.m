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
#import "APMFrontViewController.h"

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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        
        // Move the view down 20 pixels
        CGRect bounds = self.view.bounds;
         bounds.origin.y -= 20.0;
        [self.view setBounds:bounds];
        
        
        
        // Create a solid color background for the status bar
        CGRect statusFrame = CGRectMake(0,bounds.origin.y, bounds.size.width, 20);
       UIView *statusBar = [[UIView alloc] initWithFrame:statusFrame];
        statusBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_login"]];
        [self.view addSubview:statusBar];
        
        
        
    }
    
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        
        self.scrollUIView.frame=CGRectMake(0, 254, 320, 206);
        self.tryTourUIView.frame=CGRectMake(0, 254, 320, 38);
        self.takeTourBtn.frame=CGRectMake(44, 400, 232, 39);
        self.pageControl.frame=CGRectMake(self.pageControl.frame.origin.x, 357, self.pageControl.frame.size.width, self.pageControl.frame.size.height);
        self.emailTextField.frame=CGRectMake(self.emailTextField.frame.origin.x
                                             , 100, self.emailTextField.frame.size.width, self.emailTextField.frame.size.height);
        self.emailLine.frame=CGRectMake(self.emailLine.frame.origin.x
                                        , 127, self.emailLine.frame.size.width, self.emailLine.frame.size.height);
        self.passwordTextField.frame=CGRectMake(self.passwordTextField.frame.origin.x
                                          , 160, self.passwordTextField.frame.size.width, self.passwordTextField.frame.size.height);
        self.passLine.frame=CGRectMake(self.passLine.frame.origin.x
                                                , 188, self.passLine.frame.size.width, self.passLine.frame.size.height);
        self.loginButtonOutlet.frame=CGRectMake(self.loginButtonOutlet.frame.origin.x
                                                , 208, self.loginButtonOutlet.frame.size.width,self.loginButtonOutlet.frame.size.height);
        
        
        
    }
    
    UIColor *color = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIColor *color2 = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color2}];
    
    UIImage *imageButton=[[UIImage imageNamed:@"btn_login_up"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    UIImage *btnTourimagen=[[UIImage imageNamed:@"bgBtnTour"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
   
    
    
    [self.loginButtonOutlet setBackgroundImage:imageButton forState:UIControlStateNormal];
   
    
    [self.takeTourBtn setBackgroundImage:btnTourimagen forState:UIControlStateNormal];
    
  
    self.loginButtonOutlet.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15.0];
    
    UIImage *imageButton2=[[UIImage imageNamed:@"btnFacebook"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.btnFacebook setBackgroundImage:imageButton2 forState:UIControlStateNormal];
    self.btnFacebook.titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15.0];
    
    loginy=self.loginUIView.frame.origin.y;
    
  
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Optimizing iOS 7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        
        // Move the view down 20 pixels
        CGRect bounds = self.view.bounds;
        bounds.origin.y -= 20.0;
        [self.view setBounds:bounds];
        
        
        /*
        // Create a solid color background for the status bar
        CGRect statusFrame = CGRectMake(0.0,ySearch, bounds.size.width, 20);
        statusBar = [[UIView alloc] initWithFrame:statusFrame];
        statusBar.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0 alpha:1.0];
        [self.view addSubview:statusBar];*/
        
        
        
    }
    // Create instance keyChain
    
    
   self.keyChain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    if ([_keyChain objectForKey:(__bridge id)kSecAttrAccount]!=nil) {
         self.emailTextField.text= [_keyChain objectForKey:(__bridge id)kSecAttrAccount];
    }
    /*
    
    // Remember user
    if ([_keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
        self.emailTextField.text= [_keyChain objectForKey:(__bridge id)kSecAttrAccount];
    }*/
    
    //Remeber user provisional
    
    NSUserDefaults *usrLog=[NSUserDefaults standardUserDefaults];
    
    NSString *usrLogin=[usrLog objectForKey:@"usrLogin"];
    
    self.emailTextField.text=usrLogin;
    
    
    
    /*    [self.passwordTextField setText:[self.keyChain objectForKey:(__bridge id)kSecValueData]];
    NSLog(@"password: %@", [self.passwordTextField text]);*/
    
    self.emailTextField.delegate=self;
    self.passwordTextField.delegate=self;
    
    
    [self scrollerLogin];

}

-(void)scrollerLogin
{
    const int NumPages =3;
    self.scrollView.contentSize = CGSizeMake(NumPages * self.view.frame.size.width, 200);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate=self;
    
    
    for (int i = 0; i < NumPages; i++) {
        
        /*
         
         NSString *imageName = [NSString stringWithFormat:@"home-%d.png", i + 1];
         UIImage *image = [UIImage imageNamed:imageName];
         UIImageView *imageView = [[UIImageView alloc] initWithImage:image];*/
        
        //Create images
        
        NSString *nombreimagen=[NSString stringWithFormat:@"bg_login%d", i + 1];
        UIImage *image = [UIImage imageNamed:nombreimagen];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        //Create labels with messages in scrolling images
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 30, 290, 90)];
        
        label.backgroundColor=[UIColor clearColor];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont fontWithName:@"Helvetica75" size:12.0]];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.numberOfLines=0;
        
        if ([nombreimagen isEqualToString:@"bg_login1"]) {
            
            NSMutableString *LabelString = [NSMutableString string];
            [LabelString appendString:@"Import contacts from your address book, find the \n\n"];
            [LabelString appendString:@"most likely prospective donors, know how much\n\n"];
            
            [LabelString appendString:@"to ask them for, when and how often .\n\n"];
            
            
            label.text=LabelString;
            
        }else if ([nombreimagen isEqualToString:@"bg_login2"]){
            
            
            NSMutableString *LabelString = [NSMutableString string];
            [LabelString appendString:@"Learn the best tips to make a \n\n"];
            [LabelString appendString:@"successful pitch .\n\n"];
            label.text=LabelString;
            
        }else{
            
            
            NSMutableString *LabelString = [NSMutableString string];
            [LabelString appendString:@"Make a pitch test to receive a professional \n\n"];
            [LabelString appendString:@"feedback before you go for real .\n\n"];
            label.text=LabelString;        }
        
        
        
        /*
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            
            imageView.frame=CGRectMake(0, 0, 320,548);
            
        }else{
            
            imageView.frame=CGRectMake(0, 0, 320,450);
        }*/
        
        CGRect frame = imageView.frame;
        //Hint close images horinzotally distance
        frame.origin.x = i * self.view.frame.size.width/1.0f;
        imageView.frame = frame;
        
        
        [imageView addSubview:label];
        [self.scrollView addSubview:imageView];
        
        
        
        
    }
    
    self.pageControl.numberOfPages=NumPages;
    self.pageControl.currentPage=0;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    
    // Calculating the page index.
    int page = floor(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
    
    // Set the page index as the current page to the page control.
    [self.pageControl setCurrentPage:page];
    
}
- (IBAction)changePage {
    // Get the index of the page.
    int pageIndex = [self.pageControl currentPage];
    
    // We need to move the scroll to the correct page.
    // Get the scroll's frame.
    CGRect newFrame = [self.scrollView frame];
    
    // Calculate the x-coordinate of the frame where the scroll should go to.
    newFrame.origin.x = newFrame.size.width * pageIndex;
    
    // Scroll the frame we specified above.
    [self.scrollView scrollRectToVisible:newFrame animated:YES];
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
                                
                                self.scrollUIView.hidden=YES;
                                self.tryTourUIView.hidden=YES;
                                /*
                                self.loginUIView.frame=CGRectMake(0, -100, self.loginUIView.frame.size.width, self.loginUIView.frame.size.height);*/
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
                            
                            /*
                            self.loginUIView.frame=CGRectMake(0,loginy , self.loginUIView.frame.size.width, self.loginUIView.frame.size.height);*/
                            
                            self.scrollUIView.hidden=NO;
                            self.tryTourUIView.hidden=NO;
                            
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
                            
                            self.scrollUIView.hidden=NO;
                            self.tryTourUIView.hidden=NO;
                            
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

-(void)dismissLoginTour:(BOOL)isTour{
    
    
    //raise notification about dismiss
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MODELVIEW TOUR" object:[NSNumber numberWithBool:isTour]];
    
    
    
    
}
- (IBAction)takeTour:(id)sender {
    
    
    if ([_keyChain objectForKey:(__bridge id)kSecAttrAccount]==nil ||[self.keyChain objectForKey:(__bridge id)kSecValueData]==nil ) {
    
    [self.delegate dissmissLoginController:self];
    
     [self dissmissModelView:@"YES"];
   
  
    
    }
    
    
}

@end
