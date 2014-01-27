//
//  APMCallViewController.m
//  Angel Politics
//
//  Created by Francisco on 28/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMCallViewController.h"
#import "APMAppDelegate.h"
#import "APMPhone.h"
#import "APMCallOutComeViewController.h"
#import  "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "SVProgressHUD.h"

@interface APMCallViewController (){
    
    NSOperationQueue *queue;
    
    CGFloat ypledge;
}


@end

@implementation APMCallViewController

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
    
    self.callAmountTextField.delegate=self;
    self.emailCallTextField.delegate=self;
    self.psCallTextField.delegate=self;
    self.detailsCallTextField.delegate=self;
    
    NSLog(@"candid %@ y donorid %@ call view",self.candID,self.donorID);
    
   
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //Hacemos Diseño a la vista pop
    /*
    self.callingUIView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.callingUIView.layer.borderWidth=3.0f;
    self.callingUIView.layer.cornerRadius=10.0f;*/
    
    UIImage *imageButton=[[UIImage imageNamed:@"btn_login_up"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.callPledgeButton setBackgroundImage:imageButton forState:UIControlStateNormal];
    
    ypledge=self.callingUIView.frame.origin.y;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeCallVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    APMCallOutComeViewController *callOut=[[APMCallOutComeViewController alloc]init];
    
    [self.navigationController pushViewController:callOut animated:YES];
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.callingUIView.frame=CGRectMake(self.callingUIView.frame.origin.x, ypledge, self.callingUIView.frame.size.width, self.callingUIView.frame.size.height);
                            
                            
                            self.closeButtonOutlet.hidden=NO;
                        } completion:nil];
    
    
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField==self.callAmountTextField) {
        [UIView animateWithDuration:0.25 delay:0
                            options:UIViewAnimationOptionCurveEaseOut animations:^{
                                
                                
                                self.callingUIView.frame=CGRectMake(self.callingUIView.frame.origin.x, -40, self.callingUIView.frame.size.width, self.callingUIView.frame.size.height);
                                
                                self.closeButtonOutlet.hidden=YES;
                                
                            } completion:nil];
        

    }else if(textField== self.psCallTextField) {
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.callingUIView.frame=CGRectMake(self.callingUIView.frame.origin.x, -120, self.callingUIView.frame.size.width, self.callingUIView.frame.size.height);
                            
                            self.closeButtonOutlet.hidden=YES;
                            
                        } completion:nil];

    
    
    }
    
}

- (IBAction)callPledgeButtonAct:(id)sender {
    
    
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            
                            self.callingUIView.frame=CGRectMake(self.callingUIView.frame.origin.x, ypledge, self.callingUIView.frame.size.width, self.callingUIView.frame.size.height);
                            
                            
                            
                        } completion:nil];
    
    if ([self.emailCallTextField.text length]>0 || [self.callAmountTextField.text length]>0) {
        
    
    [SVProgressHUD show];
        
        NSDictionary *dict;
        
        if (self.candID !=nil && self.donorID !=nil) {
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Check"] ){
                NSUserDefaults *email=[NSUserDefaults standardUserDefaults];
                
                NSString *emailString=[email objectForKey:@"email"];
                
                dict=@{@"email":emailString ,@"candid":self.candID,@"donorid":self.donorID,@"pledge":self.callAmountTextField.text,@"ps":self.psCallTextField};
                
            }else{
                
                dict=@{@"email":self.emailCallTextField.text ,@"candid":self.candID,@"donorid":self.donorID,@"pledge":self.callAmountTextField.text,@"ps":self.psCallTextField};
            }
            
        }
    
   
    
    NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/outcome.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if (JSON !=nil) {
            
            [SVProgressHUD dismiss];
            
            if ([[JSON objectForKey:@"a"]isEqualToString:@"Ok"]) {
                
                // [self dismissViewControllerAnimated:YES completion:nil];
                
                
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Notification" message:@"Data received sucessfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                [self.delegate CallViewDidDismiss:self];
                
                NSLog(@"Resulta JSON MenuVC %@",JSON);
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
        
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Email field or Amount can not be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        
        
        
    }
    
    
}
@end
