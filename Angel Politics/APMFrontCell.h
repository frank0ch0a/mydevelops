//
//  APMFrontCell.h
//  Angel Politics
//
//  Created by Francisco on 7/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APMFrontCellProtocol.h"
#import <QuartzCore/QuartzCore.h>

@interface APMFrontCell : UITableViewCell

@property (nonatomic, weak) id <APMFrontCellProtocol> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIView *swipeView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *donorLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

-(IBAction)didSwipeRightInCell:(id)sender;
-(IBAction)didSwipeLeftInCell:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *donorTypeLabel;


@end
