//
//  APMFrontCellProtocol.h
//  Angel Politics
//
//  Created by Francisco on 7/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APMFrontCellProtocol <NSObject>

-(void)didSwipeRightInCellWithIndexPath:(NSIndexPath *)indexPath;
-(void)didSwipeLeftInCellWithIndexPath:(NSIndexPath *)indexPath;


@end
