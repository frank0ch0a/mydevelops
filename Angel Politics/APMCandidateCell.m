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
    
    //Circle View
    CGPoint saveCenter = self.candidatePhoto.center;
    CGRect newFrame = CGRectMake(self.candidatePhoto.frame.origin.x, self.candidatePhoto.frame.origin.y, 70, 70);
    self.candidatePhoto.frame = newFrame;
    self.candidatePhoto.layer.cornerRadius = 70 / 2.0;
    self.candidatePhoto.center = saveCenter;

    
    
    
}

@end
