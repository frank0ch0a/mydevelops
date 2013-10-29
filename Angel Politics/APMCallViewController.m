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

@interface APMCallViewController ()

@end

@implementation APMCallViewController

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
    
    self.numberTextField.delegate=self;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //Hacemos Diseño a la vista pop
    self.callingUIView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.callingUIView.layer.borderWidth=3.0f;
    self.callingUIView.layer.cornerRadius=10.0f;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DialButton:(id)sender {
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    [phone connect:self.numberTextField.text];
    
    [self.numberTextField resignFirstResponder];
}

- (IBAction)hangUpButton:(id)sender {
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    
    [phone disconnect];
    
    [self.numberTextField resignFirstResponder];
    
    
}
- (IBAction)closeCallVC:(id)sender {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    APMCallOutComeViewController *callOut=[[APMCallOutComeViewController alloc]init];
    
    [self.navigationController pushViewController:callOut animated:YES];
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.numberTextField resignFirstResponder];
    
    
    return YES;
    
}
@end
