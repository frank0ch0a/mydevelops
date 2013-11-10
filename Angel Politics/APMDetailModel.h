//
//  APMDetailModel.h
//  Angel Politics
//
//  Created by Francisco on 4/11/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APMDetailModel : NSObject

@property(nonatomic,copy)NSString *ask;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *lastName;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *party;
@property(nonatomic,copy)NSString *average;
@property(nonatomic,copy)NSString *best;
@property(nonatomic,copy)NSString *highlights1;
@property(nonatomic,copy)NSString *highlights2;
@property(nonatomic,copy)NSString *supportName;
@property(nonatomic,copy)NSString *supportAmount;
@property(nonatomic,strong)NSArray *detalles;
@property(nonatomic,copy)NSString *cand_id;
@property(nonatomic,copy)NSString *donor_id;

@end
