//
//  APMTourTipsViewController.m
//  AngelPolitics
//
//  Created by Francisco on 22/01/14.
//  Copyright (c) 2014 angelpolitics. All rights reserved.
//

#import "APMTourTipsViewController.h"
#import "APMAppDelegate.h"
#import "APMPhone.h"
#import "APMFrontViewController.h"


@interface APMTourTipsViewController ()

@end

@implementation APMTourTipsViewController{
    
    NSUInteger tip;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    UIImage *btnTip=[[UIImage imageNamed:@"bg_Ntip_Btn"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    
    
    [self.nextipButton setBackgroundImage:btnTip forState:UIControlStateNormal];
    
    UIImage *btnTestCall=[[UIImage imageNamed:@"bg_tCall_Btn"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    

    [self.testCallButton setBackgroundImage:btnTestCall forState:UIControlStateNormal];
 
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tip=0;
    
       NSMutableString *LabelString = [NSMutableString string];
    
    [LabelString appendFormat:@"1. Start your introduction with your full name \n"];
    [LabelString appendFormat:@"and your previous (or current) role in the \n"];
    [LabelString appendFormat: @"community (before you decide to run \n"];
    [LabelString appendFormat: @"for office)."];
    
    self.tipLabel.text=LabelString;
    
      NSMutableString *LabelString2 = [NSMutableString string];
    
    [LabelString2 appendFormat:@"Ex: “Hello, Martha, my name is John Bezos, I  \n"];
    [LabelString2 appendFormat:@"a own the bakery on Main St & Mulberry rd. since \n"];
    [LabelString2 appendFormat: @"998 How are you doing? \n"];
    
    
    self.exampleLabel.text=LabelString2;

    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextTip:(id)sender {
    
    if (tip==2) {
        tip=0;
    }else{
        tip++;
    }
    
   
    
     NSMutableString *LabelString = [NSMutableString string];
    
    NSMutableString *LabelString2 = [NSMutableString string];

    
    
    switch (tip) {
        case 0:
            
            [LabelString appendFormat:@"1. Start your introduction with your full name and your previous (or current) role in the community (before you decide to run for office)."];
           
            
            self.tipLabel.text=LabelString;
            
            [LabelString2 appendFormat:@"Ex: “Hello, Martha, my name is John Bezos, I  own the bakery on Main St & Mulberry rd. since a 998 How are you doing?“"];
           
            
            
            self.exampleLabel.text=LabelString2;
          
            
            break;
            
        case 1:
            
            [LabelString appendFormat:@"2. Share the reason for your call and the two most pressing issues that you are going to address as the next office holder. Note: Speak with certainty as to what you are going to do once in office."];
        
          
            self.tipLabel.text=LabelString;
            
            [LabelString2 appendFormat:@"Ex: “I am reaching out to you because I decided to take a more active role in nour community and run for city council and I would like the opportunity to share with you and other leading members of the community  the two things that will focus on as the next council member of our district.“"];
           
            
            
            self.exampleLabel.text=LabelString2;

            
            break;
            
        case 2:
            
            [LabelString appendFormat:@"3. Briefly share the  landscape of the campaign (do not mention the names of the contenders) and ask for their financial support with a specific sum and what the contribution will enable you to do in your campaign."];
            
            
            self.tipLabel.text=LabelString;
            
            [LabelString2 appendFormat:@"Ex: “Martha, this campaign is a 3 way race and it is not going to be an easy race but with your support all the people that we need to reach, that is why I would like to count on your support today. Can I count on your support of $100?”"];
            
            self.exampleLabel.text=LabelString2;
            
            break;
            
        default:
            break;
    }
    
}

- (IBAction)testCall:(id)sender {
    
    NSString *phoneDial=@"9143253307";
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    [phone connect:phoneDial];
    
    APMCallHelpViewController *callVC=[[APMCallHelpViewController alloc]init];
    
  
    
    [self presentViewController:callVC animated:NO completion:nil];
    /*
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];*/
    callVC.callLabel.hidden=YES;
    callVC.delegate=self;
    
    callVC.askTitle.hidden=YES;
    callVC.highTitleLabel.hidden=YES;
}

-(void)CallHelpDidDismiss:(APMCallHelpViewController *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    APMFrontViewController *frontVC=[[APMFrontViewController alloc]init];
    
     [self.navigationController pushViewController:frontVC animated:YES];
}


- (IBAction)closeTip:(id)sender {
    
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
