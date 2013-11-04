//
//  APMCallOutComeViewController.m
//  Angel Politics
//
//  Created by Francisco on 8/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMCallOutComeViewController.h"
#import "APMCallViewController.h"
#import "ModalPickerView.h"

@interface APMCallOutComeViewController ()

@property(nonatomic,strong)NSArray *callStatus;
@property(nonatomic,strong) NSArray *pledge;

@end

@implementation APMCallOutComeViewController

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
    
   self.callStatus=@[@"Pending",@"Busy",@"No Answer",@"Voicemail",@"Wrong Number"];
    
    self.pledge=@[@"Volunteer",@"Pledge",@"Events",@"Credit card payments",@"Will not donate now",@"Will not donate ever"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callStatusButton:(id)sender {
    
    ModalPickerView *pickerView=[[ModalPickerView alloc]initWithValues:self.callStatus];
    
    [pickerView presentInView:self.view withBlock:^(BOOL madeChoice) {
        NSLog(@"Made choice? %d", madeChoice);
        NSLog(@"Selected value: %@", pickerView.selectedValue);
        
        self.callStatusTextField.text=pickerView.selectedValue;
        
    }];

    
}

- (IBAction)pledgeButton:(id)sender {
    
    
    ModalPickerView *pickerView=[[ModalPickerView alloc]initWithValues:self.pledge];
    
    [pickerView presentInView:self.view withBlock:^(BOOL madeChoice) {
        NSLog(@"Made choice? %d", madeChoice);
        NSLog(@"Selected value: %@", pickerView.selectedValue);
        
        self.pledgeTextField.text=pickerView.selectedValue;
        
    }];
}

- (IBAction)dialButton:(id)sender {
    
    APMCallViewController *apmCallVC=[[APMCallViewController alloc]init];
    
    [self.view addSubview:apmCallVC.view];
    [self addChildViewController:apmCallVC];
    [apmCallVC didMoveToParentViewController:self];
}
@end
