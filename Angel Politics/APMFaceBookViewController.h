//
//  APMFaceBookViewController.h
//  AngelPolitics
//
//  Created by Francisco on 10/01/14.
//  Copyright (c) 2014 angelpolitics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface APMFaceBookViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>

@property (nonatomic,strong)ACAccountStore *accountStore;

@property (weak, nonatomic) IBOutlet UITableView *fbTableView;



@end
