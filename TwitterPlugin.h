//
//  TwitterPlugin.h
//  TwitterPlugin
//
//  Created by mootoh on 2007.12.12
//  License: revised BSD
//
#import <QSCore/QSObject.h>
#import "TwitterXAuth.h"

@class TwitterPluginGrowlHelper;

@interface TwitterPlugin : NSObject
{
}

+ (TwitterXAuth *) theTwitterXAuth;
+ (void) didFinishAuthorize;

@end