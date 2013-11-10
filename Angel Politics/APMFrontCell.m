//
//  APMFrontCell.m
//  Angel Politics
//
//  Created by Francisco on 7/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMFrontCell.h"

@implementation APMFrontCell
@synthesize swipeView = _swipeView;
@synthesize topView = _topView;
@synthesize indexPath = _indexPath;
@synthesize delegate;
 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
      
        
        self.swipeView.hidden=YES;
        
        // Create the gesture recognizers
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRightInCell:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeftInCell:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        [self addGestureRecognizer:swipeRight];
        [self addGestureRecognizer:swipeLeft];
        
        
        
        // Prevent selection highlighting
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)didSwipeRightInCell:(id)sender {
    
    // Inform the delegate of the right swipe
    [delegate didSwipeRightInCellWithIndexPath:_indexPath];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    // Swipe top view left
    [UIView animateWithDuration:1.0 animations:^{
        
        [self.topView setFrame:CGRectMake(self.contentView.frame.size.width, 0, self.contentView.frame.size.width, 65)];
        
    } completion:^(BOOL finished) {
        
        // Bounce lower view
        [UIView animateWithDuration:0.15 animations:^{
            
            [_swipeView setFrame:CGRectMake(10, 0, self.contentView.frame.size.width, 65)];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15 animations:^{
                [_swipeView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 65)];
            }];
        }];
    }];
    
}

-(IBAction)didSwipeLeftInCell:(id)sender {
    
    // Inform the delegate of the left swipe
    [delegate didSwipeLeftInCellWithIndexPath:_indexPath];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView animateWithDuration:1.0 animations:^{
        [_topView setFrame:CGRectMake(-10, 0, self.contentView.frame.size.width, 65)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            [_topView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 65)];
        }];
    }];
    
}


-(void)awakeFromNib
{
    
    [super awakeFromNib];
    
    self.swipeView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_menu_row_up"]];
    
    
    
    
}



@end
