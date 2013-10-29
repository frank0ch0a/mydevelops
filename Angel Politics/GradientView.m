//
//  GradientView.m
//  Angel Politics
//
//  Created by Francisco on 28/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}


//Creamos el fondo del contenedor
- (void)drawRect:(CGRect)rect
{
    const CGFloat components[8]={0.0f,0.0f,0.0f,0.3f,0.0f,0.0f,0.0f,0.7f};
    
    const CGFloat locations[2]={0.0f,1.0f};
    
    CGColorSpaceRef space=CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient=CGGradientCreateWithColorComponents(space, components, locations, 2);
    
    CGColorSpaceRelease(space);
    
    CGFloat x=CGRectGetMidX(self.bounds);
    CGFloat y=CGRectGetMidY(self.bounds);
    
    CGPoint point=CGPointMake(x, y);
    CGFloat radius=MAX(x, y);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
}

@end
