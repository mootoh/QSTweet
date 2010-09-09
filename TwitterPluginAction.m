//
//  TwitterPluginAction.m
//  TwitterPlugin
//
//  Created by mootoh on 2007.12.12
//  License: revised BSD
//
#import "TwitterPlugin.h"
#import "TwitterPluginAction.h"
#import "TwitterPluginShared.h"
#import <QSCore/QSTextProxy.h>
#import <Growl/Growl.h>

@implementation TwitterPluginAction

- (QSObject *) post:(QSObject *)dObject to:(QSObject *)ind
{
/*
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   if (! [defaults boolForKey:@"TwitterPlugin.authorized"]) {
      NSError *err = nil;
      [GrowlApplicationBridge
       notifyWithTitle:@"QSTweet"
       description:err ? [err localizedDescription] : @"not logged in yet"
       notificationName:@"NotAuthorized"
       iconData:nil
       priority:0
       isSticky:NO
       clickContext:nil];
      
      return dObject;
   }
*/
  NSString *optional = @"";
  if (ind) {
    NSString *fr = [ind stringValue];
    if ((![fr isEqualToString:@""] && (![fr isEqualToString:PUBLIC]))) {
      optional = [NSString stringWithFormat:@"@%@ ", fr];
    }
  }

  // construct request body
  NSString *content = [dObject stringValue];

//  content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//  content = [content stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//  content = [content stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//  content = [content stringByAppendingString:optional];

   [[TwitterPlugin theTwitterXAuth] tweet:content];

   NSError *err = nil;
   [GrowlApplicationBridge
     notifyWithTitle:@"QSTwitter"
     description:err ? [err localizedDescription] : @"tweeted ♪"
     notificationName:@"New Tweet"
     iconData:nil
     priority:0
     isSticky:NO
    clickContext:nil];
   
  return dObject;
}

- (NSArray *) validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)dobj
{
  return [action isEqualToString:@"TwitterPluginType"] ?
      nil
    : [NSArray arrayWithObject:[QSObject textProxyObjectWithDefaultValue:@""]]
    ;
}

@end