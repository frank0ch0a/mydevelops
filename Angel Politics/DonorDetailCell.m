//
//  DonorDetailCell.m
//  Angel Politics
//
//  Created by Francisco on 5/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "DonorDetailCell.h"

@implementation DonorDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)awakeFromNib{
    
    //Circle View
    CGPoint saveCenter = self.donorDetailUIView.center;
    CGRect newFrame = CGRectMake(self.donorDetailUIView.frame.origin.x, self.donorDetailUIView.frame.origin.y, 45, 45);
    self.donorDetailUIView.frame = newFrame;
     self.donorDetailUIView.layer.cornerRadius = 45 / 2.0;
    self.donorDetailUIView.center = saveCenter;
    
    //Circle  Image View
    CGPoint saveCenter2 = self.donorDetailImage.center;
    CGRect newFrame2 = CGRectMake(self.donorDetailImage.frame.origin.x, self.donorDetailImage.frame.origin.y, 45, 45);
    self.donorDetailImage.frame = newFrame2;
    self.donorDetailImage.layer.cornerRadius = 45 / 2.0;
    self.donorDetailImage.center = saveCenter2;
    
    
    self.donorDetailNameLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    self.donorDetailDateLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.donorDetailAmountLabel.font=[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15];
    
    
}

@end
