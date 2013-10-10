//
//  APMCandidateViewController.h
//  Angel Politics
//
//  Created by Francisco on 28/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APMCandidateViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *donorLabel;
@property (weak, nonatomic) IBOutlet UITableView *candTableView;
- (IBAction)callOutcome:(id)sender;

@end
