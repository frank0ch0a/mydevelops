//
//  APMSearchResultsViewController.h
//  Angel Politics
//
//  Created by Francisco on 15/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APMSearchResultsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *arraySearch;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

- (IBAction)closeSearch:(id)sender;
@end
