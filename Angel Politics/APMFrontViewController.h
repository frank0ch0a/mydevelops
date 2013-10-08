//
//  APMFrontViewController.h
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class APMFrontViewController;
@class APMCandidateModel;
@protocol FrontViewDelegate <NSObject>

-(void)frontViewController:(APMFrontViewController *)frontViewController didCandidateData:(NSMutableArray *)array;

@end



@interface APMFrontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) id<FrontViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITableView *donorTableView;
@property (weak, nonatomic) IBOutlet UIButton *donorButton;

@property (weak, nonatomic) IBOutlet UIButton *pledgeButton;

@property (weak, nonatomic) IBOutlet UIButton *otherButton;

@end
