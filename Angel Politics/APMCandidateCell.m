//
//  APMCandidateCell.m
//  Angel Politics
//
//  Created by Francisco on 28/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMCandidateCell.h"

@implementation APMCandidateCell

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

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
    //Circle View
    CGPoint saveCenter = self.CandUIView.center;
    CGRect newFrame = CGRectMake(self.CandUIView.frame.origin.x, self.CandUIView.frame.origin.y, 65, 65);
    self.CandUIView.frame = newFrame;
    self.CandUIView.layer.cornerRadius = 65 / 2.0;
    self.CandUIView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.CandUIView.layer.borderWidth=0.9f;
    self.CandUIView.center = saveCenter;
    
    CGPoint saveCenter2 = self.candImageView.center;
    CGRect newFrame2 = CGRectMake(self.candImageView.frame.origin.x, self.candImageView.frame.origin.y, 65, 65);
    self.candImageView.frame = newFrame2;
    self.candImageView.layer.cornerRadius = 65 / 2.0;
    self.candImageView.center = saveCenter2;

    
    
    
}

@end
