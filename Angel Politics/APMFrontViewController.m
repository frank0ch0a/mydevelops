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

@interface APMFrontViewController ()

// Lazy buttons
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
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
                                                     message:@"There was sn error reading from itunes Store. please try again." delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil ];
    
    [alertView show];
    
    
    
}

-(void)parseDictionary:(NSDictionary *)dictionary{
    
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    [array addObject:dictionary];
    
    NSLog(@"array %@",array);
    
    
    
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
    return [UIImage imageNamed:@"list"];
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

- (void)updateBarButtonsAccordingToSlideMenuControllerDirectionAnimated:(BOOL)animated
{
    if (self.slideMenuController.slideDirection == NVSlideMenuControllerSlideFromLeftToRight)
	{
		[self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:animated];
	
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
