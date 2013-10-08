//
//  APMCandidateCell.h
//  Angel Politics
//
//  Created by Francisco on 28/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface APMCandidateCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *candidateNameLabel;

@property (weak, nonatomic) IBOutlet UIView *CandUIView;
@property (weak, nonatomic) IBOutlet UIImageView *candImageView;

@end
