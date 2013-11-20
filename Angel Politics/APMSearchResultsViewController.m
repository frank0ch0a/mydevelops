//
//  APMSearchResultsViewController.m
//  Angel Politics
//
//  Created by Francisco on 15/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMSearchResultsViewController.h"
#import "APMLeadsModel.h"

@interface APMSearchResultsViewController ()


@property(nonatomic,strong)NSMutableArray *searchResults;

@end

@implementation APMSearchResultsViewController

@synthesize arraySearch=_arraySearch;
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
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",leadsModel.donorCity,leadsModel.donorState];
    
    return cell;
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
