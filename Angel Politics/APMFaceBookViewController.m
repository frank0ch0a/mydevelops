//
//  APMFaceBookViewController.m
//  AngelPolitics
//
//  Created by Francisco on 10/01/14.
//  Copyright (c) 2014 angelpolitics. All rights reserved.
//

#import "APMFaceBookViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
@interface APMFaceBookViewController ()

@property (nonatomic, strong) NSArray *friendsList;
@property (strong, nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@end

@implementation APMFaceBookViewController


- (UIBarButtonItem *)postButton {
    
    
    _leftBarButtonItem= [[UIBarButtonItem alloc] initWithTitle:@"Add All" style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(addAll:)];
    
    
   [_leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barPattern"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    return _leftBarButtonItem;
}

- (void)addAll:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:@"Coming Soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    
    [alert show];
  
}

- (UIBarButtonItem *)doneButton {
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                         target:self
                                                         action:@selector(onDone:)];
    
     [_rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"barPattern"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    return _rightBarButtonItem;
}

- (void)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate dismissController:self];

    }];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Facebook Friends";
    
    self.navigationItem.leftBarButtonItem = [self postButton];
    
   
    
    self.navigationItem.rightBarButtonItem = [self doneButton];
    
     [self.fbTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [SVProgressHUD show];
    
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    id options = @{
                   ACFacebookAppIdKey: @"195886240597117",
                   ACFacebookPermissionsKey: @[ @"email", @"read_friendlists"],
                   ACFacebookAudienceKey: ACFacebookAudienceFriends
                   };
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType
                                               options:options
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSLog(@"Granted!");
                                                    ACAccount *fbAccount = [[self.accountStore accountsWithAccountType:facebookAccountType] lastObject];
                                                    [self fetchFacebookFriendsFor:fbAccount];
                                                    
                                                } else {
                                                    NSLog(@"Not granted: %@", error);
                                                }
                                                
                                            }];


}

- (void)fetchFacebookFriendsFor:(ACAccount *)facebookAccount {
  //  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    SLRequest *friendsListRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:URLIFY(@"https://graph.facebook.com/me/friends")
                                                          parameters:nil];
    friendsListRequest.account = facebookAccount;
    [friendsListRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSLog(@"Got a response: %@", [[NSString alloc] initWithData:responseData
                                                               encoding:NSUTF8StringEncoding]);
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError = nil;
                NSDictionary *friendsListData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                options:NSJSONReadingAllowFragments
                                                                                  error:&jsonError];
                if (jsonError) {
                    NSLog(@"Error parsing friends list: %@", jsonError);
                } else {
                    self.friendsList = friendsListData[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.fbTableView reloadData];
                    });
                }
            } else {
                NSLog(@"HTTP %d returned", urlResponse.statusCode);
            }
        } else {
            NSLog(@"ERROR Connecting");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
           // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [SVProgressHUD dismiss];
        });
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSDictionary *friend = self.friendsList[indexPath.row];
    NSLog(@"Friend: %@", friend);
    cell.textLabel.text = friend[@"name"];
    
    UIImage *defaultPhoto = [UIImage imageNamed:@"facebook_avatar"];
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", friend[@"id"]];
    NSURL *avatarUrl = URLIFY(urlString);
    
    [cell.imageView setImageWithURL:avatarUrl
                   placeholderImage:defaultPhoto];
    
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}



@end
