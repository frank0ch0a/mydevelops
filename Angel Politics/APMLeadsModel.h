//
//  APMLeadsModel.h
//  Angel Politics
//
//  Created by Francisco on 27/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APMLeadsModel : NSObject

@property(nonatomic,copy)NSString *ask;
@property(nonatomic,copy)NSString *donorName;
@property(nonatomic,copy)NSString *donorLastName;
@property(nonatomic,copy)NSString *donorCity;
@property(nonatomic,copy)NSString *donorState;
@property(nonatomic,copy)NSString *donorPhoneNumber;
@property(nonatomic,copy)NSString *donorEmail;
@property(nonatomic,copy)NSString *donor_id;
@property(nonatomic,copy)NSString *statusNet;
@property(nonatomic,copy)NSString *party;
@property(nonatomic,copy)NSString *pledgeID;
@property(nonatomic,copy)NSString *donorImg;
@property(nonatomic,copy)NSString *donorLkdHead;
@property(nonatomic,copy)NSString *country;
@property(nonatomic)NSInteger section;
@property(nonatomic,copy)NSString *zipCode;
@property(nonatomic,copy)NSString *street;
@property(nonatomic,copy)NSString *race;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *religion;

@property(nonatomic,assign)BOOL checked;
-(void)toggleChecked;


@end
