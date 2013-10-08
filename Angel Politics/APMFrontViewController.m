//
//  APMFrontViewController.m
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMFrontViewController.h"
#import "NVSlideMenuController.h"
#import "AFJSONRequestOperation.h"
#import "APMCandidateModel.h"
#import "APMCandidateViewController.h"


@interface APMFrontViewController ()

// Lazy buttons
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;

@property(strong,nonatomic)NSArray *donors;

@end

@implementation APMFrontViewController{
    
      NSOperationQueue *queue;
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if ((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        queue=[[NSOperationQueue alloc]init];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:NO];
    
    self.title=@"Angel Politics";
    
    //Hardcoding donorsinfo
    
    self.donors=@[@"Pascal Dupree",@"Adan Nichelson",@"John Forrester",@"Sander Kleinenberg",@"Michelle Stuart"];
                    
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.donorButton.layer.borderWidth=1.0f;
    self.donorButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.pledgeButton.layer.borderWidth=1.0f;
    self.pledgeButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    self.otherButton.layer.borderWidth=1.0f;
    self.otherButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    
    
}

-(void)showNetworkError
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Whoops.."
                                                     message:@"There was sn error reading from Server. please try again." delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil ];
    
    [alertView show];
    
    
    
}

-(void)parseDictionary:(NSDictionary *)dictionary{
    
    
    NSMutableArray *arrayDic=[[NSMutableArray alloc]init];
    
    [arrayDic addObject:dictionary];
    
    

    
    APMCandidateModel *candidateModel=[[APMCandidateModel alloc]init];
    
     NSMutableArray *array=[[NSMutableArray alloc]init];
    
    for (int i=0; i<[arrayDic count]; i++) {
        
   
        candidateModel.candidateName=[[arrayDic objectAtIndex:i]objectForKey:@"a"];
        candidateModel.city=[[arrayDic objectAtIndex:i]objectForKey:@"b"];
        candidateModel.supportes=[[arrayDic objectAtIndex:i]objectForKey:@"c"];
        candidateModel.funraised=[[arrayDic objectAtIndex:i]objectForKey:@"d"];
        candidateModel.dayToElection=[[arrayDic objectAtIndex:i]objectForKey:@"e"];
        
        
        [array addObject:candidateModel];
    }
    
    
    NSLog(@"array %@",array);
    
    [self.delegate frontViewController:self didCandidateData:array];
    
    
    
}

-(void)loadData{
    
   
    
    NSURL *url=[NSURL URLWithString:@"https://www.angelpolitics.com/mobile/first.php?id=1351"];
    
   
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         NSLog(@"Success!");
        [self parseDictionary:JSON];
        
       
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self showNetworkError];
        
        NSLog(@"error  %@",error);
       
        //[self.donorTableView reloadData];
    }];
    
    operation.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/json",@"text/html", nil];
    
    [queue addOperation:operation];
    
    
}

#pragma mark - Lazy buttons

- (UIImage *)listImage {
    return [UIImage imageNamed:@"ic_menu"];
}
- (UIImage *)searchImage {
    return [UIImage imageNamed:@"ic_Search"];
}


- (UIBarButtonItem *)leftBarButtonItem
{
	if (!_leftBarButtonItem)
	{
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self listImage]
                                         style:UIBarButtonItemStyleBordered
                                        target:self.slideMenuController
                                        action:@selector(toggleMenuAnimated:)];
        
        [_leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barPattern"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        /*
        
		_leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
																		   target:self.slideMenuController
																		   action:@selector(toggleMenuAnimated:)];*/
	}
	return _leftBarButtonItem;
}

-(UIBarButtonItem *)rightBarButtonItem;
{
    
    
	if (!_rightBarButtonItem)
	{
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[self searchImage]
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(mainSearch:)];
        
        
        [_rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barPattern"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    }
    
    
    return _rightBarButtonItem;
    
    
}


-(void)mainSearch:(id)sender {
    
    NSLog(@" Search Button");
    
}

- (void)updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:(BOOL)animated
{
    if (self.slideMenuController.slideDirection == NVSlideMenuControllerSlideFromLeftToRight)
	{
		[self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:animated];
        [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:animated];
	
	}
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.donors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text=[self.donors objectAtIndex:indexPath.row];
    
      
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    APMCandidateViewController *candidateVC=[[APMCandidateViewController alloc]init];
    
    [self.navigationController pushViewController:candidateVC animated:YES];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
