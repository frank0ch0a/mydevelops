//
//  MenuCell.m
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

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
    
    
    [super awakeFromNib];
    
    UIImage *selectedImage=[UIImage imageNamed:@"bg_menu_row_down"];
    UIImageView *selectBackgroundImageView=[[UIImageView alloc] initWithImage:selectedImage];
    self.selectedBackgroundView=selectBackgroundImageView;
    
    self.menuLabel.highlightedTextColor=[UIColor darkGrayColor];
    
    
    
}

@end
