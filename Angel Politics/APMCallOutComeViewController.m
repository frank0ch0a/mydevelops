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
#import "APMLeadsModel.h"
#import "APMDetailModel.h"
#import "APMFrontViewController.h"

@interface APMCallOutComeViewController (){
    
    CGFloat ymainView;
    NSString *candId;
    NSString *donorId;
}

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

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.title=@"Call Outcome";
    
    self.askLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25];
    self.bestLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    self.averageLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    self.callOutcomeLabel.font=[UIFont fontWithName:@"Helvetica75" size:17];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ymainView=self.mainCallOutUIView.frame.origin.y;
    
    // Do any additional setup after loading the view from its nib.
    
   self.callStatus=@[@"Pending",@"Busy",@"No Answer",@"Voicemail",@"Wrong Number"];
    
    self.pledge=@[@"Volunteer",@"Pledge",@"Events",@"Credit card payments",@"Will not donate now",@"Will not donate ever"];
    
    
    self.amountPledgeTextField.delegate=self;
    self.pledgeTextField.delegate=self;
    
    self.nameLabel.text=[NSString stringWithFormat:@"%@ %@",self.detailModel.name,self.detailModel.lastName];
    self.askLabel.text=self.detailModel.ask;
    self.bestLabel.text=self.detailModel.best;
    self.averageLabel.text=self.detailModel.average;
    self.cityAndStateLabel.text=[NSString stringWithFormat:@"%@, %@",self.detailModel.city,self.detailModel.state];
    
    donorId=self.detailModel.donor_id;
    candId=self.detailModel.cand_id;
    
    
       NSLog(@"candid %@ y donorid %@",candId,donorId);
    
    
    
   
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
        
        if ([self.pledgeTextField.text isEqualToString:@"Pledge"]) {
            
            APMCallViewController *apmCallVC=[[APMCallViewController alloc]init];
            
            apmCallVC.delegate=self;
            
            apmCallVC.candID=candId;
            apmCallVC.donorID=donorId;
            
            [self presentViewController:apmCallVC animated:YES completion:nil];
            
           
            
        }
        
    }];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField==self.amountPledgeTextField) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.mainCallOutUIView.frame=CGRectMake(self.mainCallOutUIView.frame.origin.x
                                                    , -200.0f,self.mainCallOutUIView.frame.size.width , self.mainCallOutUIView.frame.size.height);
            
            
            
        } completion:nil];
        
    }else if (textField==self.pledgeTextField && [self.pledgeTextField.text isEqualToString:@"Pledge"] ){
        
        APMCallViewController *apmCallVC=[[APMCallViewController alloc]init];
        
    
        
        [self presentViewController:apmCallVC animated:YES completion:nil];
        
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.mainCallOutUIView.frame=CGRectMake(self.mainCallOutUIView.frame.origin.x
                                                , ymainView,self.mainCallOutUIView.frame.size.width , self.mainCallOutUIView.frame.size.height);
        
        [self.amountPledgeTextField resignFirstResponder];
        
    } completion:nil];
    
    return YES;
    
}

#pragma mark CallView Delegate

-(void)CallViewDidDismiss:(APMCallViewController *)controller
{
    
     [self dismissViewControllerAnimated:NO completion:nil];
    
    APMFrontViewController *fronVC=[[APMFrontViewController alloc]init];
    
    [self.navigationController pushViewController:fronVC animated:YES];
    
    
    
}

@end
