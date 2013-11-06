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
    CGRect newFrame = CGRectMake(self.donorDetailUIView.frame.origin.x, self.donorDetailUIView.frame.origin.y, 50, 50);
    self.donorDetailUIView.frame = newFrame;
    self.donorDetailUIView.center = saveCenter;
    
    
    
    
}

@end
