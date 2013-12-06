//
//  APMPhone.m
//  Angel Politics
//
//  Created by Francisco on 28/10/13.
//  Copyright (c) 2013 angelpolitics. All rights reserved.
//

#import "APMPhone.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation APMPhone

-(id)init
{
	if ( self = [super init] )
	{
        // Replace the URL with your Capabilities Token URL
		NSURL* url = [NSURL URLWithString:@"http://maravillatech.com/auth.php"];
		NSURLResponse*  response = nil;
		NSError*  	error = nil;
		NSData* data = [NSURLConnection sendSynchronousRequest:
						[NSURLRequest requestWithURL:url]
											 returningResponse:&response
														 error:&error];
		if (data)
		{
			NSHTTPURLResponse*  httpResponse = (NSHTTPURLResponse*)response;
			
			if (httpResponse.statusCode == 200)
			{
				NSString* capabilityToken = [[[NSString alloc] initWithData:data
                                                                   encoding:NSUTF8StringEncoding]
                                             autorelease];
				
				_device = [[TCDevice alloc] initWithCapabilityToken:capabilityToken
                                                           delegate:nil];
                
                
			}
			else
			{
				NSString*  errorString = [NSString stringWithFormat:
                                          @"HTTP status code %d",
                                          httpResponse.statusCode];
				NSLog(@"Error logging in: %@", errorString);
			}
		}
		else
		{
			NSLog(@"Error logging in: %@", [error localizedDescription]);
		}
	}
	return self;
}


-(void)dealloc
{
	[_device release];
    [_connection release];
	[super dealloc];
}

-(void)connect:(NSString *)phoneNumber
{
    
    NSDictionary* parameters = nil;
    if ( [phoneNumber length] > 0 )
    {
        parameters = [NSDictionary dictionaryWithObject:phoneNumber forKey:@"PhoneNumber"];
    }
    _connection = [_device connect:parameters delegate:nil];
    
    
    
    
    [_connection retain];
    
    
}

-(void)disconnect
{
    [_connection disconnect];
    [_connection release];
    _connection = nil;
}

-(void)setSpeakerEnabled:(BOOL)enabled
{
	_speakerEnabled = enabled;
	
	[self updateAudioRoute];
}



-(void)updateAudioRoute
{
	if (_speakerEnabled)
	{
		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
		
		AudioSessionSetProperty (
								 kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride
								 );
	}
	else
	{
		UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
		
		AudioSessionSetProperty (
								 kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride
								 );
	}
}


#pragma mark -
#pragma mark Mute

-(void)setMuted:(BOOL)muted
{
    _connection.muted = muted;
}

-(BOOL)muted
{
	return _connection.muted;
}


@end
