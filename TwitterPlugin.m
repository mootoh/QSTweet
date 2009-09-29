//
//  TwitterPlugin.m
//  TwitterPlugin
//
//  Created by mootoh on 2007.12.12
//  License: revised BSD
//
#import "TwitterPlugin.h"
#import "TwitterPluginGrowlHelper.h"

TwitterPluginGrowlHelper *growlHelper;

@implementation TwitterPlugin

+ (void) load
{
   growlHelper = [[TwitterPluginGrowlHelper alloc] init];
}

- (void) dealloc
{
   [growlHelper release];
   [super dealloc];
}

@end