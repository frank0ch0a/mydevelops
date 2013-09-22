//
//  APMMenuViewController.m
//  Angel Politics
//
//  Created by Francisco on 22/09/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMMenuViewController.h"
#import "APMFrontViewController.h"
#import "NVSlideMenuController.h"
#import "MenuCell.h"

enum {
    MenuHomeRow = 0,
    MenuProfile,
    MenuFundRaising,
    MenuMessages,
    MenuSettings,
    MenuHelp,
    MenuRowCount
};


@interface APMMenuViewController ()

@end

@implementation APMMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    [self.tableView registerNib:[self menuCellNib] forCellReuseIdentifier:@"MenuCell"];
}

- (UINib *)menuCellNib {
    return [UINib nibWithNibName:@"MenuCell" bundle:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Menu";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MenuRowCount;
}

- (void)configureCell:(MenuCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MenuHomeRow:
            cell.menuLabel.text = @"Home";
            break;
            
        case MenuProfile:
            cell.menuLabel.text = @"Edit Profile";
            break;
            
        case MenuMessages:
            cell.menuLabel.text = @"Messages";
            break;
            
        case MenuSettings:
            cell.menuLabel.text = @"Settings";
            break;
            
        case MenuHelp:
            cell.menuLabel.text=@"Help";
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - table view delegate

- (BOOL)isShowingClass:(Class)class {
    UIViewController *controller = self.slideMenuController.contentViewController;
    if ([controller isKindOfClass:class]) {
        return YES;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)controller;
        if ([navController.visibleViewController isKindOfClass:class]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)showControllerClass:(Class)class {
    if ([self isShowingClass:class]) {
        [self.slideMenuController toggleMenuAnimated:self];
    } else {
        id mainVC = [[class alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
        [self.slideMenuController setContentViewController:nav
                                                  animated:YES
                                                completion:nil];
    }
}

- (void)showMainController {
    [self showControllerClass:[APMFrontViewController class]];
}

- (void)showAboutController {
    //[self showControllerClass:[AboutViewController class]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case MenuHomeRow:
            [self showMainController];
            break;
           /*
        case MenuAboutRow:
            [self showAboutController];
            break;*/
    }
}

@end
