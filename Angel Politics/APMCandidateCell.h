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

@property (weak, nonatomic) IBOutlet UIView *colorBgPartyUIView;

@property (weak, nonatomic) IBOutlet UILabel *candidateNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *candidateOficceAndCityLabel;

@property (weak, nonatomic) IBOutlet UILabel *candidateSupportersLabel;
@property (weak, nonatomic) IBOutlet UILabel *candidateFundRaisedLabel;
@property (weak, nonatomic) IBOutlet UILabel *candidateDayToElectLabel;


@property (weak, nonatomic) IBOutlet UIView *CandUIView;
@property (weak, nonatomic) IBOutlet UIImageView *candImageView;

@end
