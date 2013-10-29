//
//  APMPhone.h
//  Angel Politics
//
//  Created by Francisco on 28/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCDevice.h"

@interface APMPhone : NSObject
{
@private
	TCDevice* _device;
    TCConnection *_connection;
    
}

-(void)connect:(NSString *)phoneNumber;
-(void)disconnect;

@end
