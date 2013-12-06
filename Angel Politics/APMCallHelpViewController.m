//
//  APMCallHelpViewController.m
//  Angel Politics
//
//  Created by Francisco on 6/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMCallHelpViewController.h"
#import "APMAppDelegate.h"
#import "APMPhone.h"

@interface APMCallHelpViewController (){
    
    BOOL isSpeaker;
    BOOL isMuted;
    
}
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;

@end

@implementation APMCallHelpViewController

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
    
    
    
    
    UIImage *imageButton=[[UIImage imageNamed:@"fondoBotonBorrar"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    
    [self.hangupButton setBackgroundImage:imageButton forState:UIControlStateNormal];

}
- (IBAction)phoneDisconnect:(id)sender {
    
    APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
    APMPhone* phone = appDelegate.phone;
    
    [phone disconnect];
    
    [UIView animateWithDuration:1.5f delay:0.8f options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.hangupButton.frame=CGRectMake(self.hangupButton.frame.origin.x, 700, self.hangupButton.frame.size.width, self.hangupButton.frame.size.height);
        
        self.speakerButton.hidden=YES;
        
    } completion:^(BOOL finished) {
        
       
        
        [self.delegate CallHelpDidDismiss:self];
        
        [self dismissViewControllerAnimated:NO completion:nil];

    }];
    
  
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)speakerPress:(id)sender {
    
    
    
 
    
    if (!isSpeaker) {
         isSpeaker=YES;
        [self.speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker_act"] forState:UIControlStateNormal];
        APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
        APMPhone* phone = appDelegate.phone;
        [phone setSpeakerEnabled:isSpeaker];
       
        NSLog(@"Speaker ON");
    }
    
    else if (isSpeaker) {
         isSpeaker=NO;
        [self.speakerButton setBackgroundImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
        APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
        APMPhone* phone = appDelegate.phone;
        [phone setSpeakerEnabled:isSpeaker];
       
        NSLog(@"Speaker OFF");
    }
    
    
}

- (IBAction)mutedPress:(id)sender {
    
    if (!isMuted) {
        isMuted=YES;
        [self.muteButton setBackgroundImage:[UIImage imageNamed:@"muted_on"] forState:UIControlStateNormal];
        APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
        APMPhone* phone = appDelegate.phone;
        [phone setMuted:isMuted];
        
        NSLog(@"Muted ON");
    }
    
    else if (isMuted) {
        
        isMuted=NO;
        [self.muteButton setBackgroundImage:[UIImage imageNamed:@"muted_off"] forState:UIControlStateNormal];
        APMAppDelegate* appDelegate = (APMAppDelegate *)[UIApplication sharedApplication].delegate;
        APMPhone* phone = appDelegate.phone;
        [phone setMuted:isMuted];
        
        NSLog(@"Muted OFF");
    }

    
}
@end
