//
//  TwitterPluginGrowlHelper.m
//  TwitterPlugin
//
//  Created by Motohiro Takayama on 9/29/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "TwitterPluginGrowlHelper.h"
#import <Growl/Growl.h>


@implementation TwitterPluginGrowlHelper

- (id) init
{
   if (self = [super init]) {
      [GrowlApplicationBridge setGrowlDelegate:self];
   }
   [GrowlApplicationBridge setGrowlDelegate:self];
   return self;
}

- (NSDictionary *) registrationDictionaryForGrowl
{
   NSArray *keys = [NSArray arrayWithObjects:GROWL_NOTIFICATIONS_ALL,GROWL_NOTIFICATIONS_DEFAULT, nil];
   NSArray *vals = [NSArray arrayWithObjects:[NSArray arrayWithObject:@"New Tweet"], [NSArray arrayWithObject:@"New Tweet"], nil];
   return [NSDictionary dictionaryWithObjects:vals forKeys:keys];
}

- (NSString *) applicationNameForGrowl
{
   return @"QSTwitter";
}

#if 0
- (NSData *) applicationIconDataForGrowl
{
   NSLog(@"icon image = %p",  [QSResourceManager imageNamed:@"girl_square"]);
   NSLog(@"icon image data = %p",  [[QSResourceManager imageNamed:@"girl_square"] TIFFRepresentation]);
   return [[QSResourceManager imageNamed:@"girl_square"] TIFFRepresentation];
}
#endif // 0

@end