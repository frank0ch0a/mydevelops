//
//  APMLeadsModel.m
//  Angel Politics
//
//  Created by Francisco on 27/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMLeadsModel.h"

@implementation APMLeadsModel
@synthesize ask;
@synthesize donorName;
@synthesize donorLastName;
@synthesize donorCity;
@synthesize donorState;
@synthesize donorPhoneNumber;
@synthesize donorEmail;
@synthesize donor_id;
@synthesize statusNet;
@synthesize party;
@synthesize pledgeID;
@synthesize section;
@synthesize zipCode;
@synthesize street;
@synthesize  donorImg;
@synthesize  donorLkdHead;
@synthesize country;
@synthesize age;
@synthesize race;
@synthesize religion;

-(void)toggleChecked
{

    self.checked=!self.checked;

    
    
}

@end
