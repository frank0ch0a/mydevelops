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

@interface APMEditCandProfileViewController (){
    
    NSString *active;
    
}

@property(strong,nonatomic)KeychainItemWrapper *keychain;
@property(copy,nonatomic)NSString *email;
@property(nonatomic,copy)NSString *password;

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
    
    
    
    //NSLog(@"email %@",[_keychain objectForKey:(__bridge id)kSecAttrAccount]);
    // NSLog(@"password: %@",[self.keychain objectForKey:(__bridge id)kSecValueData]);
    
    
   self.editCandidateName.delegate=self;
    
    self.editPhone1.delegate=self;
   self.editPhone2.delegate=self;
   self.editPhone3.delegate=self;
    
    

    
    
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
    
    
    [self.delegate configEditDidUpdate:self];
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil &&[self.keychain objectForKey:(__bridge id)kSecValueData]!=nil ) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
        
        
        
    
        if (active ==nil) {
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

    
    
    
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
    
    
}
- (IBAction)closeEdit:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
