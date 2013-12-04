//
//  APMSearchResultsViewController.m
//  Angel Politics
//
//  Created by Francisco on 15/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMSearchResultsViewController.h"
#import "APMLeadsModel.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "KeychainItemWrapper.h"
#import "APMFrontViewController.h"
#import "TestFlight.h"

@interface APMSearchResultsViewController (){
    
    NSOperationQueue *queue;
    
}


@property(nonatomic,strong)NSMutableArray *searchResults;
@property(nonatomic,strong)KeychainItemWrapper *keychain;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *password;



@end

@implementation APMSearchResultsViewController

@synthesize arraySearch=_arraySearch;
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
    
    
    
    
    NSLog(@"arraySearch %@",self.arraySearch);
    
    if (self.arraySearch ==nil) {
        
        NSLog(@"Expect array");
        
        
        
    }else{
        
        [self parseSearchArray:self.arraySearch];
        
        [self.searchTableView reloadData];
        
    }
    
    
}


-(APMLeadsModel *)parseData:(NSDictionary *)dictionary
{
    APMLeadsModel *leadsModel=[[APMLeadsModel alloc]init];
    
    leadsModel.party=[dictionary objectForKey:@"a"];
    leadsModel.donorName=[dictionary objectForKey:@"b"];
    leadsModel.donorLastName=[dictionary objectForKey:@"c"];
    leadsModel.donorCity=[dictionary objectForKey:@"d"];
    leadsModel.donorState=[dictionary objectForKey:@"e"];
    leadsModel.donorPhoneNumber=[dictionary objectForKey:@"f"];
    leadsModel.donor_id=[dictionary objectForKey:@"g"];
    
    
    return leadsModel;
    
    
    
}

-(void)parseSearchArray:(NSArray *)array{
    
    
    self.searchResults=[[NSMutableArray alloc]init];
    
    for (NSDictionary *resultDict in array) {
        
        APMLeadsModel *leadsModel;
        
        leadsModel=[self parseData:resultDict];
        
        if(leadsModel !=nil){
            
            
            [self.searchResults addObject:leadsModel];
            
            
            
        }
        
        
    }
    
    
    
    
}


#pragma mark tableView DataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.searchResults.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier=@"Cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    APMLeadsModel *leadsModel=[self.searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",leadsModel.donorName,leadsModel.donorLastName];
    cell.textLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",leadsModel.donorCity,leadsModel.donorState];
    cell.detailTextLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f];
    
    UIImage *image = [UIImage imageNamed:@"btn_plus"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	button.frame = frame;	// match the button's size with the image size
    
	[button setBackgroundImage:image forState:UIControlStateNormal];

    
    // set the button's target to this table view controller so we can interpret touch events and map that to a NSIndexSet
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = button;
    
    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.searchTableView];
    
	NSIndexPath *indexPath = [self.searchTableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.searchTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    [TestFlight passCheckpoint:@"add to list Button"];
    
     APMLeadsModel *leadsModel=[self.searchResults objectAtIndex:indexPath.row];
    
    self.keychain=[[KeychainItemWrapper alloc]initWithIdentifier:@"APUser" accessGroup:nil];
    
    if ([_keychain objectForKey:(__bridge id)kSecAttrAccount]!=nil && [self.keychain objectForKey:(__bridge id)kSecValueData]!=nil) {
        
        self.email=[_keychain objectForKey:(__bridge id)kSecAttrAccount];
        self.password=[self.keychain objectForKey:(__bridge id)kSecValueData];
        
    }

    
    NSDictionary *dict=@{@"email":self.email ,@"pass":self.password,@"dn":leadsModel.donor_id};
    
    NSLog(@"Parameters %@",dict);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.angelpolitics.com"]];
    
    [httpClient setDefaultHeader:@"Content-Type" value:@"application/json"];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"/mobile/addtolist.php"
                                                      parameters:dict
                                    ];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        if ([[JSON objectForKey:@"a"] isEqualToString:@"Ok"]) {
            
            
            [self dismissViewControllerAnimated:YES completion:^{
                
               
               
                
            }];
         
            NSLog(@"Lead Added");
            
        }else{
            
        
            
            
            
            
            
        }
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"error %@", [error description]);
        
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    
    
    
    [queue addOperation:operation];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeSearch:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
