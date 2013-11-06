//
//  DonorDetailCell.h
//  Angel Politics
//
//  Created by Francisco on 5/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonorDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *donorDetailUIView;
@property (weak, nonatomic) IBOutlet UIImageView *donorDetailImage;
@property (weak, nonatomic) IBOutlet UILabel *donorDetailNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *donorDetailDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *donorDetailAmountLabel;

@end
