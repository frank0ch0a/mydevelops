//
//  APMTourTipsViewController.h
//  AngelPolitics
//
//  Created by Francisco on 22/01/14.
//  Copyright (c) 2014 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APMCallHelpViewController.h"

@interface APMTourTipsViewController : UIViewController<CallHelpDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *exampleLabel;
- (IBAction)nextTip:(id)sender;
- (IBAction)testCall:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextipButton;
@property (weak, nonatomic) IBOutlet UIButton *testCallButton;
- (IBAction)closeTip:(id)sender;

@end
